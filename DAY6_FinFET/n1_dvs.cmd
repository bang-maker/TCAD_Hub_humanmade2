; Reinitializing SDE 
(sde:clear)
; set coordinate system up direction (DF-ISE)
; z: up x: channel length y: gate with
(sde:set-process-up-direction "+z")

(define Lgate (* 1e-3 30 ))
(define Hfin 0.04)
(define Wfin 0.014)
(define Tox (* 2.0 1e-3 ))
(define Rfin 3e-3)
(define FinAngle 86)
(define sin_theta (sin ( / (* FinAngle PI ) 180) ) )
(define cos_theta (cos ( / (* FinAngle PI ) 180) ) )

(define Lsource 15e-3)
(define Ldrain Lsource)

(define Hsti 0.06)
(define Hbulk 0.2)

(define Xmax (+ Lgate Ldrain))
(define Xmin (* -1 Lsource)) ; source-channel junction zero-coordinate in x-axis

(define Ymax (/ Wfin  1))
(define Ymin (/ Wfin -1))

(define Zmin (- 0 Hsti Hbulk))

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

(create_trapzoid  (* -1 Lsource)  0  0   Wfin  Hfin  Lsource  FinAngle "Silicon" "R.source" Rfin 0 1)
(create_trapzoid  0  0  0   Wfin  Hfin  Lgate  FinAngle "Silicon" "R.channel" Rfin 0 1)
(sdegeo:set-default-boolean "BAB")
(create_trapzoid 0 0 0 (+ Wfin (* 2 (/ Tox sin_theta))) ( + Hfin Tox) Lgate FinAngle "HfO2" "R.gox" (+ Rfin Tox) 0 1)
(create_trapzoid  Lgate  0  0   Wfin  Hfin  Ldrain  FinAngle "Silicon" "R.drain" Rfin 0 1)
(create_trapzoid  (* -1 Lsource)  0  0   Wfin  (* Hsti -1.0)  (+ Lsource Ldrain Lgate)  FinAngle "Silicon" "R.channel" 0.0 0.0 1)
(sdegeo:set-default-boolean "BAB")
(sdegeo:create-cuboid (position (* -1 Lsource) Ymin 	    0  		 ) (position (+ Lgate Ldrain) Ymax (* -1 Hsti) )  "SiO2" "R.STI")
(sdegeo:create-cuboid (position (* -1 Lsource) Ymin (- 0 Hsti Hbulk) ) (position (+ Lgate Ldrain) Ymax (* -1 Hsti) ) "Silicon" "R.bulk")

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

(define Gate_Region (sdegeo:create-cuboid (position 0 Ymin 0) (position Lgate Ymax (+ Hfin (* 2 Tox)) ) "Aluminum" "Gate"))

(sdegeo:define-contact-set "gate" 4.0  (color:rgb 0.0 1.0 0.0 )  )
(sdegeo:set-current-contact-set "gate")
(sdegeo:set-contact-boundary-faces Gate_Region)  
(sdegeo:delete-region Gate_Region)
 

;----define-doping
(define Nchanel 1e17)
(define Nsource_drain 1e20)
(define Nbulk 1e15)



(if (string=? "NMOS" "NMOS" )
	(begin
			(define channel_Dopant "BoronActiveConcentration")
			(define source_drain_Dopant "PhosphorusActiveConcentration")	
	)
	(begin
			(define channel_Dopant "PhosphorusActiveConcentration")
			(define source_drain_Dopant "BoronActiveConcentration")	
	)
)


(sdedr:define-constant-profile "SD_Dop" source_drain_Dopant Nsource_drain)
(sdedr:define-constant-profile-region "Source_Dop_PL" "SD_Dop" "R.source")
(sdedr:define-constant-profile-region "Drain_Dop_PL" "SD_Dop" "R.drain")

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



 
(sde:build-mesh "n1")


