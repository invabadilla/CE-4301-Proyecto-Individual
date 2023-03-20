
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

;        ; Imprimir el número binario resultante
;    mov eax, 4
;    mov ebx, 1
;    mov ecx, num1
;    mov edx, 16
;    int 0x80


    ;pasar de binario a decimal

    mov ebx, 0 ;Valor almacenado

    mov eax, 1	 ; contador de potencia
    mov r9, 15    ;offset del buffer num1

    bin_to_dec:
        cmp eax,65536   ;Compara si la potencia es 2^16
        je final

        xor rcx,rcx     ;Limpia el registro cx

        mov cl, byte [num1+r9]  ;obtener bit LSB
        sub cl, 48              ;Se resta el formato ascii
        comp:
        cmp ecx,1               ;Si el valor es 1 se suma al resultado
        je jump
        jmp jne_

    jne_:
        mov ecx,2
        mul ecx               ;Se multiplica el registro eax por 2
        sub r9,1               ;offset -1
        jmp bin_to_dec

    jump:
        add ebx,eax     ;resultado de potencia mas el valor acumulado
        jmp jne_

final:
    ;Potencia del valor obtenido

     ; Carga los valores en los registros
    mov eax, ebx ; Base (3)
    mov ebx, [d] ; Exponente (7)
    mov ecx, [n] ; Módulo (5)

;     mov eax, 2 ; Base (3)
;     mov ebx, 5 ; Exponente (7)
;     mov ecx, 13 ; Módulo (5)

    ; Inicializa el resultado en 1
    mov edx, 1

loopa:
    mov r9,0
;    div ecx   ; eax = eax % ecx
;    xor ecx,ecx
;    mov cl, ah

    ;validar si eax es 0

loop_start:
    ; Si el exponente es cero, termina el bucle
    cmp ebx, 0
    je loop_end

    ; Si el exponente es impar, multiplica el resultado por la base
    test ebx, 1
    jnz multiply

    ; Si el exponente es par, eleva la base al cuadrado
    multiply_by_self:
        mov ebp, edx
        shr ebx, 1 ; divide el exponente por dos (desplazamiento a la derecha)
        mul eax      ;Base elevada a la 2

        xor edx,edx
        div ecx
        mov eax,edx
        mov edx, ebp
        ;and eax, ecx ; reduce el resultado módulo el número dado

        jmp loop_start

    multiply:
       ; res =  res * x
        mov ebp, eax   ;Copia de base
        mul edx       ;mul de base por resultado  edx
        xor edx,edx
        div ecx        ;residuo en edx
        ;mov edx, eax  ;copia del nuevo valor del resultado  edx

        ;and edx, ecx  ;reduce el resultado modulo el numero dado

        mov eax, ebp  ;Copia del valor de la base
        jmp multiply_by_self

loop_end:

    mov [decimal], edx   ;Guardar el numero decodificado en un buffer

;    ; Abrir el archivo
;    mov eax, 5        ; Llamada al sistema "open"
;    mov ebx, file  ; Nombre del archivo a abrir
;    mov ecx, 1        ; Modo de apertura (solo escritura)
;    mov edx, 0666     ; Permisos del archivo
;    int 0x80          ; Realizar la llamada al sistema
;
;    ; Almacenar el descriptor de archivo en el registro ebx
;    mov ebx, eax

    ; Convertir el número en una cadena de caracteres
    mov eax, [decimal] ; Cargar el número en el registro eax
    mov ecx, 10       ; Divisor para la conversión
    xor edx, edx      ; Limpiar el registro edx para la división
    mov edi, decodi   ; Puntero al búfer de caracteres
    cmp eax, 0        ; Comprobar si el número es cero
    jne .convertir    ; Si no es cero, saltar a la conversión
    mov byte [edi], '0' ; Si es cero, escribir el carácter '0'
    add edi,1           ; Avanzar el puntero al siguiente carácter
    jmp .escribir     ; Saltar a la escritura del archivo

.convertir:
    ; Convertir cada dígito en su representación ASCII
    xor edx,edx
    div ecx           ; Dividir entre 10 para obtener el resto
    add edx, '0'      ; Convertir el resto en su representación ASCII
    mov byte [edi], dl ; Escribir el carácter en el búfer
    add edi,1           ; Avanzar el puntero al siguiente carácter
    cmp eax, 0        ; Comprobar si se ha llegado al final del número
    jne .convertir    ; Si no, continuar la conversión

.escribir:
    ;agregar espacio al final del numero
    xor edx,edx
    add edx, ' '
    mov byte[edi], dl

    ;largo del string a escribir
    sub edi,decodi
    inc edi



;    ; Escribir la cadena de caracteres en el archivo
;    mov eax, 4        ; Llamada al sistema "write"
;    mov ecx, ebx      ; Descriptor de archivo
;    mov edx, edi      ; Dirección del búfer
;    sub edx, decodi   ; Longitud de la cadena
;    int 0x80          ; Realizar la llamada al sistema

;    ; Escribir el espacio en blanco en el archivo
;    mov eax, 4        ; Llamada al sistema "write"
;    mov ecx, ebx      ; Descriptor de archivo
;    mov edx, espacio  ; Dirección del espacio en blanco
;    mov ebx, 1        ; Longitud del espacio en blanco
;    int 0x80          ; Realizar la llamada al sistema

;    ; Cerrar el archivo
;    mov eax, 6        ; Llamada al sistema "close"
;    mov ebx, ecx      ; Descriptor de archivo
;    int 0x80          ; Realizar la llamada al sistema

; Abrir el archivo en modo de escritura y apuntar al final del archivo
    mov eax, 5        ; Llamada al sistema "open"
    mov ebx, file  ; Nombre del archivo a abrir
    mov ecx, 2        ; Modo de apertura (escritura y apuntar al final)
    mov edx, 0666     ; Permisos del archivo
    int 0x80          ; Realizar la llamada al sistema

    ; Apuntar al final del archivo
    mov eax, 19       ; Llamada al sistema "lseek"
    mov ecx, ebx      ; Descriptor de archivo
    mov edx, 0        ; Desplazamiento relativo al final del archivo
    mov ebx, 2        ; Origen del desplazamiento (final del archivo)
    int 0x80          ; Realizar la llamada al sistema

    ; Escribir los datos al final del archivo
    mov eax, 4        ; Llamada al sistema "write"
    mov ecx, ebx      ; Descriptor de archivo
    mov edx, decodi    ; Dirección de los datos a escribir
    mov ebx, edi ; Longitud de los datos a escribir
    int 0x80          ; Realizar la llamada al sistema

    ; Cerrar el archivo
    mov eax, 6        ; Llamada al sistema "close"
    mov ebx, ecx      ; Descriptor de archivo
    int 0x80          ; Realizar la llamada al sistema

    mov eax, 4
    mov ebx, 1
    mov ecx, decodi
    mov edx, 4
    int 0x80





;jmp read_loop

end_search:

   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel



section .bss
fd_in  resb 1
info resb 28


section	.data
file_name db 'test.txt',0
file db 'deco.txt',0
two dd 2    ; valor constante para utilizar en la división por 2
binary: times 16 db 0
;num1 db 0000000000000000b, 0
;num2 db 00000000b, 0

num1 db '0000000000000000', 0
num2 db '00000000', 0
decodi db 4 ,0
decimal db 00000 , 0
write db 4, 0
d dd 1631 , 0
n dd 5963 , 0
modulo db 0





