
;; Defined Parameters:

;; Contact Sets:
(sdegeo:define-contact-set "source" 4 (color:rgb 0 1 0 )"##" )
(sdegeo:define-contact-set "drain" 4 (color:rgb 0 1 0 )"##" )
(sdegeo:define-contact-set "substrate" 4 (color:rgb 0 1 0 )"##" )
(sdegeo:define-contact-set "gate" 4 (color:rgb 0 1 0 )"##" )

;; Work Planes:
(sde:workplanes-init-scm-binding)

;; Defined ACIS Refinements:
(sde:refinement-init-scm-binding)
