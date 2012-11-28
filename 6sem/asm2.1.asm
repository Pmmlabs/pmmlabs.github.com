;Проверить меняются ли в массиве отрицательные и положительные числа
.MODEL tiny

.CODE                            
org 100h 

_START:	

;ввод числа элементов массива

	mov	ah,09h
	lea	dx,text1
	int	21h	
    call ReadInteger		;ввод с клавиатуры и преобразование в Integer 
	mov	n,ax				;запомнить число элементов массива

	mov ah,09h				;перевод строки
	lea dx,crlf
	int 21h
	
	mov ah,09h    			;пишем на экране введённое число
	lea dx,resn
	int 21h

    mov ax,n
    call WriteInteger		;преобразование в символ и вывод на дисплей

	mov ah,09h				;перевод строки
	lea dx,crlf
	int 21h
	
;ввод массива из n элементов
	lea	di,array			;адрес первого элемента массива

	mov	ah,09h
	lea	dx,text2
	int	21h
	mov	bx,0	
masi:
    call ReadInteger		;ввод  с клавиатуры и преобразование в Integer 
    mov A,ax	

	mov	[di],ax				;запомнить элемент массива
	add	di,2				;подготовка адреса следующего элемента массива

	mov ah,09h
	lea dx,crlf
	int 21h
	
	mov ah,09h
	lea dx,res
	int 21h

	mov ah,09h				;перевод строки
	lea dx,crlf
	int 21h

	inc	bx
	cmp	bx,n
	jb	masi
	
;вывод массива на дисплей
	lea	di,array			;адрес первого элемента массива
	mov	ah,09h
	lea	dx,text3
	int	21h
	mov	bx,0
	
maso:
	mov ax,[di]
	add	di,2				;подготовка адреса следующего элемента массива
    call WriteInteger		;преобразование в символ и вывод на дисплей

	mov ah,09h				;перевод строки
	lea dx,crlf
	int 21h

	inc	bx
	cmp	bx,n
	jb	maso

;сохранить параметры в стеке
	lea	bp,array
	push bp
	mov	bp,n
	push bp

	call work	;проверка на перемену знаков	

	ret	
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;@WORK@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@@WORK@
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

work proc 

    PUSH BP				; сохраняем bp
    MOV BP, SP
    PUSH AX				;сохраняем регистры
    PUSH BX 
    PUSH CX
    PUSH DX
    PUSH SI	
	
	mov	di,[bp+4]
	mov	cx,Di			;получим разmер массива из стека
	mov	di,[bp+6] 		;получим адрес массива из стека
	mov dx,0			;Указатель результата
Pr: 
	MOV AX,[di]			;Записываем первый элемент массива в AX
	CMP AX,0			;Проверяем положительное число или нет
	JS MINUS			;число отрицательное - переход на MINUS
	JNS PLUS			;число положительное - переход на PLUS
MINUS:	;если отрицательное
	CMP DX,0			;Смотрим какое было число раньше
	JZ L2				;если сейчас первый элемент то выполняем действия - L2
	JS VIHOD_NO			;если раньше было тоже отрицательное то выход с сообщение "НЕТ"
L2:	MOV DX,-1			;устанавливаем предыдущее значение в "-"
	add di,2			;движемся по массиву
	DEC cx				;условие выхода из цикла
	JCXZ VIHOD_YES		;если просмотрели уже все элементы то выходим и сообщаем "ДА"
	JMP Pr				;если ещё не все элементы просмотрели то повторяем действия
PLUS:
	CMP DX,0			;проверяем что было раньше "+" или "-"
	JZ L1				;если сейчас первый элемент то выполняем действия - L1
	JNS VIHOD_NO		;если раньше было тоже положительное то выход с сообщение "НЕТ"
L1:	MOV DX,1			;устанавливаем предыдущее значение в "+"
	add di,2			;движение по массиву
	DEC cx				;условие выхода из цикла
	JCXZ VIHOD_YES		;если просмотрели уже все элементы то выходим и сообщаем "ДА"
	JMP Pr				;если ещё не все элементы просмотрели то повторяем действия

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

VIHOD_YES: 
	MOV AH, 9
	MOV DX, offset YesMessage
	INT 21h
	JMP Finish	     	     	     

VIHOD_NO:  
	XOR AH, AH
	MOV AH, 9
	MOV DX, offset NoMessage
	INT 21h

Finish : 
	POP SI
	POP DX		; восстанавливаем регистры и возвращаем управление
	POP CX
	POP BX
	POP AX
	MOV SP, BP
	POP BP
	RET	     
	
work EndP 	

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

; ввод 10-числа в регистр AX 
ReadInteger proc  
	push    cx      ; сохранение регистров
	push    bx
 	push    dx 
 	mov     fl,0    ; флаг отрицательного числа
 	xor     cx, cx  
 	mov     bx, 10 
  	call    ReadChar  ; ввод первого символа

 	cmp     al,'-'   ; если минус - установить флаг
 	je      nnn
	jmp     nn
nnn:
 	mov     fl,1
   
read:
  
 	call    ReadChar   ; ввод очередного символа
nn: 	cmp     al, 13     ; Enter ?
    	je      done       ; да -  > завершение
    
    	sub     al, '0'    ; нет -> перевод цифры char -> int
    	xor     ah, ah  
    	xor     dx, dx   
    	xchg    cx, ax  
    	mul     bx  
    	add     ax, cx  
    	xchg    ax, cx  
    	jmp     read  
done:  
    	xchg    ax, cx  
    	cmp     fl,1
    	je      eee
    	jmp     ee
eee:
    	neg     ax
ee: 
 	pop     dx
    	pop     bx  
    	pop     cx 
    	ret  
ReadInteger endp  

; ввод одного символа   
ReadChar proc  
    	mov     ah,1 
    	int     21h 
    	ret  
ReadChar endp

; вывод 10-числа
WriteInteger proc near 
    push    ax  
    push    cx  
    push    bx  
    push    dx  
    xor     cx, cx  
    mov     bx, 10  
; число отрицательное?    
    cmp     ax,0
    jl      ddd	; если - да
    jmp     divl	; если - нет
; вывести минус и поменять знак
ddd:
    push    ax
    mov     dl, '-'  
    mov     ah, 2  
    int     21h
    pop     ax
    neg     ax  

; получить 10-цифры и поместить их в стек,
; в cx - количество полученных цифр
divl:  
    	xor     dx, dx  
    	idiv    bx  
    	push    dx  
    	inc     cx  
    	cmp     ax,0     
    	jg     divl  

; достать из стека, перевести в код ASSII  и вывести  
popl:  
    	pop     ax  
    	add     al, '0'
  
    	call    WriteChar  
    	loop    popl  

    	pop     dx
   	pop     bx  
    	pop     cx  
   	pop     ax 
    	ret  
WriteInteger endp  

; вывод одного символа  
WriteChar proc  
    push    ax  
    push    dx  
    mov     dl, al  
    mov     ah, 2  
    int     21h  
    pop     dx  
    pop     ax  
    ret  
WriteChar endp      

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@@DATA@
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

n	dw	10		;n-число элементов массива
A	dw	10
fl 	dw 	?		;отрицательное число

NoMessage db "No",13,10,"$"
YesMessage db "Yes ",13,10,"$"

text1	db	'Input Size array >  ','$'
text2	db	'Input Array',0dh,0ah,'$'
text3	db	'Output Array',0dh,0ah,'$'

resn	db	'n= ','$'
res	db	'   ','$'
crlf	db	0dh,0ah,'$'

array	dw	50 DUP(?)

end _START
