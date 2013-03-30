; 8. ѕроверить, €вл€етс€ ли указанное число простым.
(define (test x div lim) ;;; moves from div up to lim
(
	cond
		((> div lim) #t)
		((= 0 (mod x div)) #f)
		(else (test x (+ div 1) lim))
)
)

;;; checks if number is prime or not
(define (prm x) (test x 2 (sqrt x)))

;;; demo
(prm 14)