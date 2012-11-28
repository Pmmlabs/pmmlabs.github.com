; Посчитать количество слов, в которых встречается 2 рядом стоящие одинаковые буквы
org 100h

.MODEL tiny
Number		=	12 
start:     
    ; ввод элементов массива
	mov ah,09h
	lea dx,Input_str
	int 21h  
	
    xor cx,cx
    xor si,si

input:		
	call ReadChar 
	mov [Mas+si],al		
	cmp al,13
	je continue_input     
	inc si  
loop input

continue_input:
    mov [Mas+si],' '; делаем из Mas строку
    inc si   
    mov [Mas+si],'$'
    call Enter             
    
    ; вывод "результат:"
    mov ah,09h
    lea dx,Res
    int 21h   
    
    ; вызов основной процедуры с сохранением параметров в стек   
    lea di, Mas; сохраним массив
    push di    
    call check ; вызов процедуры       
    int 20h; возврат в ос
 
;;;;;;;;;;;;;;;;;;;;; ОСНОВНАЯ ПРОЦЕДУРА ;;;;;;;;;;;;;;;;;;;;;;;
CHECK PROC  
    push bp  
    
    mov bp,sp  
    mov  si, [bp+4] ;строка
	      
	PUSH	AX		; сохраняем регистры
	PUSH	CX		;
	PUSH	BX		;
	PUSH	DX		;
	PUSH	SI		;
	PUSH	DI		; 
	
	xor cx,cx             ; обнуляем счетчик найденных подходящих слов
	mov bl, [si]              
   ; mov si, si + 2
    inc si
     
cheking: 
    mov al, [si]                       
    cmp al, last         ; если строка кончилась - выводим результат  
    je Output              
    cmp al, space        ; если дошли до пробела, переходим на следующее слово
    je skip_tail
    cmp al, bl         ; если нашли нужные буквы
    je found
    mov bl, [si]       ; записываем символ в bl
    inc si
    jmp cheking
    
    
found:
    inc cx
    jmp skip_tail                   
     
    
skip_tail:             ;пропустить остаток слова в DI
    mov al, [si]                      
    cmp al, last     
    je Output
    cmp al, space   
    je skip_spaces     
    inc si
    jmp skip_tail  
    
skip_spaces:           ;пропустить пробелы до начала следующего слова в DI
    mov al, [si]                      
    cmp al, last     
    je Output        
    cmp al, space   
    jne cheking    
    inc si
    jmp skip_spaces 
    
Output:  
        std                ; Устанавливаем ОБРАТНЫЙ порядок записи
		lea	di,StringEnd-1 ; ES:DI = последний символ строки String 

        mov ax, cx         ; число в ax
		mov	cx,10          ; Задаемся делителем CX = 10
Repeat:
		xor	dx,dx          ; Обнуляем DX (для деления)
		div	cx             ; Делим DX:AX на CX (10),
                           ; Получаем в AX частное, в DX остаток
		xchg	ax,dx      ; Меняем их местами (нас интересует остаток)
		add	al,'0'         ; Получаем в AL символ десятичной цифры
		stosb              ; И записываем ее в строку
		xchg	ax,dx      ; Восстанавливаем AX (частное)
		or	ax,ax          ; Сравниваем AX с 0
		jne	Repeat         ; Если не ноль, то повторяем  
		
		mov	ah,9
		lea	dx,[di+1]      ; Заносим в DX адрес начала строки
		int	21h            ; Выводим ее на экран
		jmp exit
	

exit:
	POP	DI		; восстанавливаем
	POP	SI		; регистры
	POP	DX		;
	POP	BX		;
	POP	CX		;
	POP	AX		; 
	pop bp
	RET
CHECK ENDP ; конец процедуры                                

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

; ввод одного символа   
ReadChar proc      
    mov     ah,1 
    int     21h          
    ret  
ReadChar endp
;==================================================
; перевод строки  
Enter proc
    mov ah,09h
    lea dx,crlf
    int 21h    
    ret
Enter endp    
;================================================== 

Mas db 128 dup (0) ; начальная строка
R db 128 dup (0) ; результирующая строка
n_cur_pos db 0    ;начальная позиция текущего слова
n_temp_pos db 0
n_pos db 0       ;начальная позиция предыдущего слова     

String		db	5 dup (?),'$'  ; Резервируем 5 байт для строки
StringEnd	=	$-1            ; Указывает на символ '$'
  
LAST    DB '$'    ;конец строки 
SPACE   DB ' '  ;пробел     
Input_str db 'Введите строку: ','$'   
crlf db 0dh,0ah,'$'
Res db 'Результат: ','$' 
           
end start