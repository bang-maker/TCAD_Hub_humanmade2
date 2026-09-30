; Reinitializing SDE 
(sde:clear)
; set coordinate system up direction 
(sde:set-process-up-direction "+z")
 

# device type 
(define type "@type@")

# Gate Trench 
(define WgateTrench 2.0)
(define TgateTrench 1.6)

#p- base 
(define Tpbase 0.7)
(define Wpbase 2)


#p+  
(define Wp_plus   WgateTrench )
(define Tp_plus 0.4)
(define Wp_plus_sidewall 0.35)


#channel 
(define L 0.5)

#oxide 
(define Tox 0.05)

#drift layer 
(define Tdrift 11)

#source trench 
(define TsourceTrench 1.6)
(define WsourceTrench 1)
(define Tsource 0.2)
(define Wsource 0.85)

#spacer 
(define LSourceGateSpacer 0.2)

 

#ploy Source
(define Tn_plus_polySi 	1.0)
(define Tp_minus_polySi	0.6)


#sub 
(define Tsub 1)
 
#doping profile 
(define Nsource 			1e19)
(define Npbase 				2e17)
(define Np_plus				2e18)
(define Nsub 				1e19)
(define Ndrift 				3e15)
(define Nn_plus_polySi		1e21)
(define Np_minus_polySi		1e17)


#widths and lengths 
(define Wcell (+ WgateTrench Wsource Wsource  WsourceTrench WsourceTrench))
(define Wcell_half (/ Wcell 2))

####structure 
(define R 50e-3)
# gate trench 
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-rectangle (position (/ WgateTrench 2)	 	 0 	0) (position 0 (* TgateTrench 1) 	  	 0 ) "Oxide" "Reg.GATEOX" ) 
(sdegeo:create-rectangle (position (- (/ WgateTrench 2) Tox) 0  0) (position 0 (- (* TgateTrench 1) Tox) 0 ) "PolySilicon" "Reg.GATE" ) 
(sdegeo:fillet-2d (list 
	(car (find-vertex-id (position (- (/ WgateTrench 2) Tox) (- (* TgateTrench 1) Tox)   0) ))
	)
	(+ R 0)  
	)
(sdegeo:fillet-2d (list 
	(car (find-vertex-id (position (/ WgateTrench 2) (* TgateTrench 1)   0) ))
	)
	(+ R Tox)  
	)


#p+  
(if (string=? type "GPMOS") 
	(begin 
		(sdegeo:set-default-boolean "BAB")
		(sdegeo:create-rectangle (position (/ Wp_plus 2) 0 	0) (position 0 (+ TgateTrench Tp_plus)  0 ) "SiliconCarbide" "Reg.P_PLUS" ) 
		(sdegeo:create-rectangle (position (+ (/ WgateTrench 2) Wsource) 0 	0) (position Wcell_half Tsource  0 ) "SiliconCarbide" "Reg.P_PLUS_SOURCE" ) 
		(sdegeo:fillet-2d (list 
			(car (find-vertex-id (position (/ Wp_plus 2) (+ TgateTrench Tp_plus) 0) ))
			)
			(+ R Tox)  
			)
	)
)

(if (string=? type "DTMOS") 
	(begin 
		(sdegeo:set-default-boolean "BAB")
		(sdegeo:create-rectangle (position (- Wcell_half WsourceTrench Wp_plus_sidewall) Tsource 	0) (position Wcell_half (+ TgateTrench Tp_plus)  0 ) "SiliconCarbide" "Reg.P_PLUS" ) 
		(sdegeo:fillet-2d (list 
			(car (find-vertex-id (position (- Wcell_half WsourceTrench Wp_plus_sidewall)  (+ TgateTrench Tp_plus) 0) ))
			)
			(+ R 0)  
			)
	)
)

 



#source 
(sdegeo:create-rectangle (position (/ WgateTrench 2) 0 	0) (position (+ (/ WgateTrench 2) Wsource) Tsource  0 ) "SiliconCarbide" "Reg.SOURCE" ) 
#pbase 
(sdegeo:create-rectangle (position (/ WgateTrench 2) (+ Tsource L) 	0) (position Wcell_half Tsource  0 ) "SiliconCarbide" "Reg.PBASE" ) 
#drift
(sdegeo:create-rectangle (position 0 Tsource 0) (position Wcell_half Tdrift   0 ) "SiliconCarbide" "Reg.DRIFT" ) 
#sub                                     
(sdegeo:create-rectangle (position 0 0 0) (position Wcell_half (+ Tsub Tdrift)   0 ) "SiliconCarbide" "Reg.SUB" ) 


#DT 
(if (string=? type "DTMOS")
		(begin
			(sdegeo:set-default-boolean "ABA")	
			(define dummysource (sdegeo:create-rectangle (position (- Wcell_half WsourceTrench) 0 0) (position Wcell_half TsourceTrench   0 ) "PolySilicon" "Reg.SOURCEMETAL" ) )			
			(entity:delete dummysource)
			(sdegeo:fillet-2d (list 
				(car (find-vertex-id (position (- Wcell_half WsourceTrench)   TsourceTrench 0) ))
				#(car (find-vertex-id (position ( + (- Wcell_half WsourceTrench  ) Wp_plus_sidewall)  (+ TgateTrench Tp_plus) 0) ))
				)
				(+ R 0)  
			)
		)
)
 
 

###doping    
(define NAME "P_PLUS")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"BoronConcentration" Np_plus)
(sdedr:define-constant-profile-region (string-append "CPM1." NAME)
	(string-append "DC." NAME) "Reg.P_PLUS")
(if (string=? type "GPMOS")
		(begin
			(sdedr:define-constant-profile-region (string-append "CPM2." NAME)
				(string-append "DC." NAME) "Reg.P_PLUS_SOURCE")
		)
)

(set! NAME "SOURCE")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"NitrogenConcentration" Nsource)
(sdedr:define-constant-profile-region (string-append "CPM1." NAME)
	(string-append "DC." NAME) "Reg.SOURCE")

(set! NAME "DRIFT")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"NitrogenConcentration" Ndrift)
(sdedr:define-constant-profile-region (string-append "CPM1." NAME)
	(string-append "DC." NAME) "Reg.DRIFT")

(set! NAME "SUB")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"NitrogenConcentration" Nsub)
(sdedr:define-constant-profile-region (string-append "CPM1." NAME)
	(string-append "DC." NAME) "Reg.SUB")

(set! NAME "PBASE")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"BoronConcentration" Npbase)
(sdedr:define-constant-profile-region (string-append "CPM1." NAME)
	(string-append "DC." NAME) "Reg.PBASE")

(set! NAME "GATE")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"PhosphorusConcentration" Nn_plus_polySi)
(sdedr:define-constant-profile-region (string-append "CPM1." NAME)
	(string-append "DC." NAME) "Reg.GATE")

(set! NAME "GATE_N_MINUS")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"NitrogenConcentration" Nn_plus_polySi)
(sdedr:define-constant-profile-region (string-append "CPM1." NAME)
	(string-append "DC." NAME) "Reg.POLY_SOURCE_N_PLUS")

(set! NAME "GATE_P_PLUS")
(sdedr:define-constant-profile (string-append "DC." NAME)
	"BoronConcentration" Np_minus_polySi)
(sdedr:define-constant-profile-region (string-append "CPM1." NAME)
	(string-append "DC." NAME) "Reg.POLY_SOURCE_P_MINUS")



#contact
 

(define CONT "drain")
(define POINT (position (/ Wcell 4) (+ Tdrift Tsub)  0))
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
; - 2D:
(sdegeo:set-contact (find-edge-id POINT) CONT)

(sdegeo:set-default-boolean "BAB")
(define dummySource2 (sdegeo:create-rectangle (position (+ (/ WgateTrench 2) LSourceGateSpacer) -1 0) (position Wcell_half TsourceTrench   0 ) "PolySi" "Reg.dummysource2" )		)
(set! CONT "source")
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
(sdegeo:set-contact dummySource2   CONT "remove")
 
(set! CONT "gate")
(set! POINT (position (/ WgateTrench 4) 0 0))
(sdegeo:define-contact-set CONT  4.0  (color:rgb 1.0 0.0 0.0 ) "##" )
; - 2D:
(sdegeo:set-contact (find-edge-id POINT) CONT)
 
; =================== MESH =========================
(define dW (/ Wcell  40) )
(define dT (/ Tdrift  60) )

(define dWch (/ Wsource 40 ) )
(define dTch (/ L 40 ))
 
(sdedr:define-refeval-window "Global_RW" "Cuboid"
	 (position -1000     -1000     0)  
	 (position 1000       1000     0)
 )
(sdedr:define-refinement-size "Global_RD"
	  (* dW 3)  (* dT 3)     0
	  (* dW 1)  (* dT 1)     0 )
(sdedr:define-refinement-function "Global_RD" "MaxLenInt" 
                      "All" "Oxide"   (/ Tox 4) 1.3)
(sdedr:define-refinement-function "Global_RD" "MaxLenInt" 
                      "SiliconCarbide" "SiliconCarbide"   0.02 1.2)
(sdedr:define-refinement-function "Global_RD" "MaxLenInt" 
                      "SiliconCarbide" "PolySilicon"   0.02 1.2)
(sdedr:define-refinement-placement "Global_PL" "Global_RD" "Global_RW" )

(sde:ft_scalar (string-append "Xmax " (number->string Wcell_half)))
(sde:ft_scalar (string-append "Xmin " (number->string 0)))
# compute AreaFactor 
(define area @area@)
(define AF (/ area Wcell_half))
(sde:ft_scalar (string-append "AF " (number->string AF))) ; "AF 1000"
#set AF x
#set Xmax x 
#set Xmin x

(sde:build-mesh "-AI" "n@node@_msh")