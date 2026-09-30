
;; Defined Parameters:

;; Contact Sets:
(sdegeo:define-contact-set "Emitter" 4 (color:rgb 1 0 0 )"##" )
(sdegeo:define-contact-set "Collector" 4 (color:rgb 0 1 0 )"##" )
(sdegeo:define-contact-set "Gate" 4 (color:rgb 0 0 1 )"##" )

;; Work Planes:
(sde:workplanes-init-scm-binding)

;; Defined ACIS Refinements:
(sde:refinement-init-scm-binding)

;; Reference/Evaluation Windows:
(sdedr:define-refeval-window "RFW.BaseLineEmitter" "Line" (position 2.8 0 0) (position 3.6 0 0))
(sdedr:define-refeval-window "RFW.BaseLinePBody" "Line" (position 3.1 0 0) (position 4.8 0 0))
(sdedr:define-refeval-window "BaseLine.fieldstop" "Line" (position 0 70 0) (position 5 70 0))
(sdedr:define-refeval-window "BaseLine.collector" "Line" (position 0 70 0) (position 5 70 0))
(sdedr:define-refeval-window "RW.BaselineLifetime" "Line" (position -1 0 0) (position 5.8 0 0))
(sdedr:define-refeval-window "RW.Global" "Rectangle" (position -100000 -100000 0) (position 100000 100000 0))
(sdedr:define-refeval-window "active" "Rectangle" (position 0 0 0) (position 4.8 70 0))
(sdedr:define-refeval-window "RW.TrBot" "Rectangle" (position 1 1.8 0) (position 3 4 0))
