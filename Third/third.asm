    name "third" 
    
    org  100h 

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
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg2_size  
    mov al, 01b       
    mov bp, msg2
    mov ah, 13h       
    int 10h           
         
    mov dx, 0A05h     
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg3_size  
    mov al, 01b       
    mov bp, msg3
    mov ah, 13h       
    int 10h           

    mov dx, 0B05h     
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg4_size  
    mov al, 01b       
    mov bp, msg4
    mov ah, 13h       
    int 10h
    
    mov dx, 0C05h     
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg5_size  
    mov al, 01b       
    mov bp, msg5
    mov ah, 13h       
    int 10h
    
    mov dx, 0D05h     
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg6_size  
    mov al, 01b       
    mov bp, msg6
    mov ah, 13h       
    int 10h
    
    mov dx, 0E05h     
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg7_size  
    mov al, 01b       
    mov bp, msg7
    mov ah, 13h       
    int 10h
    
    mov dx, 1005h
    mov bx, 0         
    mov bl, 10011111b 
    mov cx, msg8_size  
    mov al, 01b       
    mov bp, msg8
    mov ah, 13h       
    int 10h
    
    mov ah, 0          
    int 16h
    
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0
    
    mov dl, [0x410]
    add dl, [0x411]
    adc dh, 0
    
    add dl, [0x412]
    adc dh, 0
    
    add dl, [0x413]
    adc dh, 0
    
    add dl, [0x414]
    adc dh, 0
          
    int 20h
      
    
msg1:         db "Seccion D05 - Abraham Magaña Hernandez"
msg2:         db "Insertar datos en las direcciones:"
msg3:         db "Dato 1 de 8 bits en direcciones 0x0410"
msg4:         db "Dato 2 de 8 bits en direcciones 0x0411"
msg5:         db "Dato 3 de 8 bits en direcciones 0x0412"
msg6:         db "Dato 4 de 8 bits en direcciones 0x0413"
msg7:         db "Dato 5 de 8 bits en direcciones 0x0414"
msg8:         db "Resultado en: DX"

msg_tail:
    msg1_size = msg2 - msg1
    msg2_size = msg3 - msg2
    msg3_size = msg4 - msg3
    msg4_size = msg5 - msg4
    msg5_size = msg6 - msg5
    msg6_size = msg7 - msg6
    msg7_size = msg8 - msg7
    msg8_size = msg_tail - msg8                 