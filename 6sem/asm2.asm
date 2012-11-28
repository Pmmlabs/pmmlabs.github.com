.MODEL tiny
   .CODE
   org 100h
_start:
; ввод размерности массива в регистр AX
    mov ah,9
    lea dx,Input_size
    int 21h 
    call ReadInteger
    mov N,ax
; перевод строки
    mov ah,9
    lea dx,crlf
    int 21h
; ввод левой границы отрезка    
    mov ah,9
    lea dx,Input_A
    int 21h 
    call ReadInteger
    mov A,ax
; перевод строки
    mov ah,9
    lea dx,crlf
    int 21h
; ввод правой границы отрезка    
    mov ah,9
    lea dx,Input_B
    int 21h 
    call ReadInteger
    mov B,ax
; перевод строки
    mov ah,9
    lea dx,crlf
    int 21h

    mov cx, N	; сохраняем размер массива в сх
    mov ah,9
    lea dx,Input_numbers
    int 21h
; ввод элементов массива регистр AX  
input:
    call ReadInteger
    mov si, cx  
    add si, si
    mov [Mas+si],ax    

; перевод строки
    mov ah,9
    lea dx,crlf
    int 21h

loop input

; вывод массива
    mov ah,9
    lea dx,Res_mas
    int 21h

    mov cx, N	; сохраняем размер массива в сх
; вывод элементов массива
output:
    mov si, cx
    add si, si  
    mov ax,[Mas+si]    
    call WriteInteger
   
; перевод строки
    mov ah,9
    lea dx,crlf
    int 21h
loop output

; вывод результата
    mov ah,9
    lea dx,Res
    int 21h
    PUSH A
    PUSH B
    PUSH N
    lea di,Mas+2 
    push di  
    mov bp,sp
    CALL MAIN_PROGRAM ; вызов процедуры
ret
; главная программа
MAIN_PROGRAM PROC

     ;  lea di,Mas+2       ; в di адрес Arr[1]  
       ; add bp,2
        mov di,bp+2
        mov cx,bp+4
        mov bx,bp+6
        mov ax,bp+8
                    
check:  
        cmp [di],ax      
        jl No            ; if arr[i]<a
        cmp [di],bx      
        jg No            ; if arr[i]>b
        dec cx           ; в cx теперь количество непроверенных элементов
        add di,2         ; в di теперь адрес следующего элемента Arr
        cmp cx,0         
        jg check         ; if n>0 
        mov  dx,OFFSET Success ; если дошли до этого места - значит ОК 
        jmp print               
No:     mov  dx,OFFSET Fail         
print:  mov  ah,9             ; напечатать то, адрес чего в dx
        int  21h              
        mov  ah,4ch                 
        int  21h

	RET
MAIN_PROGRAM ENDP ; конец процедуры

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

A dw ?
B dw ?
N dw ?
Mas dw 256 dup (?)                      ; массив
fl dw ?
Success db 'Все числа попадают в заданный диапазон!' 
db 0Dh,0Ah,'$' 
Fail db 'В заданный диапазон попадают не все числа...' 
db 0Dh,0Ah,'$' 
Input_A db 'Введите левую границу:' 
db 0Dh,0Ah,'$' 
Input_B db 'Введите правую границу:' 
db 0Dh,0Ah,'$' 
Input_size db 'Введите размер массива:' 
db 0Dh,0Ah,'$' 
Input_numbers db 'Введите элементы массива (через Enter) :' 
db 0Dh,0Ah,'$'
Res_mas db 'Массив:', 0dh,0ah,'$'
crlf db 0dh,0ah,'$'
Res db 'Результат:' 
db 0Dh,0Ah,'$'
end _start