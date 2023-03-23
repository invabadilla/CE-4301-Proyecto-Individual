
section	.text
   global _start
	
_start:                  ;tell linker entry point

<<<<<<< HEAD
   ; Limpiar el archivo donde se almacenan los datos decodificados
   mov  eax, 8           ; Lamada al sistema 'create'
   mov  ebx, file        ; Nombre del archivo
   mov  ecx, 0777        ; Permisos
   int  0x80             ; Llamada al sistema

   ; Cerrar el archivo
   mov eax, 6
   mov ebx, eax

    ; Abrir el archivo para saber la llave privada
    mov eax, 5          ; Llamada al sistema 'open'
    mov ebx, key        ; Nombre del archivo
    mov ecx, 0          ; Modo de apertura
    int 0x80            ; Llamada al sistema
    mov ebx, eax        ; Guardar el descriptor de archivo en ebx

    ; Leer el contenido del archivo
    mov eax, 3          ; Llamada al sistema 'read'
    mov ecx, key_r      ; Búfer para almacenar los datos leídos
    mov edx, 50         ; Número máximo de bytes que se pueden leer
    int 0x80            ; Llamada al sistema

    ; Cerrar el archivo
    mov eax, 6          ; Llamada al sistema 'close'
    mov ebx, eax        ; Descriptor de archivo
    int 0x80            ; Llamada al sistema


    ; Setear valores iniciales
    mov edi, 0          ; destino
    mov esi, 0          ; inicio
    mov r8, 0           ; contador de numeros
    xor eax,eax

    ; Mapeo de los valores de llave privada ASCII -> Decimal
mapp:

    cmp r8, 2                    ; verifica si leyo los 2 valores
    je end_mapp

    cmp byte [key_r+edi], ' '    ; compara el byte actual con un espacio en blanco
    je space_found0

    cmp r8,0                     ; Valida si se esta leyendo el path o numeros

    movzx ecx, byte [key_r+edi]  ; Almacena el bit leido
    sub ecx,48                   ; Se quita fromato ASCII
    imul eax,10                  ; Se multiplica el valor del resultado
    add eax,ecx                  ; Se suma el bit actual al resultado

    add edi,1                    ; incrementa la posición actual en el buffer
    jmp mapp


space_found0:
    add r8,1

    cmp r8,1      ; Salto para almacenar el valor de d
    je save_d

    cmp r8,2      ; Salto para almacenar el valor de n
    je save_n

save_d:
    mov [d],eax ; Guardar bit en d
    xor eax,eax ; Limpiar registro
    add edi,1   ; Contador de palabras
    jmp mapp

save_n:
    mov [n],eax ; Guardar bit en n
    xor eax,eax ; Limpiar registro
    add edi,1   ; Contador de palabras
    jmp mapp

end_mapp:


; Buscar el primer espacio en blanco en el buffer a partir de la posición esi
    mov edi, 0          ; contador digitos del numero
    mov esi, 0          ; inidice en el documento
    mov r8, 0           ; contador de numeros

read_loop:

   ; Abrir archivo para leer
   mov eax, 5
   mov ebx, file_name     ; Nombre del archivo
   mov ecx, 0             ; Acceso a lectura
   mov edx, 0777          ; Permisos
   int  0x80              ; Llamada al sistema
=======

 ;create the file
   mov  eax, 8
   mov  ebx, file
   mov  ecx, 0777        ;read, write and execute by all
   int  0x80             ;call kernel

   ; close the file
   mov eax, 6
   mov ebx, eax



; Buscar el primer espacio en blanco en el buffer a partir de la posición deseada
    mov edi, 0          ; destino
    mov esi, 0          ; inicio
    mov r8, 0           ; contador de numeros



read_loop:

  ;open the file for reading
   mov eax, 5
   mov ebx, file_name
   mov ecx, 0             ;for read only access
   mov edx, 0777          ;read, write and execute by all
   int  0x80
>>>>>>> write-into-the-file

   mov  [fd_in], eax
; Establecer el puntero de archivo en la posición deseada
    mov eax, esi        ; posición deseada (por ejemplo, 1 bytes desde el inicio del archivo)
    mov ebx, [fd_in]        ; descriptor de archivo
    mov ecx, eax        ; posición de desplazamiento
    mov edx, 0          ; origen de desplazamiento (0 = desde el inicio del archivo)
    mov eax, 19         ; syscall para establecer el puntero de archivo
    int 0x80            ; llama al sistema

   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 8
   int 0x80

   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80

<<<<<<< HEAD
=======
;   ; imprimir lo que leyo del archivo
;   mov eax, 4
;   mov ebx, 1
;   mov ecx, info
;   mov edx, 8
;   int 0x80
;


>>>>>>> write-into-the-file
    mov eax, 0        ; contador de bits

search_loop:

    cmp byte [info+edi], 0 ; verifica si el buffer está vacío
    je end_search

    cmp byte [info+edi], ' ' ; compara el byte actual con un espacio en blanco
    je space_found

    movzx ecx, byte [info+edi]
    sub ecx,48
    imul eax,10
    add eax,ecx
    add edi,1               ; incrementa la posición actual en el buffer

    cmp edi, 9           ; verifica si se ha llegado al final del buffer
    je end_search
    jmp search_loop

space_found:
    add edi,1
    cmp r8,0
    je s_num1
    jne s_num2

s_num1:

       ;mov ebx, 0
     mov ebx, 48
     mov ecx, num1
     mov edx, 0
clean1:
     mov [ecx],ebx
     add edx,1
     add ecx,1
     cmp edx,16
     jb clean1

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

    ;mov ebx, 0
    mov ebx, 48
    mov ecx,num2
    mov edx,0

clean2:
    mov [ecx],ebx
    add edx,1
    add ecx,1
    cmp edx,8
    jb clean2


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
    cmp r8,0
    je less

    cmp r8,1
    je more


less:
    add r8,1
    jmp search_loop

more:

    add esi,edi
    ;add esi,1        ;Le sumo uno para descartar el espacio en blanco
    xor edi, edi       ;reseteo del contador de bits para saber cuando se encuentra un espacio en blanco


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


<<<<<<< HEAD
=======


>>>>>>> write-into-the-file
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
    mov edx, 1

loopa:
    mov r9,0


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
        jmp loop_start

    multiply:
        mov ebp, eax   ;Copia de base
        mul edx       ;mul de base por resultado  edx
        xor edx,edx    ;limpiar edx
        div ecx        ;residuo en edx
        mov eax, ebp  ;Copia del valor de la base
        jmp multiply_by_self

loop_end:

<<<<<<< HEAD
=======


>>>>>>> write-into-the-file
    mov r9,0

    mov [decimal], edx   ;Guardar el numero decodificado en un buffer


    ; Convertir el número en una cadena de caracteres
    mov eax, [decimal] ; Cargar el número en el registro eax
    mov ecx, 10       ; Divisor para la conversión
    xor edx, edx      ; Limpiar el registro edx para la división
    mov edi, decodi   ; Puntero al búfer de caracteres
    add edi,3
     ;agregar espacio
    xor edx,edx
    add edx, ' '
    mov byte[edi], dl
    sub edi,1           ; Avanzar el puntero al siguiente carácter
    add r9,1


    cmp eax, 0        ; Comprobar si el número es cero
    jne .convertir    ; Si no es cero, saltar a la conversión
    mov byte [edi], '0' ; Si es cero, escribir el carácter '0'
    sub edi,1           ; Avanzar el puntero al siguiente carácter
    add r9,1
    jmp .comp     ; Saltar a la escritura del archivo

.convertir:
    ; Convertir cada dígito en su representación ASCII
    xor edx,edx
    div ecx           ; Dividir entre 10 para obtener el resto
    add edx, '0'      ; Convertir el resto en su representación ASCII
    mov byte [edi], dl ; Escribir el carácter en el búfer
    sub edi,1           ; Avanzar el puntero al siguiente carácter
    add r9, 1
    cmp eax, 0        ; Comprobar si se ha llegado al final del número
    jne .convertir    ; Si no, continuar la conversión

.comp:
    mov eax, decodi
    sub eax, 1
    cmp edi, eax
    je .escribir

    mov byte [edi], ' ' ; Si es cero, escribir el carácter '0'
    sub edi,1           ; Avanzar el puntero al siguiente carácter
    jmp .comp

.escribir:
    ;agregar espacio al final del numero


    ;largo del string a escribir
    xor rax, rax
    add rax,r9
    mov edi, eax

<<<<<<< HEAD
=======

;           ; imprimir lo que leyo del archivo
;   mov eax, 4
;   mov ebx, 1
;   mov ecx, decodi
;   mov edx, 4
;   int 0x80
;
;       ; imprimir lo que leyo del archivo
;   mov eax, 4
;   mov ebx, 1
;   mov ecx, espacio
;   mov edx, 1
;   int 0x80

;    mov eax, 4
;    mov ebx, 1
;    mov ecx, decodi
;    mov edx, 4
;    int 0x80

>>>>>>> write-into-the-file
_write:

; Abrir el archivo en modo escritura
    mov eax, 5 ; sys_open
    mov ebx, file
    mov ecx, 0o2 ; O_RDWR
    int 0x80
    mov dword [fd], eax ; guardar el descriptor de archivo

    ; Mover el puntero del archivo al final del archivo
    mov eax, 19 ; sys_lseek
    mov ebx, dword [fd]
    mov ecx, 0
    mov edx, 2 ; SEEK_END
    int 0x80

    ; Escribir el texto en el archivo
    mov eax, 4 ; sys_write
    mov ebx, dword [fd]
    mov ecx, decodi
    mov edx, 4 ; longitud de la cadena
    int 0x80

    ; Cerrar el archivo
    mov eax, 6 ; sys_close
    mov ebx, dword [fd]
    int 0x80

<<<<<<< HEAD
=======
;    mov eax, 4
;    mov ebx, 1
;    mov ecx, decodi
;    mov edx, 4
;    int 0x80

>>>>>>> write-into-the-file
    xor edi,edi

    jmp read_loop

end_search:

   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel

<<<<<<< HEAD

section .bss
fd_in  resb 1   ; descriptor de archivos
fd resd 1       ; descriptor de archivo
info resb 8     ; Buffer para leer datos de 5.txt
d resb 4        ; Buffer de d
n resb 4        ; Buffer de n

section	.data
file_name db '5.txt',0          ; Archivo con datos encriptados
file db 'deco.txt',0            ; Archivo donde se almacenan datos desencriptados
key db 'key.txt',0              ; Archivo con valores de llave privada
two dd 2                        ; Valor constante para utilizar en la división por 2
key_r db 50,0                   ; Buffer para leer llave privada
num1 db '0000000000000000', 0   ; Buffer para almacenar valor binario
num2 db '00000000', 0           ; Buffer para almacenar valor binario
decodi db '0000' ,0             ; Buffer para almacenar valor decodificado
decimal db 00000 , 0            ; Buffer para almacenar el numero decimal codificado
=======


section .bss
fd_in  resb 1
info resb 8
fd resd 1 ; descriptor de archivo

section	.data
file_name db '5.txt',0
file db 'deco.txt',0
two dd 2    ; valor constante para utilizar en la división por 2
espacio dd 10
binary: times 16 db 0
;num1 db 0000000000000000b, 0
;num2 db 00000000b, 0

num1 db '0000000000000000', 0
num2 db '00000000', 0
;bnum1 db '0000000000000000', 0
;bnum2 db '00000000', 0
decodi db '0000' ,0
decimal db 00000 , 0
write db 5, 0
d dd 1631 , 0
n dd 5963 , 0
modulo db 0





>>>>>>> write-into-the-file
