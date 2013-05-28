; 14. Проверить, является ли заданный граф связным.
; смежная вершина (первая вершина ребра, вторая вершина ребра, 
;   список найденных вершин, список новых вершин) 
(defun smezver(x y snaid snov) 
         (cond 
         ((not (member x snov)) nil)    ;x не является новой вершиной 
         ((member y snov) nil)    ;y является новой вершиной 
         ((member y snaid)         nil)    ;y является ранее найденной вершиной 
         (t       t)))     ;вершина является новой смежной вершиной 
;поиск смежных вершин (список найденных вершин, список новых вершин, список ребер) 
(defun smez(snaid snov sreb) 
         (cond 
         ((null sreb)  nil)    ;конец поиска 
         ((smezver (caar sreb) (cadar sreb) snaid snov)    ;смежная вершина 
         (cons (cadar sreb) (smez snaid snov (cdr sreb))))         ;добавление в список 
         ((smezver (cadar sreb) (caar sreb) snaid snov)    ;смежная вершина 
         (cons (caar sreb) (smez snaid snov (cdr sreb))))  ;добавление в список 
         (t       (smez snaid snov (cdr sreb)))))         ;пропуск ребра 
;поиск в ширину (список найденных вершин, список новых найденных вершин, 
;     вершина для поиска, список ребер) 
(defun shir(snaid snov y sreb) 
(cond 
 ((null snov)         nil)    ;не найдено ни одной новой вершины 
 ((member y snov)         t)       ;вершина найдена 
 (t      (shir (append snaid snov) (smez snaid snov sreb) y sreb)))) ;добавление новых вершин 
;поиск пути (первая вершина, вторая вершина, список ребер) 
(defun path(x y sreb) 
         (shir nil (list x) y sreb)) ;поиск в ширину 
;перебор вершин (первая вершина, список вершин, список ребер) 
(defun perebor(fver sver sreb) 
         (cond 
 ((null sver) t)       ;конец перебора 
 ((path fver (car sver) sreb)     (perebor fver (cdr sver) sreb)) ;путь найден 
 (t      nil)))  ;нет пути 
;определение связанности графа(список вершин, список ребер) 
(defun svgraf(sver sreb) 
 (perebor (car sver) (cdr sver) sreb))          ;перебор вершин и поиск пути от первой вершины ко всем остальным 