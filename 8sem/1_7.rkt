; 7. Проверить, является ли указанное число корнем многочлена.
#lang scheme 
(define (a x) (+ (* x x) (+ (* x 5) 6)))
(define y -2)
(define (check y) 
  (cond ((= (a y) 0) "да") 
  (else "нет"))
)
(check y)