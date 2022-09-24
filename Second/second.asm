name "second"

org 100h

	mov al, 1
	mov bh, 0
	mov bl, 1001_1111b
	mov cx, msg2 - offset msg1 
	mov dl, 7
	mov dh, 11
	push cs
	pop es
	mov bp, offset msg1
	mov ah, 13h
	int 10h
	
	mov cx, msg3 - offset msg2  
	mov dl, 36
	mov dh, 13
	mov bp, offset msg2
	mov ah, 13h
	int 10h
	
	mov bl, 1110_0000b
	mov cx, msgend - offset msg3 
	mov dl, 22
	mov dh, 15
	mov bp, offset msg3
	mov ah, 13h
	int 10h
    
	jmp msgend
	
msg1    db "Hola, Seminario de Solucion de Problemas de Traductores de Lenguaje 1"
msg2    db "Seccion D05"
msg3    db "Terminada la practica 2, saludos, -Abraham"

msgend: 
        mov ah, 0
        int 16h
        
        mov ax, 152_125o
        mov bx, 0001_1101_0100_0101b ; nrc: 119893d, 00011101010001010101b, 1D455h
        
	    mov cx, 0000_0001_1011_0001b
	    mov dx, 1101_0010_1001_0000b ; codigo: 220791217d, 1101001010010000000110110001b, D2901B1h
        
        int 20h