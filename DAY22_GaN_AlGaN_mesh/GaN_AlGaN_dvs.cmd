; Reinitializing SDE 
(sde:clear)
; set coordinate system up direction 
(sde:set-process-up-direction "+z")


(define Wdev 1.0)
(define tAlGaN @t_barrier@)
(define tGaN   0.1)
(define tWafer 1.0)

(sdegeo:create-rectangle
  (position 0 0 0) (position Wdev tAlGaN 0) 
  "AlGaN" "R.AlGaN"
) 

(sdegeo:create-rectangle
  (position 0 tAlGaN 0) (position Wdev (+ tAlGaN tGaN) 0) 
  "GaN" "R.GaN"
) 

(sdegeo:create-rectangle
  (position 0 (+ tAlGaN tGaN) 0) (position Wdev (+ tAlGaN tGaN tWafer) 0) 
  "GaN" "R.Wafer"
)


; =================== CONTACT =========================
(define CONT "top")
(define POINT (position (/ Wdev 2) 0 0))
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
; - 2D:
(sdegeo:set-contact (find-edge-id POINT) CONT)

(set! CONT "bottom")
(set! POINT (position (/ Wdev 2) (+ tAlGaN tGaN tWafer) 0))
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
; - 2D:
(sdegeo:set-contact (find-edge-id POINT) CONT)
; =================== Molefraction =======================
; Constant doping profile in a redion
(define NAME "xMole")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"xMoleFraction" @x_barrier@)
(sdedr:define-constant-profile-region (string-append "CPM." NAME)
	(string-append "DC." NAME) "R.AlGaN" )



; =================== MESH =========================
(define dW (/ Wdev  20) )
(define dT (/ tAlGaN  10) )
 
 
(sdedr:define-refeval-window "Global_RW" "Cuboid"
	 (position -1000     -1000     0)  
	 (position 1000       1000     0)
 )
(sdedr:define-refinement-size "Global_RD"
	  (* dW 3)  (* dT 3)     0
	  (* dW 1)  (* dT 1)     0 )
 
(sdedr:define-refinement-function "Global_RD" "MaxLenInt" 
                      "AlGaN" "GaN"   @t_mesh@ 1.5 "DoubleSide")
(sdedr:define-refinement-function "Global_RD" "MaxLenInt" 
                      "GaN" "GaN"   0.0005 1.5 "DoubleSide")
(sdedr:define-refinement-placement "Global_PL" "Global_RD" "Global_RW" )
 
(sde:build-mesh "-AI" "n@node@_msh")