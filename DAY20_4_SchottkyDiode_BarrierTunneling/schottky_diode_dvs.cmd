###this project was created by lanxiaomu######
(sde:clear)
(sde:set-process-up-direction "+z")

(sdegeo:set-default-boolean "BAB")


(define W 0.2)
(define Tsi 3.0)
 
 

(sdegeo:create-rectangle 
	(position (/ W -2) 0 0) 
	(position (/ W 2) Tsi 0) 
	"Silicon" "R.Sub") 
 
(sdegeo:define-contact-set "top"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-edge-id (position 0.0 0.0 0.0 )) "top")

(sdegeo:define-contact-set "bottom"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-edge-id (position 0.0 Tsi 0.0 )) "bottom" )

(define NAME "R.Sub")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"PhosphorusActiveConcentration" 5e15)
(sdedr:define-constant-profile-region (string-append "CPM." NAME)
	(string-append "DC." NAME) "R.Sub" )


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

 

(sdedr:define-refinement-placement "RPL.Global" 
	"RD.Global"  "RW.Global")


(sde:build-mesh "n@node@")
