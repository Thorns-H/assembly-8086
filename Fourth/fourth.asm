name "fourth" 
   
org  100h

.code

    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0
    
    mov ax, 1003h          
    int 10h

    mov dx, 0705h              
    mov bl, 10011111b
    mov cx, msg1_size 
    mov al, 01b    
    mov bp, msg1
    mov ah, 13h    
    int 10h
    
    mov dx, 0905h
    mov cx, msg2_size
    mov bp, msg2
    int 10h
    
    mov dx, 0A05h 
    mov cx, msg3_size
    mov bp, msg3
    int 10h
    
    mov dx, 0B05h
    mov cx, msg4_size
    mov bp, msg4
    int 10h
    
    mov dx, 0C05h
    mov cx, msg5_size
    mov bp, msg5
    int 10h
    
    cmp Exp, 1
    jg operation
    jl other
    
    int 20h

operation:

    mov cx, [Exp]
    dec cx
    mov ax, [Base]
    mov [rl], ax
    
    call mult
    ret
    
data:
    
    Base dw 0; Base a Multiplicar
    Exp dw 0; Exponente a Elevar la Base
    aux dw 0

    rx dd 0
    rh dw 0
    rl dw 0
     
    msg1:   db "Seccion D05 - Abraham Magana Hernandez"
    msg2:   db "Introduce tus Datos en:"
    msg3:   db "Base -  Variable de Entrada de 16 bits"
    msg4:   db "Exp - Variable de Entrada de 16 bits" 
    msg5:   db "RX - Variable de Salida (32 bits)"
    
msg_tail:

    msg1_size = msg2 - msg1
    msg2_size = msg3 - msg2
    msg3_size = msg4 - msg3
    msg4_size = msg5 - msg4
    msg5_size = msg_tail - msg5

mult:

    mov ax, [rl]
    mul [Base]
    mov [rl], ax
    mov [aux], dx

    mov ax, [rh]
    mul [Base]
    mov [rh], ax

    mov ax, [aux]
    add [rh], ax

    loop mult
    call finish
    
    ret
    
finish:

    mov ax, [rh]
    mov [rx + 2], ax
    mov ax, [rl]
    mov [rx], ax

    ret 
    
other:
    mov rx, 1
    
    int 20h