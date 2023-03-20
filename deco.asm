
section	.text
   global _start         ;must be declared for using gcc
	
_start:                  ;tell linker entry point 
;open the file for reading
   mov eax, 5
   mov ebx, file_name
   mov ecx, 0             ;for read only access
   mov edx, 0777          ;read, write and execute by all
   int  0x80
	
   mov  [fd_in], eax

; Buscar el primer espacio en blanco en el buffer a partir de la posición deseada
    mov edi, 0          ; destino
    mov esi, 0          ; inicio
    mov r8, 0           ; contador de numeros



read_loop:
; Establecer el puntero de archivo en la posición deseada
    mov eax, esi         ; posición deseada (por ejemplo, 1 bytes desde el inicio del archivo)
    mov ebx, [fd_in]        ; descriptor de archivo
    mov ecx, eax        ; posición de desplazamiento
    mov edx, 0          ; origen de desplazamiento (0 = desde el inicio del archivo)
    mov eax, 19         ; syscall para establecer el puntero de archivo
    int 0x80            ; llama al sistema

   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 28
   int 0x80

   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80

   ; imprimir lo que leyo del archivo
   ;mov eax, 4
   ;mov ebx, 1
   ;mov ecx, info
   ;mov edx, 28
   ;int 0x80

    mov eax, 0        ; contador de bits

search_loop:

    cmp byte [info+esi+edi], 0 ; verifica si el buffer está vacío
    je end_search

    cmp byte [info+esi+edi], ' ' ; compara el byte actual con un espacio en blanco
    je space_found

    movzx ecx, byte [info+esi+edi]
    sub ecx,48
    imul eax,10
    add eax,ecx

    add edi,1               ; incrementa la posición actual en el buffer
    cmp edi, 32           ; verifica si se ha llegado al final del buffer
    je end_search
    jmp search_loop

space_found:
    cmp r8,0
    je s_num1
    jne s_num2

s_num1:

        ; Convertir el número decimal a binario
    mov ecx,0

    convert_loop1:

        mov ebx, num1   ; puntero al comienzo del buffer
        add ebx,7
        sub ebx, ecx     ; suma el valor de r9 a rcx
        mov edx, 0        ; limpiar edx
        div dword [two]   ; dividir eax por 2
        add dl,48         ;  ASCII quitar para print
        mov [ebx], dl     ; almacenar el resto en el bit correspondiente
        add ecx,1           ; incrementar el contador de bits
        cmp eax, 0        ; verificar si se ha completado la conversión
        jne convert_loop1  ; si no, volver al comienzo del
    jmp next

s_num2:
         ; Convertir el número decimal a binario
    mov ecx,0
    convert_loop2:
        mov ebx, num2   ; puntero al comienzo del buffer
        add ebx, 7
        sub ebx, ecx     ; suma el valor de r9 a rcx
        mov edx, 0        ; limpiar edx
        div dword [two]   ; dividir eax por 2
        add dl,48        ; ASCII quitar para print
        mov [ebx], dl     ; almacenar el resto en el bit correspondiente
        add ecx,1           ; incrementar el contador de bits
        cmp eax, 0        ; verificar si se ha completado la conversión
        jne convert_loop2  ; si no, volver al comienzo del
    jmp next
next:


    add esi,edi
    add esi,1        ;Le sumo uno para descartar el espacio en blanco
    mov edi, 0       ;reseteo del contador de bits para saber cuando se encuentra un espacio en blanco


    cmp r8,0
    je less

    cmp r8,1
    je more


less:
    add r8,1
    jmp read_loop

more:

    mov r8,0  ;Resetear el contador de numeros

    ; Copiar buffer1 a buffer3

    mov ecx,0
    convert_loop3:
        mov eax, num2
        mov ebx, num1   ; puntero al comienzo del buffer
        add ebx, 8      ; alinear cadena
        add ebx, ecx    ; suma el valor de la posicion en num1
        add eax, ecx    ; suma el valor de la poscion en num 2
        mov edx, [eax]  ; Obtener valor de num2
        mov [ebx], edx     ; almacenar el valor de num2 en num1
        add ecx,1           ; incrementar el contador de bits
        cmp ecx, 8        ; verificar si se ha completado la conversión
        jne convert_loop3  ; si no, volver al comienzo del

        ; Imprimir el número binario resultante
    mov eax, 4
    mov ebx, 1
    mov ecx, num1
    mov edx, 16
    int 0x80


    ;pasar de binario a decimal

    mov r10,2

    mov ebx, 0 ;Valor almacenado

    mov eax, 8 ; contador de potencia
    mov edx, num1 ;inicio de buffer num1


    ;add ecx, 15 ;final de buffer num1

    bin_to_dec:
        cmp eax,1
        je final

        xor rcx,rcx

        mov cl, byte [edx]  ;obtener MSB
        sub cl, 48
        comp:
        cmp ecx,1
        je jump

        jne_:
            add edx, 1      ;contador + 1
            idiv r10        ;dividir potencia entre 2
            jmp bin_to_dec

        jump:
            add ebx,eax     ;resultado de multiplicacion mas el valor acumulado
            jmp jne_
final:




;jmp read_loop

end_search:

   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel



section .bss
fd_in  resb 1
info resb 28


section	.data
file_name db 'test.txt',0
two dd 2    ; valor constante para utilizar en la división por 2
binary: times 16 db 0
;num1 db 0000000000000000b, 0
;num2 db 00000000b, 0

num1 db '0000000000000000', 0
num2 db '00000000', 0





