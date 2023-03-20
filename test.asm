    mov r8,0  ;Resetear el contador de numeros

   ; Convertir el primer número en una cadena de caracteres
    mov al, [num1]
    mov cl, 10
    mov bx, 0
digit_loop1:
    xor ah, ah
    div cl
    add ah, '0'
    add bx,buffer1
    mov [bx], ah
    sub bx,buffer1
    inc bx
    test al, al
    jnz digit_loop1

    ; Convertir el segundo número en una cadena de caracteres
    mov al, [number2]
    mov cl, 10
digit_loop2:
    xor ah, ah
    div cl
    add ah, '0'
    mov [buffer+bx], ah
    inc bx
    test al, al
    jnz digit_loop2

    ; Concatenar las dos cadenas en una nueva cadena
    mov byte [buffer+bx], ' '
    mov cx, bx
    dec bx
    mov di, buffer
concat_loop:
    mov al, [buffer+bx]
    mov [di], al
    inc di
    dec bx
    cmp bx, 0
    jge concat_loop

    ; Convertir la cadena resultante en un número entero
    mov al, [buffer]
    sub al, '0'
    mov bl, 10
convert_loop:
    movzx ax, byte [di-1]
    sub ax, '0'
    imul bl
    add al, bl
    mov bl, al
    dec di
    cmp di, buffer
    jge convert_loop

    ; Imprimir el número entero concatenado
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, cx
    add edx, 1
    int 0x80


        mov al, [num1]
    sub al,48         ;Para quitar formato ASCII
    mov ch,al         ; desplaza el contenido de eax 8 bits a la izquierda

    mov dl, [num2]
val1:
    sub dl, 49
val2:
    or rcx, rdx  ; realiza una operación OR entre eax y ebx

val:



******



    mov eax, num1    ;eax: dirección del primer byte del primer buffer
    mov ebx, num2   ; - ebx: dirección del primer byte del segundo buffer
    mov ecx, len   ; - edx: longitud del segundo buffer

    add eax, len   ; calcular la dirección del primer byte del segundo buffer

loop_start:
    cmp ecx, 0  ; comprobar si se ha alcanzado el final del bucle
    je loop_end ; si es así, saltar al final del bucle

    mov dl, [ebx] ; copiar el byte actual del segundo buffer a dl
    mov [eax], dl ; copiar el byte actual al final del primer buffer

    inc eax      ; incrementar la dirección del primer buffer
    inc ebx      ; incrementar la dirección del segundo buffer
    sub ecx, 1      ; decrementar el contador del bucle
    jmp loop_start ; saltar al inicio del bucle

loop_end:

