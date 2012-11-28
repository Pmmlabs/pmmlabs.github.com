.model tiny
org 100h
.DATA
Success DB 'Все числа попадают в заданный диапазон!',13,10,'$'   
Fail DB 'В заданный диапазон попадают не все числа...',13,10,'$'
Arr     dw 310,-1,33,41,-2    ;массив 
n       dw 5                ;размер массива
a       dw -1               ;левая граница диапазона
b       dw 310               ;правая граница диапазона
.CODE  
start:  lea di,Arr       ; в di адрес Arr[1]
        mov ax,a
        mov bx,b
        mov cx,n            
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
ret

end start