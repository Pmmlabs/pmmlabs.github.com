; Дано предложение. В слове с заданным номером после заданной буквы вставить
; другую заданную букву.
org 100h

.MODEL tiny
 
start:     
; ввод элементов строки
	mov ah,09h
	lea dx,Input_str
	int 21h   

input:		
	call ReadChar 
	mov [Str_in+si],al		
	cmp al,13
	je continue_input     
	inc si  
loop input
                         
continue_input:
    mov [Str_in+si],'$'; делаем из Str_in строку  
    call Enter  
; ввод номера слова для вставки
    mov ah,9
    lea dx,Nomer_slova
    int 21h 
    call ReadInteger
    mov N_word,ax 
    call Enter
; ввод буквы для поиска 
    mov ah,9
    lea dx,CharToFind
    int 21h   
    call ReadChar 
	mov c_find,al
	call Enter
; ввод буквы для вставки 
    mov ah,9
    lea dx,CharToPaste
    int 21h   
    call ReadChar 
	mov c_paste,al
	call Enter     
; результат:
    mov ah,09h
    lea dx,Res
    int 21h   
; основная программа    
    CLD
    LEA di,es:str_IN ;загружаем адрес строки-приёмника    
    MOV BX,0  ; обнуление счетчика слов       	   
NEXTWORD:
    MOV		AL, ' '
    MOV		CX, 100
    REPE	SCASB ;пропуск пробелов
    JCXZ WORD
    JE EXIT       
WORD:
    INC BX             
    CMP N_WORD,BX ; если дошли до нужного слова
    JE CURWORD    ; перейти к поиску введенной буквы
    REPNE SCASB		;пропуск непробелов
    JCXZ NEXTWORD 
CURWORD:
    MOV		AL, C_FIND
    MOV		CX, 100
    REPNZ SCASB		;пропуск букв, не равных C_FIND
    JNZ EXIT  
    MOV		AL, C_PASTE
    STOSB
exit:
    MOV AL, '$'
    STOSB
    MOV DX,OFFSET STR_IN	
    MOV AH, 09H ;печать строки-результата
    INT 21H
    MOV AH, 4CH ;завершение программы
    INT 21H                                    
;----------------------------------------------------- 
ReadInteger proc  
    push    cx      ; сохранение регистров
    push    bx
    push    dx 
    mov     fl,0    ; флаг отрицательного числа(0 - полож., 1 -отриц.)
    xor     cx, cx  
    mov     bx, 10 
    call    ReadChar  ; ввод символа

    cmp     al,'-'   ; если минус - установить флаг
    je      minus
    jmp     nn
minus:
    mov     fl,1  
read: 
    call    ReadChar   ; ввод очередного символа
nn: cmp     al, 13     ; Enter ?
    je      done       ; да -  > завершение
    
    sub     al, '0'    ;вычитание иначе нет -> перевод цифры char -> int
    xor     ah, ah  
    xor     dx, dx   
    xchg    cx, ax  
    mul     bx  ;умножение чисел без знака
    add     ax, cx  
    xchg    ax, cx  
    jmp     read  
done:  
    xchg    ax, cx  
    cmp     fl,1
    je      eee
    jmp     ee
eee:
    neg     ax ; изменение знака
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
; перевод строки  
Enter proc
    mov ah,09h
    lea dx,crlf
    int 21h    
    ret
Enter endp    

Str_in db 128 dup (?) ; начальная строка
N_word dw 0       ;номер слова   
c_find db ?
c_paste db ? 
fl dw ?   
LAST    DB '$'    ;конец строки 
SPACE   DB ' '  ;пробел     
Input_str db 'Введите строку: ','$' 
Nomer_slova db 'Введите номер слова: ','$'
CharToFind db 'Введите букву, после которой надо вставить: ','$'       
CharToPaste db 'Введите букву, которую надо вставить: ','$'
crlf db 0dh,0ah,'$'
Res db 'Результат: ','$' 
           
end start