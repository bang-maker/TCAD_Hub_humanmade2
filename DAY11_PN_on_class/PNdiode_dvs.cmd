(sde:clear)
(sde:set-process-up-direction "+z")
(sdegeo:set-default-boolean "BAB")

(define W 2.0)
(define H 4.0)
(define Wcontact  1.0)

(sdegeo:create-rectangle 
	(position (/ W -2) H 0) 
	(position (/ W  2) 0 0) 
	"Silicon" "R.Silicon")

(sdegeo:create-rectangle 
	(position (/ Wcontact -2) H 0) 
	(position (/ Wcontact  2) (* -1  H) 0) 
	"Gold" "R.Metal")
; doping 
(define Nsub 1e16)
(sdedr:define-constant-profile "CP.Silicon" "BoronActiveConcentration" Nsub)
(sdedr:define-constant-profile-material "PL.Silicon"  "CP.Silicon" "Silicon")


; eLifetime /hLifetime 
(define eLifetime @Lifetime@)
(sdedr:define-constant-profile "CP.eLifetime" "eLifetime" eLifetime)
(sdedr:define-constant-profile-material "PL.eLifetime"  "CP.eLifetime" "Silicon")
(define hLifetime @Lifetime@)
(sdedr:define-constant-profile "CP.hLifetime" "hLifetime" hLifetime)
(sdedr:define-constant-profile-material "PL.hLifetime"  "CP.hLifetime" "Silicon")
                                                 


;-------analytic doping nwell 
(sdedr:define-refeval-window "BaseLine.Nwell" 
	"Line"   
	(position (/ Wcontact -2) 0.0 0.0)  
	(position (/ Wcontact  2) 0.0 0.0 ))
(sdedr:define-gaussian-profile "DD.Nwell" 
	"PhosphorusActiveConcentration"
	"PeakPos" 0.0  "PeakVal" 1e20
	"ValueAtDepth"  Nsub "Depth" 0.5
	"Gauss"  "Factor" 0.5)               
(sdedr:define-analytical-profile-placement "PL.Nwell" 
	"DD.Nwell" "BaseLine.Nwell"  "Both" 	"NoReplace" "Eval")


;-----mesh
;Axis-Aliged Mesh
(sdedr:define-refeval-window 
	"RW.Global" "Rectangle" 
	(position -1000 -1000 0)
	(position  1000  1000 0) 
	)
(sdedr:define-refinement-size "RD.Global" 
	(/ W 10)  (/ W 10) 
	0.01 0.01 )
 
(sdedr:define-refinement-function "RD.Global" 
   "DopingConcentration" "MaxTransDiff" 0.8)
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Silicon" "Contact"  1e-2 1.5  
)
(sdedr:define-refinement-placement "RPL.Global" 
	"RD.Global"  "RW.Global")


;------contact defination
 
(sdegeo:define-contact-set "P"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact 
	(find-edge-id (position 0.0 H 0.0 )) "P")


(sdegeo:define-contact-set "N"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-material-id "Gold" ) "N" "remove")



(sde:build-mesh  "n@node@")


