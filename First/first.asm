name "first"

org 100h

mov al, 1
mov bh, 0
mov bl, 1001_1111b
mov cx, msg2 - offset msg1 
mov dl, 7o
mov dh, 13o
mov bp, offset msg1
mov ah, 13h
int 10h

mov cx, msgend - offset msg2  
mov dl, 36
mov dh, 13
mov bp, offset msg2
mov ah, 13h

int 10h
jmp msgend
	
msg1    db "Hola, Seminario de Solucion de Problemas de Traductores de Lenguajes 1"
msg2    db "Seccion D05"

msgend:
    mov ah, 0
    int 16h
    int 20h