(sde:clear)

(sde:set-process-up-direction "+z")

(sdegeo:set-default-boolean "BAB")

;horizental parameters
(define Wleft 2.0)
(define Wgate 0.8)
(define Wright 2.0)
;vertical parameters 
(define Hgate 3.13)
(define Tox_sidewall 20e-3)
(define Tox_bottom 90e-3)
(define R 0.2)

(define gate_angle 89.0) 
(define TAN (tan (* (/ gate_angle 180) PI) ))
(define COS (cos (* (/ gate_angle 180) PI) ))
(define SIN (sin (* (/ gate_angle 180) PI) ))

(sdegeo:create-polygon (list
  (position Wleft 0.0 0)
  (position (+ Wleft Wgate) 0.0 0)
  (position (- (+ Wleft Wgate) (/ Hgate TAN)) Hgate 0)
  (position (+ Wleft (/ Hgate TAN)) Hgate 0)
  (position Wleft 0.0 0)
  )
  "PolySi" "R.PolyGate")

 
(sdegeo:fillet-2d (list 
	(car (find-vertex-id (position (- (+ Wleft Wgate) (/ Hgate TAN)) Hgate 0)))
	(car (find-vertex-id (position (+ Wleft (/ Hgate TAN)) Hgate 0)))
	) R)



(sdegeo:create-polygon (list
  (position (- Wleft (/ Tox_sidewall SIN)) 0.00 0)
  (position (+ Wleft Wgate (/ Tox_sidewall SIN)) 0.00 0)
  (position (- (+ Wleft Wgate (/ Tox_sidewall SIN)) (/ (+ Hgate Tox_bottom) TAN)) (+ Hgate Tox_bottom) 0)
  (position (+ (- Wleft (/ Tox_sidewall SIN)) (/ (+ Hgate Tox_bottom) TAN)) (+ Hgate Tox_bottom) 0)
  (position (- Wleft (/ Tox_sidewall SIN)) 0.00 0))
  "Oxide" "R.Gox")
(sdegeo:fillet-2d (list 
		(car (find-vertex-id (position (- (+ Wleft Wgate (/ Tox_sidewall SIN)) (/ (+ Hgate Tox_bottom) TAN)) (+ Hgate Tox_bottom) 0)) )
		(car (find-vertex-id (position (+ (- Wleft (/ Tox_sidewall SIN)) (/ (+ Hgate Tox_bottom) TAN)) (+ Hgate Tox_bottom) 0)) )
	) R)

;---parameter for locos 
(define Wlocos 1.0)
(define Tlocos 0.4)
(define Tox_locos 0.02)
(define Wneck 0.2)
(define Rlocos 0.1)

(define LOCOS1_ID (sdegeo:create-rectangle
		(position 0.0 0.0 0.0 )  (position Wleft Tox_locos 0.0 ) "Oxide"  "R.LOCOS_thin" ) 
)

(define LOCOS2_ID (sdegeo:create-rectangle
	(position 0.0 (- (/ Tox_locos 2) (/ Tlocos 2) ) 0.0 )  (position Wlocos (+ (/ Tox_locos 2) (/ Tlocos 2) ) 0.0 ) "Oxide"  "R.LOCOS_thick" )
)

(define LOCOS_ID (sdegeo:bool-unite (list LOCOS1_ID LOCOS2_ID)) )

(sde:add-material  LOCOS_ID (generic:get LOCOS_ID "material" ) "R.LOCOS")
;(sde:add-material  LOCOS_ID  "Gold" (generic:get LOCOS_ID "region" ))


(sdegeo:move-vertex
		(list 
			(car
				(find-vertex-id (position Wlocos Tox_locos  0.0 ))
			)
			(car
				(find-vertex-id (position Wlocos 0.0        0.0 ))
			)
		)
		(gvector Wneck 0.0 0.0 ) ;direction length
	)

(sdegeo:fillet-2d (list 
			(car (find-vertex-id (position Wlocos (+ (/ Tox_locos 2) (/ Tlocos 2) ) 0.0 ) ) )
			(car (find-vertex-id (position Wlocos (- (/ Tox_locos 2) (/ Tlocos 2) ) 0.0 ) ) )
	) Rlocos )
;----------------------

(define xmin 0.0)
(define ymin 0.0)
(define xmax (+ Wleft Wgate Wright))
(define ymax 70.0)
(define Wspacer 0.3)
(sdegeo:create-rectangle
  (position (+ Wleft Wgate) -0.3 0.0 )  (position (+ Wleft Wgate Wspacer) 0.0 0.0 ) "Oxide"  "R.Spacer" )
(sdegeo:create-rectangle
  (position 0.0  0.0 0.0 )  (position 2.8 -0.3 0.0 ) "PolySi"  "R.PolyCont" )
(sdegeo:create-rectangle
  (position 0.0  0.0 0.0 )  (position xmax ymax 0.0 ) "Silicon" "R.Si" )


(sdegeo:define-contact-set "Emitter"   4  (color:rgb 1 0 0 ) "##" )
(sdegeo:define-contact-set "Collector" 4  (color:rgb 0 1 0 ) "##" )
(sdegeo:define-contact-set "Gate"      4  (color:rgb 0 0 1 ) "##" )

(sdegeo:define-2d-contact (find-edge-id (position 3.5  0.0 0.0)) "Emitter")
(sdegeo:define-2d-contact (find-edge-id (position 3.5 ymax 0.0)) "Collector")
(sdegeo:define-2d-contact (find-edge-id (position 1.0 -0.3 0.0)) "Gate")
 


;----substrate constant doping 
; - Substrate
(sdedr:define-constant-profile "Const.Substrate"
 "PhosphorusActiveConcentration" 1e+15 )
(sdedr:define-constant-profile-material "PlaceCD.Substrate"
 "Const.Substrate" "Silicon" )

;------read 1d plx doping profile
; 1) standard Gauss /Error Function 
; 2) external 1D profile 
; 3) user defined analytical function

;----source doping 
(define Wemitter  0.8)
;----define Emiiter
(sdedr:define-refeval-window "RFW.BaseLineEmitter" "Line"  
  (position (+ Wleft Wgate) 0.0 0.0) (position (+ Wleft Wgate Wemitter) 0.0 0.))

(sdedr:define-1d-external-profile "DD.1DExternalEmitter" 
  "n3_fps.plx" "Scale" 1.0   "Gauss"  "Factor" 0.1)             

(sdedr:define-analytical-profile-placement "PL.1DExternalEmitter" 
  "DD.1DExternalEmitter" "RFW.BaseLineEmitter" "Both" "NoReplace" "Eval")
 

(sdedr:define-refeval-window "RFW.BaseLinePBody" "Line"  
  (position (+ Wleft Wgate Wspacer) 0.0 0.0) (position (+ Wleft Wgate Wright) 0.0 0.))
(sdedr:define-1d-external-profile "DD.1DExternalPBody" 
  "n5_fps.plx" "Scale" 1.0   "Gauss"  "Factor" 0.15)
(sdedr:define-analytical-profile-placement "APL.1DExternalPBody" 
  "DD.1DExternalPBody" "RFW.BaseLinePBody" "Both" "NoReplace" "Eval")




(sdedr:define-constant-profile "Const.PolySilicon"	"PhosphorusActiveConcentration" 1e21)
(sdedr:define-constant-profile-material "PL.Const.PolySilicon" 	"Const.PolySilicon"  "PolySi" 0.0 "Replace")


(sdedr:define-refeval-window "BaseLine.fieldstop" "Line"
 (position 0.0 70.0 0.0)
 (position 5.0 70.0 0.0) )
(sdedr:define-gaussian-profile "Impl.fieldstopprof"
 "ArsenicActiveConcentration"
 "PeakPos" 0.0  "PeakVal" 1e19
 "ValueAtDepth" 1e15  "Depth" 3.0
 "Erf"  "Length" 0.1)
(sdedr:define-analytical-profile-placement "Impl.fieldstop"
 "Impl.fieldstopprof" "BaseLine.fieldstop" "Negative" "NoReplace" "Eval")

(sdedr:define-refeval-window "BaseLine.collector" "Line"
 (position 0.0 70.0 0.0)
 (position 5.0 70.0 0.0) )
(sdedr:define-gaussian-profile "Impl.collectorprof"
 "BoronActiveConcentration"
 "PeakPos" 0.1  "PeakVal" 1e20
 "ValueAtDepth" 1e17  "Depth" 0.5
 "Erf"  "Length" 0.1)
(sdedr:define-analytical-profile-placement "Impl.collector"
 "Impl.collectorprof" "BaseLine.collector" "Negative" "NoReplace" "Eval")



(sdedr:define-refeval-window "RW.BaselineLifetime" "Line"  
  (position  -1.0  0 0.0) (position (+ Wleft Wgate Wright 1.0) 0 0.0 ))
;												 fieldname    init      equation(eval at every point)   default_value
(sdedr:define-analytical-profile "AP.eLifetime" "eLifetime" "a=5.0;b=5e-6" "1e-5-b*exp(-1.0*x/a)"          0.1     )
; note : 1) fieldname must exits in datexcodes.txt file
;        2) +- 
(sdedr:define-analytical-profile-placement "PL.eLifetime"   "AP.eLifetime" "RW.BaselineLifetime" "Both" "NoReplace" "Eval")
;									 fieldname    init      equation(eval at every point)   default_value
(sdedr:define-analytical-profile "AP.hLifetime" "hLifetime" "a=5.0;b=1e-6" "3e-6-b*exp(-1.0*x/a)"          0.1     )
; note : 1) fieldname must exits in datexcodes.txt file
;        2) +- 
(sdedr:define-analytical-profile-placement "PL.hLifetime"   "AP.hLifetime" "RW.BaselineLifetime" "Both" "NoReplace" "Eval")


;--------mesh -----
(define fs 1.0)
(define dx (* fs (/ (+ Wleft Wgate Wright) 10.0)))
(define dy (* fs (/ ymax 10.0)))
(define dTox (* fs (/ Tox_sidewall 3.0) ))

(sdedr:define-refinement-size "RD.Global" dx dy 1.0  0.1 0.1 0.1 )
(sdedr:define-refeval-window "RW.Global" "Rectangle"  (position -1e5 -1e5 0)  (position 1e5 1e5 0.) )
(sdedr:define-refinement-placement "PL.Global" "RD.Global" "RW.Global" )



(sdedr:define-refinement-size "active_domain" 2.0 5.0 0.5 0.02 0.02 0.05 )
(sdedr:define-refinement-material "active_domain" "active_domain" "Silicon")
(sdedr:define-refinement-function "active_domain" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-function "active_domain" "MaxLenInt" "R.Si" "emitter" 0.002 2 "UseRegionNames")
(sdedr:define-refinement-function "active_domain" "MaxLenInt" "R.Si" "thermo_left" 0.025 2 "UseRegionNames")

(sdedr:define-refinement-function "active_domain" "MaxLenInt" "R.Si" "thermo_right" 0.025 2 "UseRegionNames")

(sdedr:define-refeval-window "active" "Rectangle"  (position xmin ymin 0.0)  (position xmax ymax 0.0) )
(sdedr:define-refinement-size "active" 1.0 5.0 1.0 0.03 0.02 0.5)
(sdedr:define-refinement-placement "active" "active" "active")
(sdedr:define-refinement-function "active" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-function "active" "eLifetime" "MaxTransDiff" 1)



;; Trench Bottom
(sdedr:define-refeval-window "RW.TrBot"
 "Rectangle"
 (position 1.0 1.8 0.0 )
 (position 3.0 4.0 0.0 ))
(sdedr:define-refinement-size "Ref.TrBot"
  0.1  0.5
  0.05 0.05)
(sdedr:define-refinement-function "Ref.TrBot"
 "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-placement "RefPlace.TrBot"
 "Ref.TrBot" "RW.TrBot" )

 

(define nlevels 10)
(define factor 1.5)

(sdedr:offset-block "material" "Silicon"  "maxlevel" nlevels)
;(sdedr:offset-block "region" "R.Si"  "maxlevel" nlevels)

(sdedr:offset-interface "region" "R.Si" "R.Gox" "hlocal" 0.0015 "factor" factor)
(sdedr:offset-interface "region" "R.Gox" "R.PolyGate" "hlocal" 0.01 "factor" factor)
(sdedr:offset-interface "region" "R.Gox" "R.Si" "hlocal" (/ Tox_sidewall 5) "factor" factor)

(sdedr:offset-interface "region" "R.Si" "R.LOCOS"  "hlocal" 0.005 "factor" factor)

 
(sde:save-model "n7")
; snmesh -offset n1_msh.cmd
(sde:build-mesh "-offset" "n7")




