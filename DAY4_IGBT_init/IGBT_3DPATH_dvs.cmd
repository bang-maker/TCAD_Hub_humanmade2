
; Using DF-ISE coordinate system for structure generation
(sde:set-process-up-direction "+z")
;----------------------------------------------------------------------
; Structure definition
;----------------------------------------------------------------------;
(sdegeo:set-default-boolean "BAB")

(sdeio:read-tdr-bnd "n@node|IGBT@_bnd.tdr")


;---get the boundary of the structure 
(define Min_Point (car  (bbox (get-body-list))))
(define Max_Point (cdr  (bbox (get-body-list))))
(define min_x (position:x Min_Point))
(define max_x (position:x Max_Point))

(sdedr:define-submesh "ExternalProfileDefinition_1"  "n@node|IGBT@_msh.tdr")
(sdedr:define-refeval-window "RefEvalWin_1" "Rectangle"  
  Min_Point Max_Point)
(sdedr:define-submesh-placement "ExternalProfilePlacement_1" 
  "ExternalProfileDefinition_1" "RefEvalWin_1" "NoReplace")
 
(define L	10.0)
(define SIN (sin (* (/ 1.0 3.0) PI) ) )
(define COS (cos (* (/ 1.0 3.0) PI) ) )
(define TAN (sin (* (/ 1.0 3.0) PI) ) )
(define x_base 0)
(define y_base 0)
(display COS)
(display SIN)

(define path (sdegeo:create-polyline-wire (list 
	(position 	x_base 		y_base 		0	)
	(position 	x_base 		y_base 		(* L  0.5 ) )
	(position 	(+ x_base (* SIN L)	) 					y_base 	(+ (* L  0.5) (* COS L) )  	)
	(position 	(+ x_base (* SIN L) 	(* SIN  L )	) 	y_base 	(* L  0.5)   	)
	(position 	(+ x_base (* SIN L) 	(* SIN  L )	) 	y_base  (* L -0.5)   	)
	(position 	(+ x_base (* SIN L)	) 					y_base 	(- (* L -0.5) (* COS L) )   )
	(position 	x_base 		y_base 		(* L -0.5 ) )
	(position 	x_base 		y_base 		0	)
  )
 )
)

(sdegeo:sweep (get-body-list)	path
    (sweep:options "solid" #t  "rigid" #f "miter_type" "default")
)

(map bool:regularise (get-body-list))

(sdegeo:sweep (find-drs-id "RefEvalWin_1")	path
   (sweep:options "solid" #t "rigid" #f "miter_type"   "default")
)


(sdedr:define-refinement-size "RefinementDefinition_1" 
  1 10 1 0.05 0.05 0.05 )

(sdedr:define-refinement-material "RefinementPlacement_1" 
  "RefinementDefinition_1" "Silicon" )

(sdedr:define-refinement-function "RefinementDefinition_1" 
  "DopingConcentration" "MaxTransDiff" 1)

(sde:build-mesh "n@node@")

