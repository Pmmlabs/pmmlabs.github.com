;Дано предложение. Определить есть ли в нём два одинаковых рядом стоящих слова.
org 100h

.MODEL tiny
 
start:     
    ; ввод элементов массива
	mov ah,09h
	lea dx,Input_str
	int 21h  
	
    xor cx,cx; бесконечный цикл
    xor si,si; в si количество элементов 

input:		
	call ReadChar 
	mov [Mas+si],al		
	cmp al,13
	je continue_input     
	inc si  
loop input

continue_input:   
    mov [Mas+si],'$'; делаем из Mas строку  
    call Enter             
    
    ; результат:
    mov ah,09h
    lea dx,Res
    int 21h   
    
    ; вызов основной процедуры с сохранением параметров в стек   
    lea di, Mas; сохраним массив
    push di   
    xor cx,cx  
    call check ; вызов процедуры       
    int 20h; возврат в ос
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;;;;;;;;;;;;; ОСНОВНАЯ ПРОЦЕДУРА ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
CHECK PROC  
    push bp  
    
    mov bp,sp  
    mov  si, [bp+4] ;строка 
    mov di, [bp+4] 	
	      
	PUSH	AX		; сохраняем регистры
	PUSH	CX		;
	PUSH	BX		;
	PUSH	DX		;
	PUSH	SI		;
	PUSH	DI		; 
	             
main:                    ;di на начало 2го слова
    mov al, [di]                
    cmp al, last    
    je NO        
    jmp skip_tail_di
    
new_word:                ;si на текущем слове,di на следующем
    mov al, [di]
    
    cmp al, space
    je check_sec_ptr_space
    
    cmp al, last
    je check_sec_ptr_last
    
    cmp al, [si]
    jne skip_tail_si
    inc si
    inc di
    jmp new_word
        
    
skip_tail_si:             ;
    mov al, [si]                      
    cmp al, space   
    je skip_spaces_si     ;
    inc si
    jmp skip_tail_si
    
skip_spaces_si:        
    mov al, [si]                      
    cmp al, space   ;
    jne skip_tail_di    ;
    inc si
    jmp skip_spaces_si    
    
skip_tail_di:
    mov al, [di]                      
    cmp al, last     
    je NO
    cmp al, space   
    je skip_spaces_di     ;
    inc di
    jmp skip_tail_di  
    
skip_spaces_di:        
    mov al, [di]                      
    cmp al, last     
    je NO        ;
    cmp al, space   ;
    jne new_word    ;
    inc di
    jmp skip_spaces_di
    
check_sec_ptr_space:
    mov al, [si]
    cmp al, space
    je YES
    jne skip_tail_si

check_sec_ptr_last:
    mov al, [si]
    cmp al, space
    je YES
    jne NO 
    
NO:
    mov ah,09h
	lea dx,Res_no; нет того, что хотели
	int 21h
	jmp exit
	
YES:
    mov ah,09h
	lea dx,Res_yes; нет того, что хотели
	int 21h
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    

;==================================================
; ввод одного символа   
ReadChar proc      
    mov     ah,1 
    int     21h          
    ret  
ReadChar endp
;==================================================
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
;==================================================
; перевод строки  
Enter proc
    mov ah,09h
    lea dx,crlf
    int 21h    
    ret
Enter endp    
;================================================== 
  
;================================================== 
Mas db 128 dup (0) ; начальная строка
R db 128 dup (0) ; результирующая строка
n_cur_pos db 0    ;начальная позиция текущего слова
n_temp_pos db 0
n_pos db 0       ;начальная позиция предыдущего слова       
LAST    DB '$'    ;конец строки 
SPACE   DB ' '  ;пробел     
Input_str db 'Введите строку: ','$'   
Res_no db 'В тексте нет стоящих рядом одинаковых слов!','$'
Res_yes db 'В тексте есть необходимые слова!','$' 
crlf db 0dh,0ah,'$'
Res db 'Результат: ','$' 
           
end start