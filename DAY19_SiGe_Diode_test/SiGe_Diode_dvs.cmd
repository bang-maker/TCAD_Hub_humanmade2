(sde:clear)
(sde:set-process-up-direction "+z")
(sdegeo:set-default-boolean "BAB")

(define W 2.0)
(define Hp 2.0)
(define Hn 2.0)
(define H (+  Hp Hn))
(define Wcontact  W)

(sdegeo:create-rectangle 
	(position (/ W -2) 0 0) 
	(position (/ W  2) Hp 0) 
	"SiGe_my" "R.SiGe")
(sdegeo:create-rectangle 
	(position (/ W -2) Hp 0) 
	(position (/ W  2) (+ Hn Hp) 0) 
	"Si_my" "R.Silicon")

(sdegeo:create-rectangle 
	(position (/ Wcontact -2) H 0) 
	(position (/ Wcontact  2) (* -1  H) 0) 
	"Gold" "R.Metal")

; doping 
(define Nsub 1e16)
(sdedr:define-constant-profile "CP.Silicon" "PhosphorusActiveConcentration" Nsub)
(sdedr:define-constant-profile-material "PL.Silicon"  "CP.Silicon" "Si_my")

; doping 
(define Np 1e16)
(sdedr:define-constant-profile "CP.SiGe_my" "BoronActiveConcentration" Np)
(sdedr:define-constant-profile-material "PL.SiGe_my"  "CP.SiGe_my" "SiGe_my")

; Mole Fraction 

#if [string match "*linear*"  "@xMole@" ]
(sdedr:define-refeval-window "BaseLine.Mole" "Line"
(position (/ W -0.5) 0.0 0.0) (position (/ W 0.5)  0.0 0.0))
(sdedr:define-analytical-profile "Prof.Mole" "xMoleFraction"
"a=1.0" "1.0*a/2.0*x" 0.1)
(sdedr:define-analytical-profile-placement "Place.Mole" "Prof.Mole"
"BaseLine.Mole" "Positive" "NoReplace" "Eval" "R.SiGe" 0 "region")

#else
(define X @xMole@)
(sdedr:define-constant-profile "CP.X_SiGe_my" "xMoleFraction" X)
(sdedr:define-constant-profile-material "PL.X_SiGe_my"  "CP.X_SiGe_my" "SiGe_my")
#endif
 
;-----mesh
;Axis-Aliged Mesh
(sdedr:define-refeval-window 
	"RW.Global" "Rectangle" 
	(position -1000 -1000 0)
	(position  1000  1000 0) 
	)
(sdedr:define-refinement-size "RD.Global" 
	(/ W 15)  (/ H 15) 
	0.001 0.001 )
 
(sdedr:define-refinement-function "RD.Global" 
   "DopingConcentration" "MaxTransDiff" 0.8)
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Si_my" "SiGe_my"  1e-3 1.5   "DoubleSide"
)
(sdedr:define-refinement-placement "RPL.Global" 
	"RD.Global"  "RW.Global")


;------contact defination
 
(sdegeo:define-contact-set "N"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact 
	(find-edge-id (position 0.0 H 0.0 )) "N")


(sdegeo:define-contact-set "P"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-material-id "Gold" ) "P" "remove")



(sde:build-mesh  "n@node@")


