;est li podryad idushie zero

cseg segment                       
assume cs:cseg, ds:cseg, ss:cseg, es:cseg                     
org 100h                                                
Start: 
  mov si,offset Array           ; zagruzaem adres (smezenie) massiva  
                        
PROVERKA:                                               
  lodsb                         ; zagruzaem v al pervii element massiva                       
  cmp al,24h                    ; sravnivaem, 24h - indicator konza massiva                        

  je NO                    ; prizok, esli konez massiva                        
  cmp al,0                      ; sravnivaem s 0 
  je NULL                       ; prizok, esli nol'                       
  jmp PROVERKA                  ; esli ne nol'                        
  
NULL:                        ; obnulenie summi pri vstreche otrizatel'nogo chisla                       
  lodsb                         ; zagruzaem v al pervii element massiva                       
  cmp al,24h                    ; sravnivaem, 24h - indicator konza massiva                        
  je NO                   ; prizok, esli konez massiva                        
  cmp al,0                      ; sravnivaem s 0 
  je YES                                          
  jmp PROVERKA  
                                         
                                            
YES:     
  mov ah,9 
  mov dx,offset String1
  int 21h 
                       ; esli summa naidena                       
  mov ah,9
  mov dx,offset String2                                 
  int 21h
  jmp EXIT  
  
NO:                   

  mov ah,9 
  mov dx,offset String1
  int 21h 
           ; esli summa ne naidena                         
  mov ah,9
  mov dx,offset String3
  int 21h   
  
EXIT:                                                   
  mov ah,10h
  int 16h                        ; zavershenie programmi posle nazatiya luboi knopki                           
  
  int 20h                        ; vihod is programmi  
  
Array db -3,0,1,9,2,0,0,2,1,0,24h
String1 db '3, 0,  1, 9, 2, 0, 0,  2, 1, 0.$'    
String2 db 10, 13, 'Zero: YES$'                 
String3 db 10, 13, 'Zero: NO$'                 
cseg ends
end Start