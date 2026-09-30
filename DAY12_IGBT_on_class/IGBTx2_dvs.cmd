
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
 

(sdegeo:sweep (get-body-list) (position 0  0  0) (gvector  0 -1 0) 
   (sweep:options "solid" #t "sweep_angle" 270 "rigid" #f "miter_type" 
     "default"))
(map bool:regularise (get-body-list))
 (sdegeo:sweep (find-drs-id "RefEvalWin_1") (position 0 0 0) (gvector  0 -1 0) 
   (sweep:options "solid" #t "sweep_angle" 270 "rigid" #f "miter_type" 
     "default"))


(sdedr:define-refinement-size "RefinementDefinition_1" 
  1 10 1 0.05 0.05 0.05 )
(sdedr:define-refinement-material "RefinementPlacement_1" 
  "RefinementDefinition_1" "Silicon" )
(sdedr:define-refinement-function "RefinementDefinition_1" 
  "DopingConcentration" "MaxTransDiff" 1)

(sde:build-mesh "n@node@")

