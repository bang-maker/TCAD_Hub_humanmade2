; Using DF-ISE coordinate system for structure generation
(sde:set-process-up-direction "+z")
;----------------------------------------------------------------------
; Structure definition
;----------------------------------------------------------------------;
(sdegeo:set-default-boolean "BAB")
; step 1 reading 1st boundary of the device
(sdeio:read-tdr-bnd "n6_bnd.tdr")


;------- get the max/min point in the device 
(define BOX (bbox (get-body-list)))
(display BOX) ; ((position min_x min_y min_z) (position max_x max_y max_z))
(define Min_Point (car BOX))
(define Max_Point (cdr BOX)) ;(position max_x max_y max_z)

(define max_y (position:y Max_Point))
(define max_x (position:x Max_Point))
(define min_x (position:x Min_Point))
(define min_y (position:y Min_Point))
(define Lx (- max_x min_x))
(define trans (transform:translation (gvector Lx 0.0 0.0)))
(sdegeo:translate-selected (get-body-list) trans #t 1)

; step 1.2 reading 2rd boundary of the device
;(sdeio:read-tdr-bnd "n6_bnd.tdr")


(sdegeo:bool-unite (find-material-id "Silicon"))
 
; step 2 reading data in the device
(sdedr:define-submesh "ExternalProfileDefinition_1"  "n6_msh.tdr")
(sdedr:define-submesh "ExternalProfileDefinition_2"  "n6_msh.tdr")
; step 3 match (boundary + data)
(sdedr:define-refeval-window "RefEvalWin_1" "Rectangle"  	
	Min_Point Max_Point
	)
(sdedr:define-refeval-window "RefEvalWin_2" "Rectangle"  	
	(position Lx min_y 0.0) (position (+ Lx Lx) max_y 0.0 )
	)
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"  "ExternalProfileDefinition_1" "RefEvalWin_1" "NoReplace" 
	)
(sdedr:define-submesh-placement "ExternalProfilePlacement_2"  "ExternalProfileDefinition_2" "RefEvalWin_2" "Replace" 
	)
;---- transform submesh 
(sdedr:transform-submesh-placement "ExternalProfilePlacement_2" "ShiftVector" (gvector Lx 0.0 0.0))
 
; step 4 remesh 
;----mesh defination(simplified)
(sdedr:define-refinement-size "RefinementDefinition_1" 
  1 10 1 0.05 0.05 0.05 )
(sdedr:define-refinement-material "RefinementPlacement_1" 
  "RefinementDefinition_1" "Silicon" )
(sdedr:define-refinement-function "RefinementDefinition_1" 
  "DopingConcentration" "MaxTransDiff" 1)


(sde:build-mesh "n10")





