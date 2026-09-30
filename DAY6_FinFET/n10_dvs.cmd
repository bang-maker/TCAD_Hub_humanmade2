
(define W 10.0)
(define L 10.0)

(define Num 20)
(define dx  1.0)

(define x0 0.0)
(define y0 0.0)

(do 
	; init variable
	(
		(i 1 (+ i 1))
	)
	; stop criterial
	(
		(> i Num)	
	)
	(sdegeo:create-rectangle (position x0 y0 0.0)
		(position (+ x0 W) (+ y0 L) 0.0) 
		"Silicon" (string-append "R.Silicon" (number->string i)))
	(set! x0 (+ x0 dx W))
); do 

(do 
	; init variable
	(
		(i 1 (+ i 1))
	)
	; stop criterial
	(
		(> i Num)	
	)
 
	(sdedr:define-constant-profile (string-append "DF.Dop" (number->string i))
		"PhosphorusActiveConcentration" (* i 1e15))
	(sdedr:define-constant-profile-region (string-append "PL.Dop" (number->string i))
		(string-append "DF.Dop" (number->string i)) (string-append "R.Silicon" (number->string i)) )
 
); do 





(sde:save-model "n10")
(sde:build-mesh "n10")

