(define seed 1.0)

;defination of function 

(define (c-rand) 
	(set! seed (remainder (+ (* 110351524533 seed) 1234567) 2147483648)); mode 
	(quotient seed 65536) ;
); 0~32769 integer

; uniform numbers in open interval (0, 1)
(define (unif-rand) 
	(/ (+ (c-rand) 1) 32769.0) ;32769 = 2147483648/65536
)

; Gaussian distribution by Box-Muller method
(define (normal-rand mid sigma)
	(+ mid (* sigma (* -2.0 (log (unif-rand))) (cos (* 2 PI (unif-rand)))))
) 

; function to get a list of 'n random numbers from generator 'r '() empty list  
(define (rand-list r n) = (if (zero? n) '() (cons (r) (rand-list r (- n 1)))))
 
; (rand-list unif-rand 3)
; (rand-list unif-rand 3)
; ( (unif-rand) (rand-list unif-rand 2))
; ( (unif-rand) (unif-rand) (rand-list unif-rand 1))
; ( (unif-rand) (unif-rand) (unif-rand) (rand-list unif-rand 0))
; ( (unif-rand) (unif-rand) (unif-rand) '())

(define (Lgate-normal) (normal-rand 20e-3 1e-3) )
(display (Lgate-normal))
(display (Lgate-normal))

(define RAND_LIST (rand-list Lgate-normal (+ 4 1)) )

(define rand_lgate (list-ref RAND_LIST 4))

(sde:ft_scalar (string-append "lgate " (number->string (* 1e3 rand_lgate) ) ))


(sdegeo:create-rectangle (position 0 0 0 ) (position rand_lgate rand_lgate 0.0 ) "Silicon" "R.channel")

(sde:save-model "n5")



