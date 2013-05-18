#lang scheme
; 9. По заданному дереву посчитать количество каждого из заданных элементов.
(define list1 `(5 2 3 4 1) ) ; Список заданных элементов для подсчета
(define tree1 `(1 (2 (4 5) 2) (3 1 7) 5) ) ; Дерево: (узел поддерево1 ... поддеревоN)
(define (check_elem haystack needle) ; Возвращает список вида `(0 1 0), где 1 на месте элемента needle в списке haystack
	(if (null? (cdr haystack)) ; Если список заданных элементов содержит только один элемент
		(if (= needle (car haystack))
				`(1)
				`(0)
		)
		(if (= needle (car haystack))
			(append `(1) (check_elem (cdr haystack) needle))
			(append `(0) (check_elem (cdr haystack) needle))
		)
	)
)
(define (sum_lists a b) ; почленное сложение двух списков
	(append
		(list (+ (car a) (car b)))
		(if (null? (cdr a))
			`()
			(sum_lists (cdr a) (cdr b))
		)
	)
)
(define (subtrees _list branches) ; Обработка всех веток узла
	(if (null? (cdr branches)) ; если осталась только одна ветка
		(count_elements _list (car branches))
                (sum_lists
			(count_elements _list (car branches))
			(subtrees _list (cdr branches))
		)
                
	)
)
(define (count_elements _list _tree) ; подсчет количества заданных элементов в дереве
	(if (list? _tree)
		(sum_lists 
			(check_elem _list (car _tree)) ; проверка числа в узле
			(subtrees _list (cdr _tree)) ; обработка веток
		)
                (check_elem _list _tree) ; если _tree - это просто число
	)
)
`Список: list1
`Количества: (count_elements list1 tree1)