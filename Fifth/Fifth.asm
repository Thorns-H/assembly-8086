name "Fifth"
include 'emu8086.inc'

org 100h 
jmp _set_string
                 
_variables:
        
    input       db      ?,?,?,?
    n16         db      ?,?
    b           dw      16  
    tmp         dw      ?    
    decimal     db      ?,?,?,?,?

_set_string:

    xor     ax,ax
      
    lea     di,input ; Variable donde almacenamos el string
    lea     si,n16
    mov     dx,5 ; Buffer del String
    
    gotoxy  18,4
    print   "Abraham Magana Hernandez - 2022B - D05"
    gotoxy  17,5
    print   "Seminario de Traductores de Lenguajes I"
    gotoxy  15,7 
    print   "Ingresa el numero en hex, de 16 bits: " 
      
    call    get_string ; Llamos a la funcion para leer el string del usuario
            
_start: 

    call    first_dec
    
    xor cx,cx  
    mov ax,b 
    mov ch,0
    mov cx,2

    call    hex_to_dec
    
    mov al,0
    mov decimal[5],al    
    mov ax,0
    mov bx,0  
    mov ax,tmp
    mov bx,10000 
    mov dx,0
    div bx
    mov decimal[0],al
   
    mov bx,0
    mov ax,0
    mov bl,10
    mov al,decimal[0]
    mov b,bx
    mul b
    mov b,ax
    
    mov bx,1000
    mov ax,b
    mov b,bx
    mul b
    mov b,ax
    mov ax,tmp
    sub ax,b
    mov tmp,ax
    
    mov ax,tmp 
    mov bx,1000
    div bx
    mov decimal[1],al
    
    mov ax,0
    mov al,decimal[1]
    mov bx,1000
    mov b,bx
    mul b
    mov b,ax
    mov ax,tmp
    sub ax,b
    mov tmp,ax  
    
    mov bx,100
    mov ax,tmp
    div bx
    mov decimal[2],al
    
    mov ax,0   
    mov bx,0
    mov al,decimal[2]
    mov bx,100
    mov b,bx
    mul b
    mov b,ax 
    mov ax,tmp
    sub ax,b
    mov tmp,ax
    
    mov ax,0
    mov bx,10
    mov ax,tmp
    div bx 
    mov decimal[3],al  
    
    mov ax,0
    mov al,decimal[3]
    mov bx,10
    mov b,bx
    mul b
    mov b,ax
    mov ax,tmp
    sub ax,b
    mov tmp,ax
    mov ax,tmp
    mov decimal[4],al
              
    mov ax, 0 ; Limpiamos el registro
    mov ah, 30h ; Asignamos el valor 0 en ascii a un registro de 8 bits
    
    ; Como el numero esta entre el codigo ascii de 48 - 57, sumamos eso al valor
    
    add decimal[0], ah
    add decimal[1], ah
    add decimal[2], ah
    add decimal[3], ah 
    add decimal[4], ah
         
    ; Mostramos este arreglo en pantalla
    
    gotoxy 21,9
    print "El numero convertido es: " 
      
    lea    di, decimal ; Movemos los punteros para obtener el string guardado. 
    lea    si, decimal
       
    call   print_string ; Se encarga de imprimir el string.        
       
    int 20h 

; ---------- Conseguir los decimales, comparando primero entre rangos
        
first_dec:  

    sub     input[0], 30h 
    cmp     input[0], 9h
    jle     second_dec
    sub     input[0], 7h
    cmp     input[0], 15
    jle     second_dec
    sub     input[0], 20h
    
second_dec:   

    sub     input[1],30h  
    cmp     input[1],9h
    jle     third_dec
    sub     input[1],7h
    cmp     input[1],15
    jle     third_dec
    sub     input[1],20h  
        
third_dec: 

    sub     input[2],30h  
    cmp     input[2],9h
    jle     fourth_dec
    sub     input[2],7h
    cmp     input[2],15
    jle     fourth_dec
    sub     input[2],20h
             
fourth_dec: 
    
    sub     input[3],30h  
    cmp     input[3],9h
    jle     exit_convertion
    sub     input[3],7h
    cmp     input[3],15
    jle     exit_convertion
    sub     input[3],20h
    
exit_convertion:
    ret           

; ---------- Convertir el hexadecimal a decimal
                                           
_initial_h1: ; Apartado solamente del primer dato                
                          
    mul b
    loop _initial_h1 
    mov b,ax
    mov bl,input[0]
    mov tmp,bx
    mul tmp 
    mov tmp,ax 
    ret
    
_rest_hv: ; Apartado del resto
                                             
    mov ax,16
    mov b,ax
    mul b 
    mov bl,input[1]
    mov b,bx 
    mul b
    mov b,ax 
    add tmp,ax
               
    mov ax,16
    mov bl,input[2]
    mov b,bx
    mul b
    add tmp,ax
               
    mov al,input[3]
    add tmp,ax
    ret

hex_to_dec: 
          
    call _initial_h1    
    call _rest_hv
    
    lea     di,decimal ; Preparamos la salida de datos por print
    lea     si,n16
    mov     dx,6 ; Buffer
                        
    ret 
                                                                   
DEFINE_GET_STRING    
DEFINE_PRINT_STRING
END  