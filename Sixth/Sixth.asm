name    "Sixth"
org     0100h

; ---------- Rutina Principal ---------- ;

_start: 
            
    mov ax, 1003h  
    mov bx, 0        
    int 10h

    mov dx, 0705h     
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg1_size  
    mov al, 01b       
    mov bp, msg1
    mov ah, 13h       
    int 10h  
    
    mov dx, 0905h             
    mov cx, msg2_size        
    mov bp, msg2
    mov ah, 13h       
    int 10h           
            
    mov dx, 0B05h              
    mov cx, msg3_size       
    mov bp, msg3
    mov ah, 13h       
    int 10h           

    mov dx, 0C05h             
    mov cx, msg4_size        
    mov bp, msg4
    mov ah, 13h       
    int 10h     
               
    mov ax, 1003h
    mov bx, 0
    int 10h

    lea si, string
    mov cx, 30

    call read_values

    mov  bl, 0  
    mov  digit, bl

    call get_chars 
    call operation
     
finish:

    mov si, 0 
    mov ax, 0
    mov helper, al
    mov bx, rx

    call convert 
    mov cl, helper
    mov aux, cl

    call reverse  
    mov si, 0 

    mov dx, 0D05h     
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg5_size  
    mov al, 01b       
    mov bp, msg5
    mov ah, 13h       
    int 10h

    call print_out
              
    int 20h 

; ---------- String / Evaluacion de Valores ---------- ;

read_values:

    dec     cx
    jz      aux_return
    mov     ah,0
    int     16h
    mov     [si],al
    inc     si

    cmp     al,0dh
    je      evaluate_values

    mov     ah,0eH
    int     10h

    cmp     aux, 0 
    je      read
    cmp     al, 42
    je      evaluate_values 
    cmp     al, 43
    je      evaluate_values
    cmp     al, 45
    je      evaluate_values 
    cmp     al,47
    je      evaluate_values

read:

    add     aux,1 
    jmp     read_values 
                       
evaluate_values:

    cmp digit, 0
    je  first_value_case
    cmp digit, 1
    je  second_value_case
    cmp digit, 2
    je  third_value_case
    cmp digit, 3
    je  fourth_value_case

    jmp read_values      
    
    first_value_case: 
        mov bl, aux
        mov first_value, bl
        add digit, 1 
        add aux, 1

        jmp read_values
    
    second_value_case: 
        mov bl, aux 
        sub bl, first_value
        mov second_value, bl 
        add digit, 1
        add aux, 1

        jmp read_values 
    
    third_value_case: 
        mov bl, aux
        sub bl, first_value
        sub bl, second_value
        mov third_value, bl
        add digit, 1 
        add aux, 1

        jmp read_values   
    
    fourth_value_case: 
        mov bl, aux 
        sub bl, first_value
        sub bl, second_value
        sub bl, third_value
        mov fourth_value, bl
        add aux, 1

        jmp aux_return
                                  
get_chars:

    cmp digit,0
    je  first_string  
    cmp digit,1
    je  second_string
    cmp digit,2
    je  third_string
    cmp digit,3
    je  fourth_string
    
first_string:

    cmp first_value,5
    mov bl,string[0]
    mov helper,bl
    mov dx,1
    mov si,dx
    je  fourth_decimal

    mov dx,1
    mov si,dx    
    cmp first_value,4
    je  third_decimal

    mov dx,1
    mov si,dx
    cmp first_value,3
    je  second_decimal

    mov dx,1
    mov si,dx
    cmp first_value,2
    je  first_decimal
        
second_string:

    add si,1
    mov bl,string[si]
    mov helper,bl
    add si,1

    cmp second_value,5
    je  fourth_decimal    
    cmp second_value,4
    je  third_decimal 
    cmp second_value,3
    je  second_decimal 
    cmp second_value,2
    je  first_decimal 

third_string:

    add si,1
    mov bl,string[si]
    mov helper,bl
    add si,1
    cmp third_value,5
    je  fourth_decimal    
    cmp third_value,4
    je  third_decimal 
    cmp third_value,3
    je  second_decimal 
    cmp third_value,2
    je  first_decimal   
        
fourth_string:

    add si,1  
    mov bl,string[si]
    mov helper,bl
    add si,1
    cmp fourth_value,5
    je  fourth_decimal    
    cmp fourth_value,4
    je  third_decimal 
    cmp fourth_value,3
    je  second_decimal 
    cmp fourth_value,2
    je  first_decimal

; ---------- Signos ----------- ;

only_negatives:

    cmp  first_value,43
    je   positive_number
    cmp  first_value,45
    je   negative_number
        
positive_number:

    cmp second_value,43
    je  push_first
    cmp second_value,45
    je  remove_first 
        
negative_number: 

    add flag,1
    cmp second_value,43
    je  remove_first
    cmp second_value,45
    je  push_first  

remove_first:

    mov ax,first_number
    mov rx,ax
    mov ax,second_number
    sub rx,ax
    cmp flag,0
    jne end_first_remove
    cmp third_value,43
    je  push_second
    cmp third_value,45
    je  remove_second

    end_first_remove:   
        cmp third_value,43
        je  remove_second
        cmp third_value,45
        je  push_second
       
remove_second:

    mov ax,third_number
    sub rx,ax
    cmp flag,0
    jne end_second_remove
    cmp fourth_value, 43
    je  push_last
    cmp fourth_value, 45
    je  remove_last

    end_second_remove:
        cmp fourth_value,43
        je  remove_last
        cmp fourth_value,45
        je  push_last

remove_last:
    mov ax,fourth_number
    sub rx,ax
    ret

push_first:

    mov ax,first_number
    mov rx,ax
    mov ax,second_number
    add rx,ax
    cmp flag,0
    jne end_push_first
    cmp third_value,43
    je  push_second
    cmp third_value,45
    je  remove_second

    end_push_first:
        cmp third_value,43
        je  remove_second
        cmp third_value,45
        je  push_second

push_second: 

    mov ax,third_number
    add rx,ax
    cmp flag,0
    jne end_push_second
    cmp fourth_value,43
    je  push_last
    cmp fourth_value,45
    je  remove_last

    end_push_second:  
        cmp fourth_value,43
        je  remove_last
        cmp fourth_value,45
        je  push_last

push_last: 

    mov ax,fourth_number
    add rx,ax
    ret

; ---------- Helpers ---------- ; 

aux_return:
    ret

print_out:  
              
    mov bh, 0
    mov dh, 13
    add row, 1
    mov dl, row
    mov ah, 02h
    int 10h

    sub aux, 1
    mov bh, 0	  
    mov al, print_result[si]  
    add si, 1
    add al, 48	
    mov cx, 1 
    mov ah, 0Ah       
    int 10h

    cmp aux,0
    je  aux_return 
    jmp print_out
                   
reverse:

    sub helper, 1
    mov ax, 0
    mov al, helper
    mov si, ax
    mov al, string_out[si]
    mov bl, flag
    mov bh, 0
    mov si, bx 
    add flag, 1
    mov print_result[si], al
    cmp helper, 0

    je  aux_return
    jmp reverse     

convert: 

    mov ax, bx
    mov bl, 10  
    div bl  
    mov string_out[si], ah 
    add si, 1
    add helper, 1 
    mov bl, al
    mov bh, 0
    cmp al, 0 
    je aux_return 
    jmp convert
        
fourth_decimal: 

    mov ax,0
    mov bx,1000
    mov al,string[si]
    sub al,48
    mul bx 
    
    cmp digit,0
    je  last_case_first  
    cmp digit,1
    je  last_case_second 
    cmp digit,2
    je  last_case_third
    cmp digit,3
    je  last_case_fourth
        
    last_case_first: 
        mov first_number, ax
        add si, 1
        jmp third_decimal 

    last_case_second:
        mov second_number, ax
        add si, 1
        jmp third_decimal
    
    last_case_third:
        mov third_number,ax
        add si,1 
        jmp third_decimal

    last_case_fourth:
        mov fourth_number,ax
        add si,1
            
third_decimal:

    mov ax, 0
    mov bx, 100
    mov al, string[si]
    sub al, 48
    mul bx

    cmp digit, 0
    je  third_case_first  
    cmp digit, 1
    je  third_case_second
    cmp digit, 2
    je  third_case_third 
    cmp digit, 3
    je  third_case_last
         
    third_case_first:
        add first_number,ax
        add si,1
        jmp second_decimal
    third_case_second: 
        add second_number,ax
        add si,1 
        jmp second_decimal 
    third_case_third: 
        add third_number,ax
        add si,1 
        jmp second_decimal
    third_case_last: 
        add fourth_number,ax
        add si,1
        
second_decimal:

    mov ax, 0
    mov bx, 10
    mov al, string[si]
    sub al, 48
    mul bx 
    
    cmp digit, 0
    je  second_case_first  
    cmp digit, 1
    je  second_case_second 
    cmp digit, 2
    je  second_case_third
    cmp digit, 3
    je  second_case_last
        
    second_case_first:
        add first_number,ax
        add si,1 
        jmp first_decimal
    second_case_second: 
        add second_number,ax
        add si,1 
        jmp first_decimal
    second_case_third: 
        add third_number,ax
        add si,1 
        jmp first_decimal
    second_case_last: 
        add fourth_number,ax
        add si,1 
        
first_decimal:
    mov ax,0
    mov al,string[si]
    sub al,48 
    
    cmp digit,0
    je  first_case_first  
    cmp digit,1
    je  first_case_second
    cmp digit,2
    je  first_case_third
    cmp digit,3
    je  first_case_last
         
    first_case_first:
        add first_number, ax
        mov bl, helper
        mov first_value, bl
        jmp end_cases  
    
    first_case_second:
        add second_number, ax 
        mov bl, helper
        mov second_value, bl
        jmp end_cases
    
    first_case_third:
        add third_number, ax 
        mov bl, helper
        mov third_value, bl
        jmp end_cases        
    
    first_case_last:
        add fourth_number, ax   
        mov bl, helper
        mov fourth_value, bl
        ret
        
    end_cases: 
        add digit,1 
        jmp get_chars

; ---------- Comparando los primeros casos con Jerarquia ---------- ;    

operation:
        
    cmp second_value,42
    je  first_mult
    cmp second_value,47
    je  first_div

    cmp third_value,42
    je  second_mult
    cmp third_value,47
    je  second_div

    cmp fourth_value,42
    je  third_mult
    cmp fourth_value,47
    je  third_div

    jmp only_adds

first_mult:

    mov ax,first_number
    mov bx,second_number
    mul bx     
    mov rx,ax
    cmp third_value,42
    je  cmp_first_mult 
    cmp third_value,47
    je  cmp_first_div 
    ret

second_mult:

    mov ax,second_number
    mov bx,third_number
    mul bx     
    mov rx,ax 
    cmp fourth_value,42
    je  cmp_second_mult
    cmp fourth_value,47
    je  cmp_second_div
    cmp fourth_value,43
    je  cmp_second_add
    cmp fourth_value,45
    je  cmp_second_sub
    ret

third_mult:

    mov ax,third_number
    mov bx,fourth_number
    mul bx     
    mov rx,ax
    cmp first_value,43
    je  third_helper_add
    cmp first_value,45
    je  third_helper_sub  
    ret

first_div:

   mov ax,first_number
   mov bx,second_number
   div bx
   mov rx,ax
   cmp third_value,42
   je  cmp_first_mult 
   cmp third_value,47
   je  cmp_first_div 
   ret

second_div:

    mov ax,second_number
    mov bx,third_number
    div bx
    mov rx,ax 
    cmp fourth_value,42
    je  cmp_second_mult
    cmp fourth_value,47
    je  cmp_second_div
    cmp fourth_value,43
    je  cmp_second_add
    cmp fourth_value,45
    je  cmp_second_sub
    ret 

third_div:

   mov ax,third_number
   mov bx,fourth_number
   div bx
   mov rx,ax
   cmp first_value,43
   je  third_helper_add
   cmp first_value,45
   je  third_helper_sub
   ret        

; ---------- Resto de Operaciones ---------- ;

cmp_first_mult: ; Comparación de Multiplicaciones
    
    mov ax,rx
    mov bx,third_number
    mul bx
    mov rx,ax
    cmp fourth_value,42
    je  cmp_finish_mult
    cmp fourth_value,47
    je  cmp_finish_div   
    cmp fourth_value,43
    je  cmp_first_add
    cmp fourth_value,45
    je  cmp_first_sub
    ret

cmp_finish_mult: ; Fin de Comparación y retorno a rutina principal 
    
    mov ax,rx
    mov bx,fourth_number
    mul bx
    mov rx,ax 
    jmp finish 

cmp_first_div: ; Comparación de Divisiones

    mov ax,rx
    mov bx,third_number
    div bx
    mov rx,ax  
    cmp fourth_value,42
    je  cmp_finish_mult
    cmp fourth_value,47
    je  cmp_finish_div 
    cmp fourth_value,43
    je  cmp_first_add
    cmp fourth_value,45
    je  cmp_first_sub   
    ret 

cmp_finish_div: ; Fin de Comparación y retorno a rutina principal 

    mov ax,rx
    mov bx,fourth_number
    div bx
    mov rx,ax
    jmp finish 

; ---------- Sumas / Restas al Resultado Final ---------- ;

cmp_first_add:

    mov ax,fourth_number
    add rx,ax
    ret
    
cmp_second_add:

    mov ax,fourth_number
    add rx,ax
    cmp first_value,43
    je  cmp_finish_add
    cmp first_value,45
    je  cmp_finish_sub

cmp_finish_add: 

    mov ax,first_number
    add rx,ax
    ret

cmp_first_sub:

    mov ax,fourth_number
    sub rx,ax
    ret
                  
cmp_second_sub: 

    mov ax,fourth_number
    sub rx,ax
    cmp first_value,43
    je  cmp_finish_add
    cmp first_value,45
    je  cmp_finish_sub

cmp_finish_sub:

    mov ax,first_number
    sub rx,ax
    ret
     
cmp_second_mult:

    mov ax,rx 
    mov bx,fourth_number
    mul bx
    mov rx,ax 
    cmp first_value,43
    je  cmp_finish_add
    cmp first_value,45
    je  cmp_finish_sub  
    ret
   
cmp_second_div: 

    mov ax,rx 
    mov bx,fourth_number
    div bx
    mov rx,ax
    cmp first_value,43
    je  cmp_finish_add
    cmp first_value,45
    je  cmp_finish_sub  
    ret

; ---------- Helpers ---------- ;

third_helper_add:

   mov ax,first_number
   add rx,ax

   cmp second_value,43
   je  last_add
   cmp second_value,45
   je  last_sub  
     
third_helper_sub:

   mov ax,first_number
   sub rx,ax

   cmp second_value,43
   je  last_add
   cmp second_value,45
   je  last_sub 
   
last_add:

    mov ax,second_number
    add rx,ax
    ret

last_sub:

    mov ax,second_number
    sub rx,ax
    ret
  
; --------- Apartado de Signos (S/R) ---------- ;:

only_adds:

    cmp first_value,43         
    jne  only_subs 
    cmp second_value,43         
    jne  only_subs 
    cmp third_value,43         
    jne  only_subs 
    cmp fourth_value,43         
    jne  only_subs 

    mov ax,first_number
    mov rx,ax
    mov ax,second_number
    add rx,ax
    mov ax,third_number
    add rx,ax
    mov ax,fourth_number

    add rx,ax

    ret 

only_subs:

    cmp  first_value,45         
    jne  only_negatives 
    cmp  second_value,45         
    jne  only_negatives 
    cmp  third_value,45         
    jne  only_negatives 
    cmp  fourth_value,45         
    jne  only_negatives 

    mov ax,first_number
    mov rx,ax
    mov ax,second_number
    add rx,ax
    mov ax,third_number
    add rx,ax
    mov ax,fourth_number

    add rx,ax

    mov bl,1
    mov flag,bl

    ret     

; ---------- Variables ---------- ;

string          db      30  dup (0)
row             db      25
string_out      db      5   dup(0)
print_result    db      5   dup(0)    

first_number    dw      0 
second_number   dw      0
third_number    dw      0
fourth_number   dw      0

first_value     db      0
second_value    db      0 
third_value     db      0
fourth_value    db      0

digit           db      0
helper          db      0
flag            db      0 
aux             db      0 

rx              dw      0 

; ---------- Data de los Prints ---------- ;

msg1:       db "Seccion D05 - Abraham Magana Hernandez - 2022B."
msg2:       db "Analisis Lexico * / + -."
msg3:       db "Recuerda introducir el primer signo al inicio."
msg4:       db "La Ecuacion es:  " 
msg5:       db "El Resultado es:  "  

msg_tail:

    msg1_size = msg2 - msg1
    msg2_size = msg3 - msg2
    msg3_size = msg4 - msg3
    msg4_size = msg5 - msg4
    msg5_size = msg_tail - msg5