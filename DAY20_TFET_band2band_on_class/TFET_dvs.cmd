####this project was created by lanxiaomu######



(sde:clear)
(sde:set-process-up-direction "+z")
#default setting 

(define Lg (*  50 1e-3))
(define Xcha Lg)
(define Ycha 20e-3)
(define tox 1e-3)
(define Xsd 20e-3)

(sdegeo:create-rectangle   (position 0.0 0.0 0.0)    (position Xcha  Ycha  0.0)  "Silicon" "R.Channel" )
(sdegeo:create-rectangle   (position (* -1 Xsd) 0.0 0.0)    (position 0  Ycha  0.0)  "Silicon" "R.Source" )
(sdegeo:create-rectangle   (position Xcha 0.0 0.0)    (position (+ Xcha Xsd) Ycha  0.0)  "Silicon" "R.Drain" )

(sdegeo:create-rectangle   (position Xcha 0.0 0.0)    (position (+ Xcha Xsd) Ycha  0.0)  "Silicon" "R.Drain" )

 

(sdegeo:set-default-boolean "BAB")

(sdegeo:create-rectangle   (position 0 (- 0 tox) 0.0)    (position Xcha  Ycha    0.0)  "HfO2" "GateOx" )


; =================== Contact Definition Placement  =========================
(sdegeo:define-contact-set "gate"      4.0 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "source"    4.0 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "drain"     4.0 (color:rgb 1.0 0.0 0.0) "##")
# set(settings set)

(sdegeo:set-contact (find-edge-id (position   (* 0.5 Xcha)  (* -1 tox)  0.0)) "gate"   )
(sdegeo:set-contact (find-edge-id (position   (+ Xcha Xsd)   (* 0.5 Ycha)   0.0)) "drain"   )
(sdegeo:set-contact (find-edge-id (position   (* Xsd -1)   (* 0.5 Ycha)   0.0)) "source"   )


; =================== Constant and Profiles =========================

;---Definitions
 
(sdedr:define-constant-profile "Epi2_Dop_Defn" "BoronActiveConcentration"           1e17 )
(sdedr:define-constant-profile "Sou_Dop_Defn" "BoronActiveConcentration"            1e20 )
(sdedr:define-constant-profile "Dra_Dop_Defn" "PhosphorusActiveConcentration"       1e19 )


;---Placement
 
(sdedr:define-constant-profile-region "Epi2_Place" "Epi2_Dop_Defn" "R.Channel"  )
(sdedr:define-constant-profile-region "Sou_Place" "Sou_Dop_Defn" "R.Source" )
(sdedr:define-constant-profile-region "Dra_Place" "Dra_Dop_Defn" "R.Drain"  )


; =================== Refinements  =========================
 
 (sdedr:define-refeval-window 
	"RW.Global" "Rectangle" 
	(position -1000 -1000 0)
	(position  1000  1000 0) 
	)
(sdedr:define-refinement-size "RD.Global" 
	(/ Xcha 10) (/ Ycha 10) 
	0.003 0.003 )
 
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

 
;----------------------------------------------------------------------

;build mesh

(sde:build-mesh "snmesh" "" "n@node@_msh")

