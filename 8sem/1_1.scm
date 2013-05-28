; 1. Найти корень уравнения f(x) = 0 на промежутке [a, b] методом деления отрезка пополам.
(define (bisect f a b eps)
  (let* ((c (* 0.5 (+ a b)))
     (fc (f c)))
    (cond ((< (- b a) eps)
       c)
      ((= fc 0)
       c)
      ((eqv? (< (f a) 0)
        (< fc 0))
       (bisect f c b eps))
      (else
       (bisect f a c eps)))))