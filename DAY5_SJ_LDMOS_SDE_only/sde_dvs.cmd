(sde:clear)
(sde:set-process-up-direction "+z")
 
############ device parameters ##########

#- structure parameter
##- bulk parameter 

(define Xmin 			0)
(define Ymin 			0)
(define Zsur			0) ;-the surface of the channel 
(define Tsub 			5)

##- channel parameter 
(define Lp_plus 		0.2)
(define Ln_plus 		0.2)
(define Lchannel 		0.4)
(define Ldrift			6.0)
(define Ln_plus_drain 	0.2)
(define Xmax (+ Xmin Lp_plus Ln_plus Lchannel Ldrift Ln_plus_drain))

 

##- SJ parameter 
(define Wn 0.98)
(define Wp 1.5)
(define Ymax (+ Ymin Wp Wn ))

 
##- gate stack 
(define Tox 20e-3)

##- POI parameter 
(define Tsi 	0.5 )
(define Tbox	0.5 )
(define Lpoi	(+ Ldrift Ln_plus_drain))
 
(sdegeo:create-cuboid (position Xmin Ymin Zsur) (position Xmax Ymax (* -1 Tsub) ) "Silicon" "R.Substrate")
(sdegeo:create-cuboid (position (+ Xmin Lp_plus Ln_plus) Ymin Zsur) (position (+ Xmin Lp_plus Ln_plus Lchannel) Ymax Tox) "Oxide" "R.GateOxide")

 

#doping
# *_j junction depth
# *_peak peak doping concentration
(define Nbulk 			1e15)

(define Nn_plus_peak 	1e20)
(define Nn_plus_j		0.2)

(define Np_plus_peak	1e20)
(define Np_plus_j		0.2)

(define Nchannel_peak	5e17)
(define Nchannel_j		Lchannel)

(define Nn_sj_peak		4.2e16)
(define Nn_sj_j			(+ Tbox Tsi))

(define Np_sj_peak		1.87e16)
(define Np_sj_j			(+ Tbox Tsi))


; Constant doping profile definions
(sdedr:define-constant-profile "Const.Bulk" "BoronActiveConcentration" Nbulk)
(sdedr:define-constant-profile-region "PlaceCD.Bulk"  "Const.Bulk" "R.Substrate")
; define channel doping 
 
; Gaussian ananlytic profile
(define NAME "Np_plus")
(sdedr:define-refeval-window (string-append "RW." NAME) 
	"Rectangle" 
	(position 	 Xmin 		   Ymin Zsur)  
	(position (+ Xmin Lp_plus) Ymax Zsur))
; - Common dopants: 
; "PhosphorusActiveConcentration" | "ArsenicActiveConcentration"
; | "BoronActiveConcentration" 
(sdedr:define-gaussian-profile (string-append "GAUSS." NAME) 
	"BoronActiveConcentration"
	"PeakPos" 0.0  "PeakVal" Np_plus_peak
	"ValueAtDepth" Nbulk   "Depth" Np_plus_j
	"Gauss"  "Factor" 0.3)
(sdedr:define-analytical-profile-placement (string-append "IMP." NAME) 
	(string-append "GAUSS." NAME) (string-append "RW." NAME) 
	"Negative"  "NoReplace" "Eval")

(define NAME "Nn_plus")
(sdedr:define-refeval-window (string-append "RW." NAME) 
	"Rectangle" 
	(position (+ Xmin Lp_plus) 		   Ymin Zsur)  
	(position (+ Xmin Lp_plus Ln_plus) Ymax Zsur))
; - Common dopants: 
; "PhosphorusActiveConcentration" | "ArsenicActiveConcentration"
; | "BoronActiveConcentration" 
(sdedr:define-gaussian-profile (string-append "GAUSS." NAME) 
	"PhosphorusActiveConcentration"
	"PeakPos" 0.0  "PeakVal" Nn_plus_peak
	"ValueAtDepth" Nbulk   "Depth" Nn_plus_j
	"Gauss"  "Factor" 0.3)
(sdedr:define-analytical-profile-placement (string-append "IMP." NAME) 
	(string-append "GAUSS." NAME) (string-append "RW." NAME) 
	"Negative"  "NoReplace" "Eval")


(define NAME "Nchannel")
(sdedr:define-refeval-window (string-append "RW." NAME) 
	"Rectangle" 
	(position (+ Xmin 0) 		  	   Ymin Zsur)  
	(position (+ Xmin Lp_plus Ln_plus) Ymax Zsur))
; - Common dopants: 
; "PhosphorusActiveConcentration" | "ArsenicActiveConcentration"
; | "BoronActiveConcentration" 
(sdedr:define-gaussian-profile (string-append "GAUSS." NAME) 
	"BoronActiveConcentration"
	"PeakPos" 0.0  "PeakVal" Nchannel_peak
	"ValueAtDepth" Nbulk   "Depth" Nchannel_j
	"Gauss"  "Factor" 1.0)
(sdedr:define-analytical-profile-placement (string-append "IMP." NAME) 
	(string-append "GAUSS." NAME) (string-append "RW." NAME) 
	"Negative"  "NoReplace" "Eval")

 

(define NAME "Nn_plus_drain")
(sdedr:define-refeval-window (string-append "RW." NAME) 
	"Rectangle" 
	(position (- Xmax Ln_plus_drain) 		   Ymin Zsur)  
	(position 	Xmax Ymax 	Zsur))
; - Common dopants: 
; "PhosphorusActiveConcentration" | "ArsenicActiveConcentration"
; | "BoronActiveConcentration" 
(sdedr:define-gaussian-profile (string-append "GAUSS." NAME) 
	"PhosphorusActiveConcentration"
	"PeakPos" 0.0  "PeakVal" Nn_plus_peak
	"ValueAtDepth" Nbulk   "Depth" Tsi
	"Gauss"  "Factor" 0.8)
(sdedr:define-analytical-profile-placement (string-append "IMP." NAME) 
	(string-append "GAUSS." NAME) (string-append "RW." NAME) 
	"Negative"  "NoReplace" "Eval")

 
;mesh
 

; set contact 
 

(define CONT "gate")
(define POINT (position (+ Xmin Lp_plus Ln_plus (/ Lchannel 2)) (/ (+ Ymin Ymax) 2) Tox))
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-face-id POINT) CONT )

(set! CONT "source")
(set! POINT (position (+ Xmin (/ (+ Lp_plus Ln_plus ) 2)) (/ (+ Ymin Ymax) 2) Zsur))
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-face-id POINT) CONT )

(define dummyMetal (sdegeo:create-cuboid (position Xmax Ymin Zsur) (position (- Xmax Ln_plus_drain) Ymax Tox) "Metal" "R.DrainMetal") )

(set! CONT "drain")
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact dummyMetal CONT "remove" )

(set! CONT "substrate")
(set! POINT (position (/ (+ Xmin Xmax) 2) (/ (+ Ymin Ymax) 2) (- 0 Tsub)))
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-face-id POINT) CONT )


(sde:build-mesh "-AI"  "n@node@_msh")
 