; Reinitializing SDE 
(sde:clear)
; set coordinate system up direction (DF-ISE)
; z: up x: channel length y: gate with
(sde:set-process-up-direction "+z")

############ device parameters ##########
#- structure parameter
##- channel parameter
(define Lgate (* 1e-3 30 ))
#(define Lgap 2e-3)
(define Hfin 0.04)
(define Wfin 0.014)
(define Tox (* 2.0 1e-3 ))
###- corner
(define Rfin 1e-3)
(define FinAngle 86)
(define sin_theta (sin ( / (* FinAngle PI ) 180) ) )
(define cos_theta (cos ( / (* FinAngle PI ) 180) ) )

##--source & drain 
(define Lsource 15e-3)
(define Ldrain Lsource)

##--STI 
(define Hsti 0.06)
(define Hbulk 0.2)

##--bulk
(define Xmax (+ Lgate Ldrain))
(define Xmin (* -1 Lsource)) ; source-channel junction zero-coordinate in x-axis

(define Ymax (/ Wfin  1))
(define Ymin (/ Wfin -1))

(define Zmin (- 0 Hsti Hbulk))

#############function##################
(define create_trapzoid 
	(lambda (x0 y0 z0 w h l theta rmater rname r_rounding_top r_rounding_bot direction) 
		
		(define sin_theta (sin ( / (* theta PI ) 180) ) )
		(define cos_theta (cos ( / (* theta PI ) 180) ) )	
		                                         
		(define pbot_left_y  (/ w -2) )
		(define pbot_right_y (/ w  2) )
		
		(define pdy (* h (/ cos_theta sin_theta)  ) )
		
		(define ptop_left_y  (+ pbot_left_y  pdy ) )
		(define ptop_right_y (- pbot_right_y pdy ) )
		
		(define polygon_list (list 
								 (position x0 pbot_left_y  z0)
								 (position x0 pbot_right_y z0)
								 (position x0 ptop_right_y (+ z0 h))
								 (position x0 ptop_left_y  (+ z0 h))
							 )
		)
		
		(define polygon_1 (sdegeo:create-polygon polygon_list rmater rname))

		##--sweep polygon
		(sdegeo:sweep polygon_1 (gvector (* l direction) 0 0 ) 
		(sweep:options "solid" #t "rigid" #f "miter_type" "default"))
		
		(if (> r_rounding_top 0)
			(begin
				(sdegeo:fillet (find-edge-id (position (/ (+ x0 x0 (* direction l)) 2) ptop_right_y (+ z0 h ))) r_rounding_top)
				(sdegeo:fillet (find-edge-id (position (/ (+ x0 x0 (* direction l)) 2) ptop_left_y  (+ z0 h ))) r_rounding_top)
			)
		); endif
		
		(if (> r_rounding_bot 0 )
			(begin	
				(sdegeo:fillet (find-edge-id (position (/ (+ x0 x0 (* direction l)) 2) pbot_right_y  z0)) r_rounding_bot)
				(sdegeo:fillet (find-edge-id (position (/ (+ x0 x0 (* direction l)) 2) pbot_left_y   z0)) r_rounding_bot)
			)
		);endif
	);lambda	
); function end 
######################################################

(if (string=? "@structure@" "FinFET")
	(begin
		#--generate source region
		(create_trapzoid  (* -1 Lsource)  0  0   Wfin  Hfin  Lsource  FinAngle "Silicon" "R.source" Rfin 0 1)
		#--generate channel region
		(create_trapzoid  0  0  0   Wfin  Hfin  Lgate  FinAngle "Silicon" "R.channel" Rfin 0 1)
		(sdegeo:set-default-boolean "BAB")
		#--generate gate oxide
		(create_trapzoid 0 0 0 (+ Wfin (* 2 (/ Tox sin_theta))) ( + Hfin Tox) Lgate FinAngle "HfO2" "R.gox" (+ Rfin Tox) 0 1)
		#--generate drain region
		(create_trapzoid  Lgate  0  0   Wfin  Hfin  Ldrain  FinAngle "Silicon" "R.drain" Rfin 0 1)
		#--generate bulk fin
		(create_trapzoid  (* -1 Lsource)  0  0   Wfin  (* Hsti -1.0)  (+ Lsource Ldrain Lgate)  FinAngle "Silicon" "R.channel" 0.0 0.0 1)
		#--generate STI
		(sdegeo:set-default-boolean "BAB")
		(sdegeo:create-cuboid (position (* -1 Lsource) Ymin 	    0  		 ) (position (+ Lgate Ldrain) Ymax (* -1 Hsti) )  "SiO2" "R.STI")
		#--generate bulk silicon 
		(sdegeo:create-cuboid (position (* -1 Lsource) Ymin (- 0 Hsti Hbulk) ) (position (+ Lgate Ldrain) Ymax (* -1 Hsti) ) "Silicon" "R.bulk")
	); end-FinFET
	(begin 
		
		#--define the gap between the gate and source/drain 
		(define LnwGap 4e-3)
		
		#--generate source region
		(create_trapzoid  (* -1 Lsource)  0  0   Wfin  Hfin  (- Lsource LnwGap)  FinAngle "Silicon" "R.source" Rfin 0 1)
		#--generate stacked nanowires
		(define NanoWireThickness 3e-3) ;thickness of the nanowire
		(define NumOfStacks 		 4)	;number of the stacked nanowires
		
		(define dStack (/ Hfin NumOfStacks))  
		(define Hnw NanoWireThickness)
		(define Hgap (- dStack Hnw)) ;gap between the nanowires in z-axis
		
		(define sin_theta (sin ( / (* FinAngle PI ) 180)))
		(define cos_theta (cos ( / (* FinAngle PI ) 180)))
		(define cot_theta (/ cos_theta sin_theta) )
		
		(define dy (* dStack cot_theta ))
		
		##-check the validity of the gap between the nanowires
		(if (< Hgap (* 2 Tox))
			(display "Error: Stacked Gap is too small or the thickness of the gateoxide is too thick!!!")
		)
		
		##-generate stacked channels 
		(define Wnw (- Wfin (* 2 (* Hgap cot_theta))))
		(define xnw0 0)
		(define ynw0 0)
		(define znw0 Hgap)
		(sdegeo:set-default-boolean "ABA")
		
		(do	((i 1 (+ i 1))) ((> i NumOfStacks))
			##source  drain ext region
			(create_trapzoid (* -1 LnwGap) ynw0 znw0  Wnw Hnw LnwGap  FinAngle "Silicon" (string-append "R.naowirie_gap_source" (number->string i)) Rfin Rfin 1 )
			(create_trapzoid  Lgate        ynw0 znw0  Wnw Hnw LnwGap  FinAngle "Silicon" (string-append "R.naowirie_gap_drain" (number->string i)) Rfin Rfin 1)

			## gate oxide
			(create_trapzoid  xnw0  ynw0 (- znw0 Tox)   (+ Wnw (* 2 (/ Tox sin_theta)) ( * (* 2 Tox) cot_theta)) ( + Hnw Tox Tox)  Lgate  FinAngle "HfO2" (string-append "R.gox" (number->string i)) (+ Tox Rfin) (+ Tox Rfin) 1)
 
			## channel
			(create_trapzoid  xnw0  ynw0 znw0  Wnw Hnw  Lgate  FinAngle "Silicon" (string-append "R.nanowirie" (number->string i)) Rfin Rfin 1)

			(set! Wnw 	(-	Wnw		(* 2	dy	)	)	)
			(set! znw0 	(+	znw0		dStack		)	)	
		)
		#--generate HfO2 on Bulk Fin
		(sdegeo:create-cuboid (position  0 Ymin 0 ) (position Lgate Ymax Tox ) "HfO2" "R.gox_bulk")
		#--generate drain region
		(create_trapzoid (+ Lgate Ldrain) 0 0 Wfin Hfin (- Ldrain LnwGap) FinAngle "Silicon" "R.drain" Rfin 0 -1)
		#--generate bulk fin
		(create_trapzoid (* -1 Lsource) 0 0 Wfin (* -1 Hsti) (+ Lsource Ldrain Lgate) FinAngle "Silicon" "R.bulkFin" 0 0 1)
		#--generate bulk silicon
		(sdegeo:set-default-boolean "BAB")
		(sdegeo:create-cuboid (position (* -1 Lsource) Ymin 0 ) (position (+ Lgate Ldrain) Ymax (* -1 Hsti) ) "SiO2" "R.STI")
		#--generate bulk silicon 
		(sdegeo:create-cuboid (position (* -1 Lsource) Ymin (- 0 Hsti Hbulk) ) (position (+ Lgate Ldrain) Ymax (* -1 Hsti) ) "Silicon" "R.bulk")
	)
);end-if

############### contact defination ###############
;----define-contact
(sdegeo:define-contact-set "source" 4.0  (color:rgb 0.0 1.0 0.0 )  )
(sdegeo:set-current-contact-set "source")
(sdegeo:set-contact-faces  (find-face-id (position (* -1 Lsource) 0 (/ Hfin 2) )) ) 

 
(sdegeo:define-contact-set "drain" 4.0  (color:rgb 0.0 1.0 0.0 )  )
(sdegeo:set-current-contact-set "drain")
(sdegeo:set-contact-faces  (find-face-id (position (+ Lgate Ldrain) 0 (/ Hfin 2) )) ) 

(sdegeo:define-contact-set "substrate" 4.0  (color:rgb 0.0 1.0 0.0 )  )
(sdegeo:set-current-contact-set "substrate")
(sdegeo:set-contact-faces  (find-face-id (position 0 0 (- 0 Hsti Hbulk) )) ) 

(sdegeo:set-default-boolean "BAB")
(define Gate_Region (sdegeo:create-cuboid (position 0 Ymin 0) (position Lgate Ymax (+ Hfin (* 2 Tox)) ) "Aluminum" "Gate"))

(sdegeo:define-contact-set "gate" 4.0  (color:rgb 0.0 1.0 0.0 )  )
(sdegeo:set-current-contact-set "gate")
(sdegeo:set-contact-boundary-faces Gate_Region)  
(sdegeo:delete-region Gate_Region)
 

############### doping profile ###############
;----define-doping
(define Nchanel 1e17)
(define Nsource_drain 1e20)
(define Nbulk 1e15)



(if (string=? "@Type1@" "NMOS" )
	(begin
			(define channel_Dopant "BoronActiveConcentration")
			(define source_drain_Dopant "PhosphorusActiveConcentration")	
	)
	(begin
			(define channel_Dopant "PhosphorusActiveConcentration")
			(define source_drain_Dopant "BoronActiveConcentration")	
	)
)
#########homework#########
##---doping in the gap(extention) region between source/drain and channel
;
;
;
;

#########homework#########
(sdedr:define-constant-profile "SD_Dop" source_drain_Dopant Nsource_drain)
(sdedr:define-constant-profile-region "Source_Dop_PL" "SD_Dop" "R.source")
(sdedr:define-constant-profile-region "Drain_Dop_PL" "SD_Dop" "R.drain")

################# define mesh #################
(define fp 0.8)
(define ratio_fp 1)
(define dx  (*  (/ Lgate 10) fp))
(define dy  (*  (/ Wfin  10) fp))
(define dz  (*  (/ Hfin  10) fp))
(define dox (* (/ Tox    5) fp))
;-----mesh 
(sdedr:define-refinement-window "W.Global" "Cuboid"
	(position -1 -1 -1)
	(position  1  1  1)
)
(sdedr:define-refinement-size "R.Global" (* dx 10) (* dy 10) (* dz 10) (* dx 4)  (* dy 4)  (* dy 4))
(sdedr:define-refinement-function "R.Global" "MaxLenInt" "Silicon" "SiO2"     (* dz 1)     (* ratio_fp 1.5) )
(sdedr:define-refinement-function "R.Global" "MaxLenInt" "Silicon" "Silicon"     (* dz 2)     (* ratio_fp 1.5) "DoubleSide")
(sdedr:define-refinement-function "R.Global" "MaxLenInt" "Silicon" "HfO2"  (* dox 2)    (* ratio_fp 1.5) "DoubleSide")
(sdedr:define-refinement-placement "P.Global" "R.Global" "W.Global")

#(extract-refpolyhedron (find-body-id (position (/ Lgate 2) 0 (/ Hfin 2))) "RW.channel") 
(sdedr:define-refinement-window "RW.channel" "Cuboid"
	(position  0     (/ Wfin  2) 0)
	(position  Lgate (/ Wfin -2)  Hfin)
)
(sdedr:define-refinement-size "RD.channel" (* dx 2) (* dy 4) (* dz 3)  (* dx 1) (* dy 2) (* dz 2) )
(sdedr:define-refinement-placement "PL.channel" "RD.channel" "RW.channel")

(sdedr:define-refinement-window "RW.source" "Cuboid"
	(position  (* -1 Lsource)   (/ Wfin  2) 0)
	(position  0 (/ Wfin -2)  Hfin)
)
(sdedr:define-refinement-size "RD.source" (* dx 4) (* dy 5) (* dz 4)  (* dx 2) (* dy 3) (* dz 3) )
(sdedr:define-refinement-placement "PL.source" "RD.source" "RW.source")

(sdedr:define-refinement-window "RW.drain" "Cuboid"
	(position  (* Lgate)   (/ Wfin  2) 0)
	(position  (+ Ldrain Lgate) (/ Wfin -2)  Hfin)
)
(sdedr:define-refinement-size "RD.drain" (* dx 4) (* dy 5) (* dz 4) (* dx 2) (* dy 3) (* dz 3) )
(sdedr:define-refinement-placement "PL.drain" "RD.drain" "RW.drain")



 
(sde:build-mesh "n@node@")

################tmp######################
#if 0
#--generate channel
(define x0 0.0)
(define y0 0.0)
(define z0 0.0)

(define r_rounding_top Rfin)
##--generate polygon
(define pbot_left_y  (/ Wfin -2) )
(define pbot_right_y (/ Wfin  2) )

(define pdy (* Hfin (/ cos_theta sin_theta)  ) )

(define ptop_left_y  (+ pbot_left_y  pdy ) )
(define ptop_right_y (- pbot_right_y pdy ) )

(define polygon_list (list 
						 (position x0 pbot_left_y  z0)
						 (position x0 pbot_right_y z0)
						 (position x0 ptop_right_y (+ z0 Hfin))
						 (position x0 ptop_left_y  (+ z0 Hfin))
					 )
)

(define polygon_1 (sdegeo:create-polygon polygon_list "Silicon" "R.Channel") )
##--sweep polygon
(sdegeo:sweep polygon_1 (gvector Lgate 0 0 ) 
(sweep:options "solid" #t "rigid" #f "miter_type" "default"))
	
(sdegeo:fillet (find-edge-id (position (/ (+ x0 x0 Lgate) 2) ptop_right_y (+ z0 Hfin ))) r_rounding_top)
(sdegeo:fillet (find-edge-id (position (/ (+ x0 x0 Lgate) 2) ptop_left_y  (+ z0 Hfin ))) r_rounding_top)
#endif
