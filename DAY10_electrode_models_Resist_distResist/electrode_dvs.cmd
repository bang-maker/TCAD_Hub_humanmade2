#********this project was created and shared by Lan Xiaomu (wechat:TCAD2017) *********#


(sde:clear)

(sde:set-process-up-direction "+z")

(sdegeo:set-default-boolean "BAB")

(define W 5)
(define H 2)
;structure
(sdegeo:create-rectangle (position 0.0 0.0 0.0 )     (position W H 0.0 )   "Silicon"  "R.Silicon" )
(sdegeo:create-rectangle (position 0.0 (/ H 4) 0.0 )  (position (+ W W) (/ H 2) 0.0 ) "Gold"  "R.Gold" )

;doping 
(define NAME "Silicon_Doping")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"PhosphorusActiveConcentration" 1e15)
(sdedr:define-constant-profile-region (string-append "CPM." NAME)
	(string-append "DC." NAME) "R.Silicon" )

;contact
(define CONT "top")
(define POINT (position (/ W 2) 0.0 0.0))
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-edge-id POINT) CONT)
(set! CONT "side")
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-material-id "Gold") CONT "remove")


;mesh
(define RNAME "R.Silicon")
(sdedr:define-refinement-size (string-append "RS." RNAME) 
	 (/ W 30)  (/ H 30) 
	 (/ W 40)  (/ H 40) )
(sdedr:define-refinement-region (string-append "RP." RNAME) 
	(string-append "RS." RNAME) RNAME)

(sde:build-mesh "n@node@")