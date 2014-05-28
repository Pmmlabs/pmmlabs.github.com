(defun combination (l n k pos last)
    (if (eq pos k)
     	(list (copy-list l))
    
        (if (AND (< last n) (< pos k) ) 
	    (append (combination (cons last l) n k (+ pos 1) last) (combination l n k pos (+ last 1))   )
            	    
	    (combination (cons last l) n k (+ pos 1) last )	    	  
        )
    )
)

(defun generator (n k)
    (combination '() n k 0 1 )       
)

(generator 5 3)
