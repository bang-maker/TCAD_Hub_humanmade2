; Ga2O3 MOSCAP Example
;----------------------------------------------------------------------
; Global Definitions and Settings
;----------------------------------------------------------------------
(define NMTOUM 0.001) ; Conversion from [nm] to [um]
(define CMTOUM 1e4) ; Conversion from [cm] to [um]
;----------------------------------------------------------------------
; Overlap resolution: New replaces Old
(sdegeo:set-default-boolean "ABA")
;----------------------------------------------------------------------


;----------------------------------------------------------------------
; Doping
;----------------------------------------------------------------------
(define DopBody "ArsenicActiveConcentration")
(define BodyDop @BodyDop@) ; n-sub Doping (50% of 7e17cm-3 Sn dopants are activated)


;----------------------------------------------------------------------
; Geometric Dimensions
;----------------------------------------------------------------------
(define Lg 4.0) ; Gate Length
(define Lsp (* 0.5 (- 20.0 Lg))) ; Spacer Length (No spacer in this structure. Used as an offset)
(define Lov 2.0) ; Overlap length of Al2O3 (dielectric) and either source or drain. So the S/D contact length is Lsd - Lov
(define Lsd 5.0) ; Source/Drain length (arbitrarily given)
(define Ltot (+ Lg (* 2 (+ Lsp Lsd)))) ; Lateral extend total (from Source to Drain)

(define Hb (* 3000.0 NMTOUM)) ; n-type body thickness
(define Tox (* 20.0 NMTOUM)) ; Gate oxide thickness (20[nm])

;----------------------------------------------------------------------
; Derived quantities
;----------------------------------------------------------------------
(define YDmid 0.0) ; Origin of x-axis
(define YDgmax (+ YDmid (* Lg 0.5)))
(define YDgmin (- YDmid (* Lg 0.5)))

(define YDspmax (+ YDgmax Lsp))
(define YDspmin (- YDgmin Lsp))

(define YDsdmax (+ YDspmax Lsd))
(define YDsdmin (- YDspmin Lsd))

(define YDmin YDsdmin)
(define YDmax YDsdmax)

(define Xgox (* Tox -1.0)) ; Origin of y-axis = interface between Al2O3 and Ga2O3
(define Xb Hb)

;----------------------------------------------------------------------
; Creating body
(sdegeo:create-rectangle 
  (position    Xb YDmin  0.0 ) 
  (position    0.0 YDmax 0.0 ) 
  "Ga2O3_my" "Body" 
)

; Creating gate oxide
(sdegeo:create-rectangle 
  (position    0.0 YDmin 0.0 ) 
  (position    Xgox YDmax 0.0 ) 
  "Al2O3_my" "Gateox"
)

;----------------------------------------------------------------------
; Profiles:
; Body
(sdedr:define-constant-profile "Const.Body" DopBody BodyDop)
(sdedr:define-refeval-window "Win.Body" "Rectangle" (position 0.0 YDmin 0.0) (position Xb YDmax 0.0))
(sdedr:define-constant-profile-placement "Place.Body" "Const.Body" "Win.Body")

;----------------------------------------------------------------------
; Contact declarations
;----------------------------------------------------------------------
(sdegeo:define-contact-set "anode" 
  4.0  (color:rgb 0.0 0.0 1.0 ) "##")

(sdegeo:define-contact-set "cathode" 
  4.0  (color:rgb 0.0 0.0 1.0 ) "##")


;----------------------------------------------------------------------
; Contact settings
;----------------------------------------------------------------------
(sdegeo:insert-vertex (position Xgox YDgmin 0.0)) ; insert vertex to form contact edges
(sdegeo:insert-vertex (position Xgox YDgmax 0.0)) ; insert vertex to form contact edges
(sdegeo:define-2d-contact 
 (find-edge-id (position Xgox YDmid 0.0))
 "anode")

(sdegeo:define-2d-contact 
 (find-edge-id (position Xb YDmid 0.0))
 "cathode")

;----------------------------------------------------------------------
; Meshing Strategy:
; Body
(sdedr:define-refinement-size "Ref.Body" 
 (/ Hb 10.0)  (/ Ltot 10.0)  
  (/ Hb 20.0) (/ Ltot 20.0)  
)
(sdedr:define-refinement-function "Ref.Body" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-region "RefPlace.Body" 
 "Ref.Body" "Body" )

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
 (position 0.0 (* YDspmin 1.1)    0.0) 
 (position (* 0.02 Xb)  (* YDspmax 1.1) 0.0)
)
(sdedr:define-multibox-size "MBSize.Channel" 
 (/ Xb 1000.0) (/ Lg 10.0)  
 (/ Xb 2000.0) (/ Lg 20.0)   
 1.1         1.0
)
(sdedr:define-multibox-placement "MBPlace.Channel" 
 "MBSize.Channel" "MBWin.Channel" )

;----------------------------------------------------------------------
; Build Mesh
(sde:build-mesh "" "n@node@_msh")
