; 2. Отсортировать список чисел по возрастанию.
(define (partSort curIter kolToSort rezList inputList)
	(let ((a (car inputList))
			(b (car (cdr inputList)))
			)

		(if (= curIter kolToSort) (append rezList (list (min a b) (max a b)) (cdr (cdr inputList)))
			(partSort (+ curIter 1) kolToSort (append rezList (list (min a b))) (cons (max a b) (cdr (cdr inputList)))) 
		)
	)
)
(define (makePartSort numSort len lst)
	(if (= numSort len) lst
		(makepartSort (+ numSort 1) len (partSort 1 (- len numSort) (list) lst))
	)
)
(define (sortList lst)
	(makePartSort 1 (length lst) lst)
)

(sortList (list 5 4 3 7 2 8))