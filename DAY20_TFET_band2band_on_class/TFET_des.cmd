(sde:clear)
(sde:set-process-up-direction "+z")
#default setting 

(define Lg (*  @L@ 1e-3))
(define Xcha Lg)
(define Ycha 20e-3)
(define tox 1e-3)
(define Xsd 50e-3)

(sdegeo:create-rectangle   (position 0.0 0.0 0.0)    (position Xcha  Ycha  0.0)  "Silicon" "R.Channel" )
(sdegeo:create-rectangle   (position (* -1 Xsd) 0.0 0.0)    (position 0  Ycha  0.0)  "Silicon" "R.Source" )
(sdegeo:create-rectangle   (position Xcha 0.0 0.0)    (position (+ Xcha Xsd) Ycha  0.0)  "Silicon" "R.Drain" )

(sdegeo:create-rectangle   (position Xcha 0.0 0.0)    (position (+ Xcha Xsd) Ycha  0.0)  "Silicon" "R.Drain" )

 

(sdegeo:set-default-boolean "BAB")

(sdegeo:create-rectangle   (position 0 (- 0 tox) 0.0)    (position Xcha (+ Ycha tox)  0.0)  "HfO2" "GateOx" )


; =================== Contact Definition Placement  =========================
(sdegeo:define-contact-set "gate"      4.0 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "source"    4.0 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "drain"     4.0 (color:rgb 1.0 0.0 0.0) "##")
# set(settings set)

(sdegeo:define-2d-contact (find-edge-id (position   (* 0.5 Xcha)  (* -1 tox)  0.0)) "gate"   )
(sdegeo:define-2d-contact (find-edge-id (position   (* 0.5 Xcha)  (+ Ycha tox)  0.0)) "gate"   )
(sdegeo:define-2d-contact (find-edge-id (position   (+ Xcha Xsd)   (* 0.5 Ycha)   0.0)) "drain"   )
(sdegeo:define-2d-contact (find-edge-id (position   (* Xsd -1)   (* 0.5 Ycha)   0.0)) "source"   )


; =================== Constant and Profiles =========================

;---Definitions
 
(sdedr:define-constant-profile "Epi2_Dop_Defn" "BoronActiveConcentration"           1e17 )
(sdedr:define-constant-profile "Sou_Dop_Defn" "BoronActiveConcentration"            1e20 )
(sdedr:define-constant-profile "Dra_Dop_Defn" "PhosphorusActiveConcentration"       1e19 )


;---Placement
 
(sdedr:define-constant-profile-region "Epi2_Place" "Epi2_Dop_Defn" "Channel"   )
(sdedr:define-constant-profile-region "Sou_Place" "Sou_Dop_Defn" "Source" )
(sdedr:define-constant-profile-region "Dra_Place" "Dra_Dop_Defn" "Drain"  )


; =================== Refinements  =========================
 
 

 
;----------------------------------------------------------------------

;build mesh

(sde:build-mesh "snmesh" "" "n@node@_msh")

