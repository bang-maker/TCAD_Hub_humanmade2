(sde:clear)
(sde:set-process-up-direction "+z")

(sdegeo:set-default-boolean "BAB")

(set! evaluate-log-file #t)
	
(define Tsi 0.2) ;- unit: um
(define Tbox 0.3) 
(define Tsub 0.6)

(define Lgate 0.3)
(define Tox (* 1e-3 7))
(define Wspacer 0.1)
(define Hgate 0.2)
(define Lsd 0.1)
(define W	(+ Lgate Wspacer Wspacer Lsd))

(sdesnmesh:axisaligned "xCuts" (list (/ Lgate -2) (/ Lgate 2)))
(sdesnmesh:axisaligned "yCuts" (list 0 1.0))

; tcl command 

; scheme command
(if (string=? "NMOS" "NMOS")
	(begin
		(define CHANNEL_DOPING "BoronActiveConcentration")
		(define SD_DOPING "PhosphorusActiveConcentration")
	)
	(begin 
		(define CHANNEL_DOPING "PhosphorusActiveConcentration")
		(define SD_DOPING "BoronActiveConcentration")
	)
)

 


; scheme
; c-language: b = a + c*d 
; scheme      (+ a  (* c d) ) 

;-create epi silicon
(define EPI_BODY_ID (sdegeo:create-rectangle 
	(position (/ W -2) 0 0) 
	(position (/ W 2) Tsi 0) 
	"Silicon" "R.EPI") )
;-create box oxide 
(sdegeo:create-rectangle 
	(position (/ W -2) Tsi 0) 
	(position (/ W 2) (+ Tsi Tbox) 0) 
	"Oxide" "R.Box")
;-create substrate
(sdegeo:create-rectangle 
	(position (/ W -2) (+ Tsi Tbox) 0) 
	(position (/ W 2) (+ Tsi Tbox Tsub) 0) 
	"Silicon" "R.Substrate")
;-create gate oxide 
(sdegeo:create-rectangle 
	(position (- 0 Wspacer (/ Lgate 2)) 0 0) 
	(position (+ 0 Wspacer (/ Lgate 2)) (* Tox -1) 0) 
	"Oxide" "R.GateOxide")

;-polysilicon gate 
(sdegeo:create-rectangle 
	(position (/ Lgate -2) (* Tox -1) 0) 
	(position (/ Lgate 2) (* (+ Tox Hgate) -1) 0) 
	"PolySilicon" "R.PolySilicon")

;-spacer 
(sdegeo:create-rectangle 
	(position (- 0 Wspacer (/ Lgate 2)) (* Tox -1) 0) 
	(position (+ Wspacer (/ Lgate 2)) (* (+ Tox Hgate) -1) 0) 
	"Nitride" "R.Spacer")

(sde:info "all")
(generic:get EPI_BODY_ID  "material")
(generic:get EPI_BODY_ID  "region")


; fillet the corner of spacer 
(sdegeo:fillet-2d (find-vertex-id (position (+ Wspacer (/ Lgate 2)) (* (+ Tox Hgate) -1) 0)) 0.05)

(sdegeo:fillet-2d (find-vertex-id (position (* (+ 0 Wspacer (/ Lgate 2)) -1) (* (+ Tox Hgate) -1) 0)) 0.05)

;------------------doping-------------
; Ref/Eval Window
;(sdedr:define-refeval-window "RW.Channel" "Rectangle"
;	(position (/ W -2) 0 0) 
;	(position (/ W 2) Tsi 0))

;(sdedr:define-constant-profile "CP.Channel" "BoronActiveConcentration" 1e15)

;(sdedr:define-constant-profile-placement "PL.Channel"
;	 "CP.Channel" "RW.Channel")
(sdedr:define-constant-profile "CP.Channel" CHANNEL_DOPING 1e15)
;(sdedr:define-constant-profile-region "PL.Channel"  "CP.Channel" "R.EPI")
;(sdedr:define-constant-profile-region "PL.Substrate" "CP.Channel" "R.Substrate")
(sdedr:define-constant-profile-material "PL.Channel"  "CP.Channel" "Silicon")

;----source / drain doping 
; ------constant source/drain
;(sdedr:define-refeval-window "RW.Source" "Rectangle"
;	(position (/ W -2) 0 0) 
;	(position (- 0 Wspacer (/ Lgate 2)) Tsi 0))
;(sdedr:define-refeval-window "RW.Drain" "Rectangle"
;	(position (/ W  2) 0 0) 
;	(position (+ 0 Wspacer (/ Lgate 2)) Tsi 0))
;(sdedr:define-constant-profile "CP.SDDoping" "PhosphorusActiveConcentration" 1e15)
;(sdedr:define-constant-profile-placement "PL.Source"  "CP.SDDoping" "RW.Source")
;(sdedr:define-constant-profile-placement "PL.Drain"   "CP.SDDoping" "RW.Drain")

;-------analytic source/drain

(sdedr:define-refeval-window "BaseLine.SourceLDD" 
	"Line"   
	(position (/ W -2) 0.0 0.0)  
	(position (- 0 (/ Lgate 2)) 0.0 0.0 ))

; - Common dopants: 
; "PhosphorusActiveConcentration" | "ArsenicActiveConcentration"
; | "BoronActiveConcentration" 
(sdedr:define-gaussian-profile "DD.GaussLDD" 
	SD_DOPING
	"PeakPos" 0.0  "PeakVal" 1e17
	"ValueAtDepth"  1e15 "Depth" 0.05
	"Gauss"  "Factor" 1.0)

(sdedr:define-analytical-profile-placement "PL.SourceLDD" 
	"DD.GaussLDD" "BaseLine.SourceLDD" 	"Positive" 	"NoReplace" "Eval")


(sdedr:define-refeval-window "BaseLine.DrainLDD" 
	"Line"   
	(position (/ W 2) 0.0 0.0)  
	(position (+ 0 (/ Lgate 2)) 0.0 0.0 ))
(sdedr:define-analytical-profile-placement "PL.DrainLDD" 
	"DD.GaussLDD" "BaseLine.DrainLDD" 	"Negative" 	"NoReplace" "Eval")


(sdedr:define-refeval-window "BaseLine.Source" 
	"Line"   
	(position (/ W -2) 0.0 0.0)  
	(position (- 0 Wspacer (/ Lgate 2)) 0.0 0.0 ))
 
 
(sdedr:define-gaussian-profile "DD.GaussSD" 
	SD_DOPING
	"PeakPos" 0.0  "PeakVal" 1e20
	"ValueAtDepth"  1e15 "Depth" 0.1
	"Gauss"  "Factor" 0.8)

(sdedr:define-analytical-profile-placement "PL.Source" 
	"DD.GaussSD" "BaseLine.Source" 	"Positive" 	"NoReplace" "Eval")

(sdedr:define-refeval-window "BaseLine.Drain" 
	"Line"   
	(position (/ W 2) 0.0 0.0)  
	(position (+ 0 Wspacer (/ Lgate 2)) 0.0 0.0 ))

(sdedr:define-analytical-profile-placement "PL.Drain" 
	"DD.GaussSD" "BaseLine.Drain" 	"Negative" 	"NoReplace" "Eval")


;------contact defination
(sdegeo:insert-vertex (position (/ (+ (/ W 2) (/ Lgate 2) Wspacer ) -2) 0.0 0.0 ))

(sdegeo:define-contact-set "source"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact 
	(find-edge-id (position (/ (+ (/ W -2) (/ (+ (/ W 2) (/ Lgate 2) Wspacer ) -2) ) 2) 0.0 0.0 )) "source")

(sdegeo:define-contact-set "drain"  4.0  (color:rgb 0.0 1.0 0.0 ) "##" )
(sdegeo:set-contact 
	(find-edge-id (position (/ (+ (/ W 2) (/ Lgate 2) Wspacer ) 2) 0.0 0.0 )) "drain")
 
(sdegeo:define-contact-set "substrate"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact 
	(find-edge-id (position 0.0 (+ Tsi Tbox Tsub) 0.0 )) "substrate")


(sdegeo:define-contact-set "gate"  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact (find-body-id (position 0.0 (/ (+ Tox Hgate Tox) -2) 0.0 )) "gate" "remove")



;-----mesh
;Axis-Aliged Mesh

(sdedr:define-refeval-window 
	"RW.Global" "Rectangle" 
	(position -1000 -1000 0)
	(position  1000  1000 0) 
	)
(sdedr:define-refinement-size "RD.Global" 
	0.1  0.1 
	0.003 0.003 )
 
(sdedr:define-refinement-function "RD.Global" 
   "DopingConcentration" "MaxTransDiff" 1.0)
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "R.EPI" "R.GateOxide" 1e-3 1.5  "DoubleSide" "UseRegionNames"
)
(sdedr:define-refinement-function "RD.Global" 
	"MaxLenInt" "Contact" "Silicon" 1e-3 1.5  
)
(sdedr:define-refinement-placement "RPL.Global" 
	"RD.Global"  "RW.Global")


(sdedr:define-refeval-window 
	"RW.Channel" "Rectangle" 
	(position (/ Lgate -2) 0 0)
	(position (/ Lgate 2)  Tsi 0) 
	)

(sdedr:define-refinement-size "RD.Channel" 
	(/ Lgate 10) 1.0
	0.01 0.01 )
(sdedr:define-refinement-placement "RPL.Channel" 
	"RD.Channel"  "RW.Channel")

 

;(sdedr:define-refinement-placement "RPL.Channel" 
;	"RD.Channel"  "RW.Channel")



;(sdedr:define-refeval-window 
;	"RW.Channel" "Rectangle" 
;	(position (/ W -2) 0 0)
;	(position (/ W 2) Tsi 0) 
;	)
;(sdedr:define-refinement-size "RD.Channel" 
;	0.04  0.04 
;	0.003 0.003 )
 
;(sdedr:define-refinement-function "RD.Channel" 
;   "DopingConcentration" "MaxTransDiff" 1.0)
;(sdedr:define-refinement-function "RD.Channel" 
;	"MaxLenInt" "Silicon" "Oxide" 1e-3 1.5 
;)
  
;(sde:save-model "n76_bnd.tdr") ; input(/i) or output(o/) ?

 

(sde:build-mesh "n76")

