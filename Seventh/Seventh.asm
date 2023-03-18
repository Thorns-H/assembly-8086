name "Seventh"
    include "emu8086.inc"
    org 100h                            

start:
        xor     ax,ax               
        mov     [error],ax
        mov     [iterator],ax
        mov     al,03h  
        mov     ah,0
        int     10h
        
        mov     ch,6    
        mov     cl,7
        mov     ah,1
        int     10h
                      
        GOTOXY  20,1
        lea     si,myData_1
        call    print_string        
        GOTOXY  11,2
        lea     si,myData_2
        call    print_string

        GOTOXY  15,4                 
        lea     si,infoFirst
        call    print_string
        
        GOTOXY  20,5
        lea     si,infoSecond
        call    print_string

        GOTOXY  3,7                 
        lea     si,getFirstFileName
        call    print_string
        
        lea     si,nameReadFile
        mov     cx,30
        call    getString  
                            
        GOTOXY  3,8                 
        lea     si,getSecondFileName
        call    print_string
        
        lea     si,nameOutFile
        mov     cx,30
        call    getString
        lea     dx,nameOutFile
        xor     cx,cx
        call    makeFile          
        test    [error],0x0f
        jnz     closeRutine
        mov     ax,[handler]         
        mov     [secondFile],ax
        
        lea     dx,nameReadFile
        mov     al,0                
        call    openFile
        test    [error],0x0f
        jnz     closeRutine
        mov     ax,[handler]
        mov     [firstFile],ax          
                                    
        call    getArch
        
        mov     bx,[firstFile]          
        mov     [handler],bx
        call    closeFile
        
        mov     bx,[secondFile]
        mov     [handler],bx
        call    closeFile
closeRutine:
        xor     ax,ax               
        int     20H
                   
; ---------- Helpers ---------- ;

castAscii:
    push    ax
    push    bx
    push    dx                     
    push    di
    xor     dx,dx
    mov     bx,[base]
    lea     di,16BAscii+9          
    mov     ax,[16Value]
convertBucle:
    cmp     ax,bx
    jl      endConversion
    div     bx
    add     dl,0x30
    cmp     dl,0x3A
    jl      value
    add     dl,7
value:
    mov     [di],dl
    dec     di
    xor     dx,dx
    jmp     convertBucle
endConversion:
    add     al,0x30
    cmp     al,0x3A
    jl      valuePop
    add     al,7
valuePop:
    mov     [di],al
    pop     di                      
    pop     dx
    pop     bx
    pop     ax
    ret

getArch:
        push    ax
        push    cx
        push    dx
        push    bp

newLine:
        xor     cx,cx               
        lea     dx,line
        dec     cx
        dec     dx

newLetter:
        inc     cx                 
        inc     dx      
        mov     ax,[firstFile]
        mov     [handler],ax
        call    readLetterFromFile    
        test    [error],0x0F        
        jnz     EOF
        test    [aux],0xFF
        jz      EOF          
        xor     ax,ax
        mov     bp,dx
        mov     al,[bp]
        cmp     al,0Dh
        jne     newLetter

EOL:
        inc     cx
        inc     dx
        call    readLetterFromFile      
        test    [error],0x0F        
        jnz     EOF
        mov     bp,dx
        inc     bp
        inc     cx                  
        mov     [bp],0
        mov     [aux],cl
        call    writeLine
        mov     ax,[iterator]
        add     al,[aux]        
        mov     [iterator],ax
        jmp     newLine
        
EOF:
        mov     ax,[secondFile]
        mov     [handler],ax
        
        mov     ax,[iterator]
        mov     [16Value],ax
        call    castAscii           

        mov     ax,10               
        mov     [auxString],ax
        lea     dx,16BAscii
        mov     [Cadena],dx
        call    writeToFile
                                    
        mov     ax,3                
        mov     [auxString],ax
        lea     dx,space
        mov     [Cadena],dx
        call    writeToFile
        pop     bp
        pop     dx
        pop     cx
        pop     ax
        ret
       
writeLine:
        push    ax
        push    dx
                                        
        mov     ax,[secondFile]
        mov     [handler],ax

        mov     ax,[iterator]
        mov     [16Value],ax
        call    castAscii           

        mov     ax,10               
        mov     [auxString],ax
        lea     dx,16BAscii
        mov     [Cadena],dx
        call    writeToFile
                                        
        mov     ax,3                
        mov     [auxString],ax
        lea     dx,space
        mov     [Cadena],dx
        call    writeToFile

        xor     ax,ax               
        mov     al,[aux]
        dec     al
        mov     [auxString],ax
        lea     dx,line
        mov     [Cadena],dx
        call    writeToFile
        pop     dx
        pop     ax
        ret
                                    
getString:
        push    di
        push    si
        push    cx
        push    ax 
        mov     [aux],cl        
ifKey: 
        jcxz    clearString
        mov     ah,0
        int     16H 
        mov     [si],al
        inc     si
        dec     cx                  
        cmp     al,1bh
        jne     lastComp               
        jmp     endString
lastComp: 
        cmp     al,0DH
        je      endString
        cmp     al,08H
        je      erase
        mov     ah,0EH
        int     10H
        jmp     ifKey
erase: 
        dec     si
        dec     si
        inc     cx
        inc     cx
        mov     ah,0eH
        int     10H
        mov     al,20H
        int     10H        
        mov     al,08
        int     10H
        jmp     ifKey
clearString:   
        GOTOXY  0,3
        mov     cx,30
        mov     [auxString],cx
        lea     si,line
        mov     [Cadena],si
        call    removeString
        GOTOXY  1,0
        call    eraseLine
        GOTOXY  0,9
        lea     si,line
        mov     cx,30
        jmp     ifKey
endString: dec     si
        mov     [si],0
        mov     ah,0eH               
        mov     al,0dH
        int     10H
        mov     al,0aH
        int     10H
        sub     [aux],cl
        pop     ax
        pop     cx
        pop     si
        pop     di
        ret
        
makeFile:
        push    dx
        push    cx
        push    ax
        mov     ah,3Ch
        int     21H                 
        jc      errorMakeFile
        mov     [handler],ax
        jmp     clearRegister
errorMakeFile:mov     [error],ax
        mov     dh,1
        mov     dl,0
        call    eraseLine
        call    errorProtocol
clearRegister:    
        pop     ax
        pop     cx
        pop     dx
        ret
        
openFile:                         
        push    dx
        push    cx
        push    ax
        mov     cx,0
        mov     ah,3Dh
        int     21H
        jc      errorOpenFile               
        mov     [handler],ax
        jmp    finish

errorOpenFile:mov     [error],ax
        mov     dh,1
        mov     dl,0
        call    eraseLine
        call    errorProtocol
finish:    
        pop     ax
        pop     cx        
        pop     dx                 
        ret
                                    
closeFile:        
        push    dx                  
        push    bx                       
        push    ax
        mov     bx,[handler]         
        mov     ah,3eH      
        int     21H
        jnc     finish1
        mov     [error],ax
        mov     dh,20
        mov     dl,0                
        call    eraseLine
        call    errorProtocol
finish1:   pop     ax
        pop     bx
        pop     dx
        ret
        
readLetterFromFile:
        push    dx
        push    cx
        push    bx
        push    ax
        mov     ah,3FH
        mov     bx,[handler]
        mov     cl,1               
        int     21H                 
        jnc     readSucess              
        mov     [error],ax
        call    errorProtocol
readSucess:
        mov     [aux],al
        pop     ax                  
        pop     bx
        pop     cx
        pop     dx                  
        ret
        
writeToFile:
        push    dx
        push    cx
        push    bx
        push    ax
        xor     ax,ax
        mov     ah,40h
        mov     bx,[handler]
        xor     cx,cx
        mov     cx,[auxString]
        mov     dx,[Cadena]
        int     21H                 
        jnc     finish2
        mov     [error],ax
        GOTOXY  20,18
        CALL    eraseLine
        CALL    errorProtocol

finish2:pop     ax
        pop     bx
        pop     cx
        pop     dx
        ret                        
        
eraseLine:
        push    ax
        push    bx
        push    cx
        mov     cx,80
        mov     al,32
        mov     bh,0
        mov     ah,0aH
        int     10H
        pop     cx
        pop     bx
        pop     ax
        ret                         
        
removeString:
        push    si
        push    cx
        mov     si,[cadena]
        mov     cx,[auxString]
long_limiter:mov     [si],0
        inc     si
        loop    long_limiter
        pop     cx                 
        pop     si                 
        ret                         
        
errorProtocol:
        push    di
        push    dx
        push    cx
        push    ax
        mov     ax,[error]          
        dec     ax
        jnz     case_2
case_1:
    dec     ax
    jnz     case_2
    lea     si,error_01
    call    print_string
case_2:
    dec     ax
    jnz     case_3
    lea     si,error_02
    call    print_string
case_3:
    dec     ax
    jnz     case_4
    lea     si,error_03               
    call    print_string
case_4:
    dec     ax
    jnz     case_5
    lea     si,error_04
    call    print_string            
case_5:                                 
    dec     ax
    jnz     case_6
    lea     si,error_05
    call    print_string
case_6:
    dec     ax
    jnz     case_6
    lea     si,error_06
    call    print_string

_data:
              
nameOutFile     DB 30 DUP (0)  
base            DW 10
handler         DW 0
firstFile       DW 0
secondFile      DW 0  
nameReadFile    DB 30 DUP (0)
iterator        DW 0
16BAscii        DB 10 DUP ('0'),0
Cadena          DW 0
16Value         DW 0
aux             DB 0
auxString       DW 0
line            DB 81 DUP (0)
error           DW 0


space                   DB "   ",0
myData_1                DB "Abraham Magana Hernandez - 2022B - D05",0
myData_2                DB "Seminario de Solucion de Problemas de Traductores de Lenguaje 1", 0          
getFirstFileName        DB "Nombre del Archivo para Leer (con el .txt): ",0           
getSecondFileName       DB "Nombre del Archivo para Guardar (con el .txt): ",0   
infoFirst               DB "El Archivo debe tener una linea en blanco al final!",0
infoSecond              DB "El .txt debe estar en la carpeta MyBuilt!",0
            
error_01        DB "Funcion no valida",0
error_02        DB "Archivo no encontrado",0
error_03        DB "Ruta no valida o el archivo no existe",0
error_04        DB "handler no disponible",0
error_05        DB "Acceso Denegado",0  
error_06        DB "handler no valido",0

DEFINE_PRINT_STRING