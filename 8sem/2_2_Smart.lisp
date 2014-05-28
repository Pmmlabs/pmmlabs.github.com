(defun sort1 (list-of-int)  
    (cond ((null list-of-int) nil) 
     
       ((= (length list-of-int) 1) list-of-int) 

       ((<= (car list-of-int) (cadr list-of-int)) 
               (check-again (cons (car list-of-int) (sort1 (cdr list-of-int))))) 

       (t (check-again (cons (cadr list-of-int) 
               (sort1 (cons (car list-of-int) (cddr list-of-int))))))))


(defun check-again (list-of-int) 
    (if (<= (car list-of-int) (cadr list-of-int)) 
    	list-of-int 
        (sort1 list-of-int))) 

(sort1 '(1 2 9 1 5 0 4) )
