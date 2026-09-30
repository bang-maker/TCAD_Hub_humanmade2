; Ga2O3_my MOSFET Example

;----------------------------------------------------------------------
; Global Definitions and Settings
;----------------------------------------------------------------------
(define NMTOUM 0.001) ; Conversion from [nm] to [um]
(define CMTOUM 1e4) ; Conversion from [cm] to [um]
;----------------------------------------------------------------------
; Overlap resolution: New replaces Old
(sdegeo:set-default-boolean "ABA")
;----------------------------------------------------------------------

;**********************************************************************
; NMOS Generation
;**********************************************************************

;----------------------------------------------------------------------
; Doping
;----------------------------------------------------------------------
(define SDDop @SDDop1@) 
(define DopSD  "ArsenicActiveConcentration")
(define SubDop @SubDop1@)
(cond 
  ((< SubDop 0)
  (begin
    (define DopSub "BoronActiveConcentration")
    (define SubDop (- 0 SubDop))
  ))
  ((>= SubDop 0)
  (begin
    (define DopSub "ArsenicActiveConcentration")
  ))
)
(define DopBody "ArsenicActiveConcentration")
(define BodyDop @BodyDop1@) ; n-sub Doping (50% of 7e17cm-3 Sn dopants are activated)



;----------------------------------------------------------------------
; Geometric Dimensions
;----------------------------------------------------------------------
(define Lg 2.0) ; Gate Length
(define Lsp (* 0.5 (- 20.0 Lg))) ; Spacer Length (No spacer in this structure. Used as an offset)
(define Lov 2.0) ; Overlap length of Al2O3_my (dielectric) and either source or drain. So the S/D contact length is Lsd - Lov
(define Lsd 5.0) ; Source/Drain length (arbitrarily given)
(define Ltot (+ Lg (* 2 (+ Lsp Lsd)))) ; Lateral extend total (from Source to Drain)

(define Hb (* 300.0 NMTOUM)) ; n-type body thickness
(define Hsub @Tsub1@) ; Fe-Doped Ga2O3_my substrate thickness
(define Tox (* 20.0 NMTOUM)) ; Gate oxide thickness (20[nm])
(define Tsd (* 150.0 NMTOUM)) ; S/D box profile depth

;----------------------------------------------------------------------
; Derived quantities
;----------------------------------------------------------------------
(define YDmid 0.0) ; Origin of x-axis
(define YDgmax (+ YDmid (* Lg 0.5)))
(define YDgmin (- YDmid (* Lg 0.5)))

(define YDspmax (+ YDgmax Lsp))
(define YDspmin (- YDgmin Lsp))

(define YDoxmax (+ YDspmax Lov))
(define YDoxmin (- YDspmin Lov))

(define YDsdmax (+ YDspmax Lsd))
(define YDsdmin (- YDspmin Lsd))

(define YDmin YDsdmin)
(define YDmax YDsdmax)

(define XDgox (* Tox -1.0)) ; Origin of y-axis = interface between Al2O3_my and Ga2O3_my
(define XDsd Tsd)
(define XDb Hb)
(define XDsub (+ XDb Hsub))

;----------------------------------------------------------------------
; Creating substrate
(sdegeo:create-rectangle 
  (position    XDsub  YDmin 0.0 ) 
  (position    XDb YDmax 0.0 ) 
  "Ga2O3_my" "Substrate" 
)

; Creating body
(sdegeo:create-rectangle 
  (position    XDb  YDmin 0.0 ) 
  (position    0.0 YDmax 0.0 ) 
  "Ga2O3_my" "Body" 
)

; Creating gate oxide
(sdegeo:create-rectangle 
  (position    0.0  YDsdmin 0.0 ) 
  (position    XDgox YDsdmax 0.0 ) 
  "Al2O3_my" "Gateox"
)

;----------------------------------------------------------------------
; Profiles:
; Substrate
(sdedr:define-constant-profile "Const.Substrate" DopSub SubDop)
(sdedr:define-refeval-window "Win.Substrate" "Rectangle" (position XDb YDmin 0.0) (position XDsub YDmax 0.0))
(sdedr:define-constant-profile-placement "Place.Substrate" "Const.Substrate" "Win.Substrate")

; Body
(sdedr:define-constant-profile "Const.Body" DopBody BodyDop)
(sdedr:define-refeval-window "Win.Body" "Rectangle" (position 0.0 YDmin 0.0) (position XDb YDmax 0.0))
(sdedr:define-constant-profile-placement "Place.Body" "Const.Body" "Win.Body")

; S/D
(sdedr:define-constant-profile "Box.SD" DopSD SDDop)
(sdedr:define-refeval-window "Win.S" "Rectangle"
  (position 0.0 YDsdmin 0.0)
  (position XDsd YDspmin 0.0)
)
(sdedr:define-constant-profile-placement "Place.S" "Box.SD" "Win.S")

(sdedr:define-refeval-window "Win.D" "Rectangle"
  (position 0.0 YDspmax 0.0)
  (position XDsd YDsdmax 0.0)
)
(sdedr:define-constant-profile-placement "Place.D" "Box.SD" "Win.D")

;----------------------------------------------------------------------
; Contact declarations
;----------------------------------------------------------------------
(sdegeo:define-contact-set "source" 
  4.0  (color:rgb 0.0 1.0 0.0 ) "##")

(sdegeo:define-contact-set "drain" 
  4.0  (color:rgb 0.0 1.0 0.0 ) "##")

(sdegeo:define-contact-set "gate" 
  4.0  (color:rgb 0.0 0.0 1.0 ) "##")

(sdegeo:define-contact-set "substrate" 
  4.0  (color:rgb 0.0 0.0 1.0 ) "##")


;----------------------------------------------------------------------
; Contact settings
;----------------------------------------------------------------------
; Source Contact
(sdegeo:insert-vertex (position 0.0 YDspmin 0.0)) ; insert vertex to form contact edges. Assuming 10% margin in left and right
(sdegeo:define-2d-contact 
 (find-edge-id (position 0.0 (* (+ YDspmin YDsdmin) 0.5) 0.0))
 "source")

; Drain Contact
(sdegeo:insert-vertex (position 0.0 YDspmax 0.0)) ; insert vertex to form contact edges
(sdegeo:define-2d-contact 
 (find-edge-id (position 0.0 (* (+ YDspmax YDsdmax) 0.5) 0.0))
 "drain")

(sdegeo:insert-vertex (position XDgox YDgmin 0.0)) ; insert vertex to form contact edges
(sdegeo:insert-vertex (position XDgox YDgmax 0.0)) ; insert vertex to form contact edges
(sdegeo:define-2d-contact 
 (find-edge-id (position XDgox YDmid 0.0))
 "gate")

;----------------------------------------------------------------------
; Meshing Strategy:

; Body
(sdedr:define-refinement-size "Ref.Body" 
 (/ Hb 10.0) (/ Ltot 10.0)  
 (/ Hb 20.0) (/ Ltot 20.0)   
)
(sdedr:define-refinement-function "Ref.Body" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-region "RefPlace.Body" 
 "Ref.Body" "Body" )

; SD
(sdedr:define-refinement-window "RefWin.S" 
 "Rectangle"  
 (position  0.0   (* 0.9 YDspmin)  0.0) 
 (position  (* 1.1 XDsd)  YDsdmin 0.0)
)
(sdedr:define-refinement-window "RefWin.D" 
 "Rectangle"  
 (position  0.0   (* 0.9 YDspmax)  0.0) 
 (position  (* 1.1 XDsd)  YDsdmax 0.0)
)
(sdedr:define-refinement-size "Ref.SD" 
 (/ Tsd 10.0) (/ Lsd 10.0)  
 0.005 0.005
)

(sdedr:define-refinement-function "Ref.SD" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-placement "RefPlace.S" 
 "Ref.SD" "RefWin.S" )
(sdedr:define-refinement-placement "RefPlace.D" 
 "Ref.SD" "RefWin.D" )

; Gate oxide
(sdedr:define-refinement-size "Ref.GOYD" 
 (/ Tox 10.0) (/ Ltot 10.0)  
 (/ Tox 50.0) (/ Ltot 50.0)   
)
(sdedr:define-refinement-region "RefPlace.GOYD" 
 "Ref.GOYD" "Gateox" )

; Channel Multibox
(sdedr:define-refinement-window "MBWin.Channel" 
 "Rectangle"  
 (position  0.0   (* YDspmin 1.1) 0.0) 
 (position (* 0.1 XDsd)  (* YDspmax 1.1) 0.0)
)
(sdedr:define-multibox-size "MBSize.Channel" 
 (/ XDb 100.0)  (/ Lg 10.0) 
 (/ XDb 200.0)  (/ Lg 20.0)  
 1.1         1.0 
)
(sdedr:define-multibox-placement "MBPlace.Channel" 
 "MBSize.Channel" "MBWin.Channel" )

;----------------------------------------------------------------------
; Build Mesh
(sde:build-mesh "" "n@node@_msh")
