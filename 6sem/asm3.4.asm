;ƒано предложение. ”двоитъ последнюю букву каждого слова.

.MODEL	 SMALL

.STACK 	100h

.DATA
STR_IN  DB 0ah,0dh,'Hello world and goodbay','$'   ;исходна€ строка
STR_OUT DB 100 DUP(?)   ; строка-результат
SPACE   DB ' '  ;пробел
LAST    DB '$'    ;конец строки
   
.CODE       

START:
;установка в DS адреса сегмента пам€ти
    MOV	AX,@DATA
    MOV	DS,AX
;дл€ копировани€ строки STR_OLD в сегменте данных в строку STR_OUT в сегменте данных  
    PUSH DS
    POP	ES  
    CLD ;дл€ обработки слева направо
    LEA si,str_in ;загружаем адрес строки-источника
    LEA di,es:str_out ;загружаем адрес строки-приЄмника          	
    LODSB ;копируем строки-источника в регистр al
        
READ:  
    STOSB ;копируем из al в строку-приЄмник 
    MOV bl,al ;запоминаем последний символ
    LODSB ;копируем из строки-источника в al     
    CMP al,last ;конец строки?
    JE DONE ;да
    CMP al,space ;пробел?
    JNE READ ;нет
    MOV al,bl ;да пробел 
    STOSB ;удваиваем последнюю букву 
    MOV al,space ;копируем в al пробел
    JMP READ  

DONE:
    MOV	al,bl
    STOSB
    MOV al,last
    STOSB ;добавл€ем признак конца строки

PRINT:       
    MOV DX,OFFSET STR_IN	
    MOV AH, 09H ;печать строки-источника 
    INT 21H                
    MOV DX,OFFSET STR_OUT	
    MOV AH, 09H ;печать строки-результата
    INT 21H
    MOV AH, 4CH ;завершение программы
    INT 21H		

end START




