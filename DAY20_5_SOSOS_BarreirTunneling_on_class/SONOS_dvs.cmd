###this project was created by lanxiaomu######

(sde:clear)
(sde:set-process-up-direction "+z")

(sdegeo:set-default-boolean "BAB")


(define W 0.2)
(define Tsi 1.0)
(define Tox1 5e-3)
(define Tsi1 20e-3)
(define Tox2 5e-3)
 
 

(sdegeo:create-rectangle 
	(position (/ W -2) 0 0) 
	(position (/ W  2) (/ Tsi 2) 0) 
	"Silicon" "R.Sub1") 
(sdegeo:create-rectangle 
	(position (/ W -2) (/ Tsi 2) 0) 
	(position (/ W  2) Tsi 0) 
	"Silicon" "R.Sub2") 

(sdegeo:create-rectangle 
	(position (/ W -2) 0 0) 
	(position (/ W  2) ( * Tox1 -1) 0) 
	"Oxide" "R.Oxide1") 
(sdegeo:create-rectangle 
	(position (/ W -2) Tox1 0) 
	(position (/ W  2) ( * (+ Tox1 Tsi1) -1) 0) 
	"Silicon" "R.Silicon") 
(sdegeo:create-rectangle 
	(position (/ W -2) ( * (+ Tox1 Tsi1) -1) 0) 
	(position (/ W  2) ( * (+ Tox1 Tsi1 Tox2) -1) 0) 
	"Oxide" "R.Oxide2") 
 
(sdegeo:define-contact-set "top"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-edge-id (position 0.0 ( *  -1 (+ Tox1 Tsi1 Tox2) ) 0.0 )) "top")

(sdegeo:define-contact-set "bottom"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-edge-id (position 0.0 Tsi 0.0 )) "bottom" )

(define NAME "R.Sub1")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"PhosphorusActiveConcentration" 5e15)
(sdedr:define-constant-profile-region (string-append "CPM." NAME)
	(string-append "DC." NAME) "R.Sub1" )
(define NAME "R.Sub2")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"PhosphorusActiveConcentration" 5e15)
(sdedr:define-constant-profile-region (string-append "CPM." NAME)
	(string-append "DC." NAME) "R.Sub2" )

(define NAME "R.Silicon")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"PhosphorusActiveConcentration" 5e15)
(sdedr:define-constant-profile-region (string-append "CPM." NAME)
	(string-append "DC." NAME) "R.Silicon" )


;-----mesh
;Axis-Aliged Mesh

(sdedr:define-refeval-window 
	"RW.Global" "Rectangle" 
	(position -1000 -1000 0)
	(position  1000  1000 0) 
	)
(sdedr:define-refinement-size "RD.Global" 
	(/ W 10) (/ Tsi 10) 
	0.003 0.003 )
 
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Silicon" "Contact"  1e-3 1.5  
)
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Silicon" "Oxide"   1e-3 1.5  "DoubleSide"
)
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Silicon" "Silicon"   1e-3 1.5  "DoubleSide"
)
 
(sdedr:define-refinement-placement "RPL.Global" 
	"RD.Global"  "RW.Global")


(sde:build-mesh "n@node@")
