; Using DF-ISE coordinate system for structure generation
(sde:set-process-up-direction "+z")
;----------------------------------------------------------------------
; Structure definition
;----------------------------------------------------------------------;
(sdegeo:set-default-boolean "BAB")
; step 1 reading boundary of the device
(sdeio:read-tdr-bnd "n6_bnd.tdr")

;------- get the max/min point in the device 
(define BOX (bbox (get-body-list)))
(display BOX) ; ((position min_x min_y min_z) (position max_x max_y max_z))
(define Min_Point (car BOX))
(define Max_Point (cdr BOX)) ;(position max_x max_y max_z)

(define max_y (position:y Max_Point))
(define max_x (position:x Max_Point))
;------- sweep the structure
(sdegeo:sweep (get-body-list) 10.0  (sweep:options "solid" #t  "rigid" #f "miter_type" "default"))
 


; step 2 reading data in the device
(sdedr:define-submesh "ExternalProfileDefinition_1"  "n6_msh.tdr")
; step 3 match (boundary + data)
(sdedr:define-refeval-window "RefEvalWin_1" "Rectangle"  	
	Min_Point Max_Point
	)
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"  "ExternalProfileDefinition_1" "RefEvalWin_1" "NoReplace" 
	"DecayLength" 1.0)


;-----sweep the Ref/Eval Window 
(sdegeo:sweep (get-drs-list) 10.0  (sweep:options "solid" #t  "rigid" #f "miter_type" "default"))
 

; step 4 remesh 
;----mesh defination(simplified)
(sdedr:define-refinement-size "RefinementDefinition_1" 
  1 10 4 1 1 1 )
(sdedr:define-refinement-material "RefinementPlacement_1" 
  "RefinementDefinition_1" "Silicon" )
(sdedr:define-refinement-function "RefinementDefinition_1" 
  "DopingConcentration" "MaxTransDiff" 1)



(sde:build-mesh "n18")





