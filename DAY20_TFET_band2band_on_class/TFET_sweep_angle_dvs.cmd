###this project was created by lanxiaomu######

; Using DF-ISE coordinate system for structure generation
(sde:set-process-up-direction "+z")
;----------------------------------------------------------------------
; Structure definition
;----------------------------------------------------------------------;
(sdegeo:set-default-boolean "BAB")
; step 1 reading boundary of the device
(sdeio:read-tdr-bnd "n@node|TFET@_bnd.tdr")

;------- get the max/min point in the device 
(define BOX (bbox (get-body-list)))
(display BOX) ; ((position min_x min_y min_z) (position max_x max_y max_z))
(define Min_Point (car BOX))
(define Max_Point (cdr BOX)) ;(position max_x max_y max_z)

(define max_y (position:y Max_Point))
(define max_x (position:x Max_Point))
;------- sweep the structure
;(sdegeo:sweep (get-body-list) 10.0  (sweep:options "solid" #t  "rigid" #f "miter_type" "default"))
(sdegeo:sweep (get-body-list) (position 0  0.02  0) (gvector  -1 0 0) 
   (sweep:options "solid" #t "sweep_angle" 270 "rigid" #f "miter_type" 
     "default")) 
(map bool:regularise (get-body-list))

; step 2 reading data in the device
(sdedr:define-submesh "ExternalProfileDefinition_1"  "n@node|IdVg@_des.tdr")
; step 3 match (boundary + data)
(sdedr:define-refeval-window "RefEvalWin_1" "Rectangle"  	
	Min_Point Max_Point
	)
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"  "ExternalProfileDefinition_1" "RefEvalWin_1" "NoReplace" 
	"DecayLength" 1.0)


;-----sweep the Ref/Eval Window 
(sdegeo:sweep (get-drs-list) (position 0  0.02  0) (gvector   -1 0  0) 
   (sweep:options "solid" #t "sweep_angle" 270 "rigid" #f "miter_type" 
     "default")) 
 
; step 4 remesh 
;----mesh defination(simplified)
 (sdedr:define-refeval-window 
	"RW.Global" "Cuboid" 
	(position -1000 -1000 -1000)
	(position  1000  1000 1000) 
	)
(sdedr:define-refinement-size "RD.Global" 
	10e-3 10e-3 10e-3
	0.003 0.003 0.003)
 
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Silicon" "Contact"  1e-3 1.5  
)
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Silicon" "HfO2"   0.25e-3 1.5  "DoubleSide"
)
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Silicon" "Silicon"   1e-3 1.5  "DoubleSide"
)
 
(sdedr:define-refinement-placement "RPL.Global" 
	"RD.Global"  "RW.Global")

 
 
(sde:build-mesh "n@node@")




