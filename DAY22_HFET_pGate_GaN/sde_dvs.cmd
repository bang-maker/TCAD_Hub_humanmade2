; Using DF-ISE coordinate system for structure generation
(sde:set-process-up-direction "+z")
;---------------------------------------------------------------------------
; Some control parameters
;---------------------------------------------------------------------------
(define tSiN_passivation 0.2)
(define AlGaN_Doping @AlGaN_Doping@)
(define LeftOV 0.5)
(define RightOV @FP@)

(define tpGaN_gate	0.11)
(define NpGaN_gate	3e17)
(define tAlGaN1		0.015)
(define NAlGaN1		AlGaN_Doping)
(define xAlGaN1		0.23)
(define tGaN_channel	0.010)
(define NGaN_channel	1e15)
(define tbuffer		2)
(define Nbuffer		1e14)
(define xbuffer		0.05)
(define tNcl		0.01)              ;;guess


(define Lsg		1)
(define Lgd		@Lgd@)
(define Lg		1.4)
(define Ls		0.5)
(define Ld		0.5)

;---------------------------------------------------------------------------
; Derived parameters
;---------------------------------------------------------------------------
; Vertical coordinates
(define Ytop 0.0)
(define Y0_SiN_passivation Ytop)
(define Y0_AlGaN_1 (+ Y0_SiN_passivation tSiN_passivation))
(define Y0_GaN_channel (+ Y0_AlGaN_1 tAlGaN1))
(define Y0_buffer (+ Y0_GaN_channel tGaN_channel))
(define Y0_nucleation (+ Y0_buffer tbuffer))
(define Ybot (+ Y0_nucleation tNcl))

; Horizontal coordinates
(define Xmax (+ Ls Lsg Lg Lgd Ld))
(define Xmin 0)
(define Xsrc Ls)
(define Xgt.l (+ Xsrc Lsg))
(define Xgt.r (+ Xgt.l Lg))
(define Xdrn (+ Xgt.r Lgd))

;---------------------------------------------------------------------------
; Build epi structure
;---------------------------------------------------------------------------
; Passivation
(sdegeo:create-rectangle 
  (position 0 Y0_SiN_passivation 0) (position Xmax Y0_AlGaN_1 0) 
  "Nitride" "SiN_passivation" 
)

; AlGaN Barrier Layer
(sdegeo:create-rectangle 
  (position 0 Y0_AlGaN_1 0) (position Xmax Y0_GaN_channel 0) 
  "AlGaN" "AlGaN_1" 
)
(sdedr:define-constant-profile "ndop_AlGaN_1_const" "ArsenicActiveConcentration" NAlGaN1)
(sdedr:define-constant-profile-region "ndop_AlGaN_1_const" "ndop_AlGaN_1_const" "AlGaN_1")
(sdedr:define-constant-profile "xmole_AlGaN_1_const" "xMoleFraction" xAlGaN1)
(sdedr:define-constant-profile-region "xmole_AlGaN_1_const" "xmole_AlGaN_1_const" "AlGaN_1")

; GaN channel
(sdegeo:create-rectangle 
  (position 0 Y0_GaN_channel 0) (position Xmax Y0_buffer 0) 
  "GaN" "GaN_channel" 
)
(sdedr:define-constant-profile "ndop_GaN_channel_const" "ArsenicActiveConcentration" NGaN_channel)
(sdedr:define-constant-profile-region "ndop_GaN_channel_const" "ndop_GaN_channel_const" "GaN_channel")

; AlGaN buffer
(sdegeo:create-rectangle 
  (position 0 Y0_buffer 0) (position Xmax Y0_nucleation 0) 
  "AlGaN" "buffer" 
)
(sdedr:define-constant-profile "ndop_buffer_const" "ArsenicActiveConcentration" Nbuffer)
(sdedr:define-constant-profile-region "ndop_buffer_const" "ndop_buffer_const" "buffer")
(sdedr:define-constant-profile "xmole_buffer_const" "xMoleFraction" xbuffer)
(sdedr:define-constant-profile-region "xmole_buffer_const" "xmole_buffer_const" "buffer")

; AlN nucleation emulated as Oxide
(sdegeo:create-rectangle 
  (position 0 Y0_nucleation 0) (position Xmax Ybot 0) 
  "Oxide" "nucleation" 
)

; pGaN Gate
(sdegeo:create-rectangle 
  (position Xgt.l Y0_AlGaN_1 0) (position Xgt.r Ytop 0) 
  "GaN" "GaN_gate" 
)
(sdedr:define-constant-profile "ndop_GaN_gate_const" "BoronActiveConcentration" NpGaN_gate)
(sdedr:define-constant-profile-region "ndop_GaN_gate_const" "ndop_GaN_gate_const" "GaN_gate")


;---------------------------------------------------------------------------
; "Build" device
;---------------------------------------------------------------------------
(define Ycontact (+ Y0_AlGaN_1 0.045))

(define src.metal (sdegeo:create-rectangle 
  (position 0 Ytop 0) (position Xsrc Ycontact 0)
  "Metal" "tmp.source" 
))

(define drn.metal (sdegeo:create-rectangle 
  (position Xdrn Ytop 0) (position Xmax Ycontact 0)
  "Metal" "tmp.drain" 
))

(define dummy (sdegeo:create-rectangle
        (position Xgt.l Ytop 0) (position Xgt.r (- Y0_AlGaN_1 tpGaN_gate) 0)
  "Metal" "dummy"
        ))
(sdegeo:delete-region dummy)

(sdegeo:set-default-boolean "BAB")


(define gate.metal (sdegeo:create-rectangle
        (position (- Xgt.l LeftOV) Y0_AlGaN_1 0) (position (+ Xgt.r RightOV) (- Ytop 0.1) 0)
  "Metal" "gate.metal"
        ))

; Define electrodes
(sdegeo:define-contact-set "drain")
(sdegeo:set-current-contact-set "drain")
(sdegeo:set-contact-boundary-edges drn.metal)
(sdegeo:delete-region drn.metal)
 
(sdegeo:define-contact-set "source")
(sdegeo:set-current-contact-set "source")
(sdegeo:set-contact-boundary-edges src.metal)
(sdegeo:delete-region src.metal)
 
(sdegeo:define-contact-set "gate")
(sdegeo:set-current-contact-set "gate")
(sdegeo:set-contact-boundary-edges gate.metal)
(sdegeo:delete-region gate.metal)

; Define thermodes
(sdegeo:insert-vertex (position 0 (+ Ycontact 0.1) 0))
(sdegeo:insert-vertex (position Xmax (+ Ycontact 0.1) 0))
(sdegeo:define-contact-set "thermal")
(sdegeo:set-current-contact-set "thermal")
(sdegeo:define-2d-contact (find-edge-id (position 0.0001 Y0_nucleation 0)) "thermal")
(sdegeo:define-2d-contact (find-edge-id (position 0 (+ Ycontact 0.2) 0)) "thermal")
(sdegeo:define-2d-contact (find-edge-id (position Xmax (+ Ycontact 0.2) 0)) "thermal")

;---------------------------------------------------------------------------
; 2D Doping profiles
;---------------------------------------------------------------------------
; Doping to facilitate ohmic contacts
(sdedr:define-constant-profile "Ohmic" "ArsenicActiveConcentration" 1E+21)

(sdedr:define-refeval-window "Pl.ohmic.d" "Rectangle"  
		(position Xdrn Ytop 0) (position Xmax Ycontact 0))
(sdedr:define-constant-profile-placement "Ohmic.d" "Ohmic" "Pl.ohmic.d" 0.002)

(sdedr:define-refeval-window "Pl.ohmic.s" "Rectangle"  
		(position 0 Ytop 0) (position Xsrc Ycontact 0))
(sdedr:define-constant-profile-placement "Ohmic.s" "Ohmic" "Pl.ohmic.s" 0.002)

;---------------------------------------------------------------------------
; Meshing
;---------------------------------------------------------------------------
; Global
(sdedr:define-refeval-window "Pl.global" "Rectangle"
                (position 0 Ytop 0) (position Xmax Ybot 0))
(sdedr:define-refinement-size "Ref.global" (/ Xmax 16) (/ Ybot 16) 0.002 0.002)
(sdedr:define-refinement-placement "Ref.global" "Ref.global" "Pl.global")
(sdedr:define-refinement-function "Ref.global" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-function "Ref.global" "MaxLenInt" "GaN" "Nitride" 0.0005 1.8)
(sdedr:define-refinement-function "Ref.global" "MaxLenInt" "GaN" "AlGaN" 0.0004 1.8 "DoubleSide")
(sdedr:define-refinement-function "Ref.global" "MaxLenInt" "GaN" "Oxide" 0.01 2)

; Channel
(sdedr:define-refeval-window "Pl.channel" "Rectangle"   
                (position Xgt.l Ytop 0) (position Xgt.r (+ Y0_GaN_channel 0.1) 0))
(sdedr:define-refinement-size "Ref.channel" (/ Lg 8) 99 0.004 66)
(sdedr:define-refinement-placement "Ref.channel" "Ref.channel" "Pl.channel")
(sdedr:define-refinement-function "Ref.channel" "MaxLenInt" "GaN" "" 0.0005 1.8)

; Electron spreading
(sdedr:define-refeval-window "Pl.eDensity" "Rectangle"  
  (position (- Xgt.r 0.4) Y0_AlGaN_1 0) (position (+ Xgt.r 0.6) (+ Y0_GaN_channel 0.5) 0))
(sdedr:define-refinement-size "Ref.eDensity" 0.05 0.05 0.01 0.01)
(sdedr:define-refinement-placement "Ref.eDensity" "Ref.eDensity" "Pl.eDensity")

; Ungated drain
(sdedr:define-refeval-window "Pl.ungated.d" "Rectangle"  
  (position Xgt.r Y0_AlGaN_1 0) (position Xdrn (+ Y0_GaN_channel 0.4) 0))
(sdedr:define-refinement-size "Ref.ungated.d" (/ Lgd 16) 99 (/ Lgd 32) 66)
(sdedr:define-refinement-placement "Ref.ungated.d" "Ref.ungated.d" "Pl.ungated.d")

; Ungated source
(sdedr:define-refeval-window "Pl.ungated.s" "Rectangle"  
  (position Xsrc Y0_AlGaN_1 0) (position Xgt.l (+ Y0_GaN_channel 0.2) 0))
(sdedr:define-refinement-size "Ref.ungated.s" (/ Lsg 4) 99 (/ Lsg 8) 66)
(sdedr:define-refinement-placement "Ref.ungated.s" "Ref.ungated.s" "Pl.ungated.s")

; Drain contact edge
(sdedr:define-refeval-window "Pl.drain_c" "Rectangle"
                (position (- Xdrn 0.1) Ytop 0) (position (+ Xdrn 0.06) Y0_GaN_channel 0))
(sdedr:define-refinement-size "Ref.drain_c" 0.01 99 0.002 66)
(sdedr:define-refinement-placement "Ref.drain_c" "Ref.drain_c" "Pl.drain_c")

; Drain tunneling
(sdedr:define-refeval-window "Pl.drain_c.t" "Rectangle"
                (position (- Xdrn 0.015) Y0_GaN_channel 0) (position Xmax (+ Ycontact 0.005) 0))
(sdedr:define-refinement-size "Ref.drain_c.t" 0.1 0.05 0.002 0.002)
(sdedr:define-refinement-placement "Ref.drain_c.t" "Ref.drain_c.t" "Pl.drain_c.t")

; Drain tunneling 2
(sdedr:define-refeval-window "Pl.drain_c.t2" "Rectangle"
                (position (- Xdrn 0.012) Y0_GaN_channel 0) (position Xdrn (+ Y0_GaN_channel 0.012) 0))
(sdedr:define-refinement-size "Ref.drain_c.t2" 0.001 0.002 0.0005 0.001)
(sdedr:define-refinement-placement "Ref.drain_c.t2" "Ref.drain_c.t2" "Pl.drain_c.t2")
; Source contact edge
(sdedr:define-refeval-window "Pl.source_c" "Rectangle"
                (position (- Xsrc 0.04) Ytop 0) (position (+ Xsrc 0.04) Y0_GaN_channel 0))
(sdedr:define-refinement-size "Ref.source_c" 0.04 99 0.004 66)
(sdedr:define-refinement-placement "Ref.source_c" "Ref.source_c" "Pl.source_c" )

; Source tunneling
;(sdedr:define-refeval-window "Pl.source_c.t" "Rectangle"
;               (position Xmin Y0_AlGaN_1 0) (position (+ Xsrc 0.015) (+ Ycontact 0.005) 0))
;(sdedr:define-refinement-size "Ref.source_c.t" 0.1 0.05 0.002 0.002)
;(sdedr:define-refinement-placement "Ref.source_c.t" "Ref.source_c.t" "Pl.source_c.t")

; Source tunneling 2
(sdedr:define-refeval-window "Pl.source_c.t2" "Rectangle"
                (position Xsrc Y0_GaN_channel 0) (position (+ Xsrc 0.012) (+ Y0_GaN_channel 0.012) 0))
(sdedr:define-refinement-size "Ref.source_c.t2" 0.001 0.002 0.0005 0.001)
(sdedr:define-refinement-placement "Ref.source_c.t2" "Ref.source_c.t2" "Pl.source_c.t2")
; Right gate contact edge
(sdedr:define-refeval-window "Pl.contact_r" "Rectangle"
                (position (- Xgt.r 0.02) Ytop 0) (position (+ Xgt.r 0.02) (+ Y0_GaN_channel 0.005) 0))
(sdedr:define-refinement-size "Ref.contact_r" 0.005 99 0.001 66)
(sdedr:define-refinement-placement "Ref.contact_r" "Ref.contact_r" "Pl.contact_r")

; Left gate contact edge
(sdedr:define-refeval-window "Pl.contact_l" "Rectangle"
                (position (- Xgt.l 0.02) Ytop 0) (position (+ Xgt.l 0.024) Y0_GaN_channel 0))
(sdedr:define-refinement-size "Ref.contact_l" 0.004 99 0.002 66)
(sdedr:define-refinement-placement "Ref.contact_l" "Ref.contact_l" "Pl.contact_l")


;---------------------------------------------------------------------------
(sde:build-mesh "n@node@")
;---------------------------------------------------------------------------
                               
