;определить сколько раз 2 соседних слова начинается на одну букву  
 	.MODEL tiny
   	.CODE

	org	100h
start:

	mov	nst,0		; nst - число символов в строке
	lea	si,source		;адрес начала строки

	mov	ah,09h
	lea	dx,text1
	int	21h

outstr:	
;воод очередного символа
	call	ReadChar	;ввод очередного сивола с клавиатуры, возвращает символ в регистр al
	mov	[si],al		;пересылка символа в строку
	cmp     	al, 13   		;если  Enter ? то заканчиваем ввод строки
    	je      	done      		; да -  > завершение
	add	si,1		;подготовка адреса следующего символа
	inc	nst		;подсчет числа введенных символов
	jmp	outstr

done:	cmp	nst,0
	je	byby		;если не введено ни одного символа то на выход
;вывод введенного текста на дисплей
	call	vkps		;перевести строку

	mov	ah,09h
	lea	dx,text2
	int	21h

	mov	n,0		;инициализация счетчика символов
	lea	si,source		;загрузка адреа строки
	
lab1:	inc	n		;подсчет символов
	mov	al,[si]		;чтение символа из строки
	call	WriteChar	;вывод на дисплей очередного символа
	mov	bx,nst		;загрузка длинны строки
	cmp	n,bx		;проверка не конец ли строки
	je	lab2		;строка закончена
	add	si,1		;формирование адреса следующего символа
	jmp	lab1		;преход на вывод следующего символа
	
lab2:	call	vkps		;перевод строки




;сохранить параметры в стеке

	mov	bp,offset source	;lea	bp, source
	push	bp		;сохранить в стеке адрес строки
	mov	bp,nst
	push	bp		;сохранить в стеке длину строки

	call	work		;вызов подпрограммы определения соседних слов начинающихся с одной буквы

	pop	bp		;восстановить стек
	pop	bp		;восстановить стек
byby:	ret	

work proc
;определяем сколько раз соседние слова начинаются с одинаковой буквы
	push	bp
	mov	bp,sp		;сохранить увазатель стека
	push	ax
	push	bx
	push	si
	push	cx
	
	mov	si,[bp+4]		;в si пересылаем длину строки
	mov	bx,si		;получим число символов в строке из стека
	mov	si,[bp+6]		;получим адрес строки из стека

	cld			;строка читается слева на право
	xor	cx,cx		;сброс счетчика символов в строке
	mov	nsb,0		;сброс счетчика совпавших букв
m2:	mov	dl,[si]		;первый символ предыдущего слова
m1:	lodsb			;чтение символа из строки
	inc	cx		;подсчет числа символов
	cmp	cx,bx		;проверка не конец ли строки
	je	m3		;строка закочиена
	cmp	al,' '		;проверка на пробел (слово)
	jne	m1		;не пробел (слово в строке не окончилось)
	cmp	dl,[si]		;сравнить первую букву предыдущего слова с первой буквой текущего  слова
	jne	m2		;буквы не равны и далее сохранить первую букву текущего слова и все повторить
	inc	nsb		;буква одинаковы и подсчет одинаковых букв в соседних слов 
	jmp	m2		;повторяем дальше
m3:	
	mov	ah,09h
	lea	dx,text3
	int	21h

	mov	ax,nsb		;передадим число совпадениий попрограмме вывода на дисплей
	call	WriteInteger	;вывод числа совпадений
	pop	cx
	pop	si
	pop	bx
	pop	ax
	pop	bp
	ret
work endp


WriteChar proc  
;вывод символа на диплей
    	mov     	dl, al  
    	mov     	ah, 2  
    	int     	21h
    	ret  
WriteChar endp 

  

WriteInteger proc near 
    	push    	ax  
    	push    	cx  
    	push    	bx  
    	push    	dx  
    	xor     	cx, cx  
    	mov     	bx, 10  
	; число отрицательное?    
    	cmp     	ax,0
    	jl      	ddd	; если - да
    	jmp     	divl	; если - нет
	; вывести минус и поменять знак
ddd:
    	push    	ax
    	mov     	dl, '-'  
    	mov     	ah, 2  
    	int    	 21h
    	pop     	ax
    	neg     	ax  

	; получить 10-цифры и поместить их в стек,
	; в cx - количество полученных цифр
divl:  
    	xor     	dx, dx  
    	idiv    	bx  
    	push    	dx  
    	inc     	cx  
    	cmp     	ax,0     
    	jg     	divl  

	; достать из стека, перевести в код ASSII  и вывести  
popl:  
    	pop     	ax  
    	add     	al, '0'
  
    	call    	WriteChar  
    	loop    	popl  

    	pop     	dx
   	pop     	bx  
    	pop     	cx  
   	pop     	ax 
    	ret  
WriteInteger endp  


ReadChar proc 
; ввод одного символа с клавиатуры
	;результат в (al) 
    	mov     	ah,1 
    	int     	21h
    	ret  
ReadChar endp

vkps proc 
	push	ax
	push	dx	
	mov 	ah,09h		;перевод строки
	lea 	dx,crlf
	int 	21h
	int	21h
	pop	dx
	pop	ax
    	ret  
vkps endp


nst	dw	0	;n-число элементов в строке
nsb	dw	0	;число совпадений соседних букв	
n	dw 	0
text1	db	'vvedite stroku >  ','$'
text2	db	'vyvod stroki >  ','$'
text3	db	'chislo sovpadenii >  ','$'
;text4	db	'Input MAX > ','$'
;resn	db	'n= ','$'
;resm	db	'Max= ','$'
;res	db	'   ','$'
crlf	db	0dh,0ah,'$'      ; возврат каретки, перевод строки 
source	db	100 DUP(?) 



end start