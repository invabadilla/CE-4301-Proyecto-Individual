section .data
    filename db "test.txt", 0
    mode     db "r", 0
    buffer   db 32      ; buffer de lectura

section .bss
fd_out resb 1
fd_in  resb 1
info resb 1


section .text
    global _start

_start:
    ; Abrir el archivo en modo de lectura
    mov eax, 5           ; syscall para abrir archivo
    mov ebx, filename   ; nombre del archivo
    mov ecx, mode       ; modo de apertura
    mov edx, 0777          ;read, write and execute by all
    int 0x80            ; llama al sistema
    mov esi, eax        ; guarda el descriptor de archivo en esi



    ; Establecer el puntero de archivo en la posición deseada
    mov eax, 3         ; posición deseada (por ejemplo, 1 bytes desde el inicio del archivo)
    mov ebx, esi        ; descriptor de archivo
    mov ecx, eax        ; posición de desplazamiento
    mov edx, 0          ; origen de desplazamiento (0 = desde el inicio del archivo)
    mov eax, 19         ; syscall para establecer el puntero de archivo
    int 0x80            ; llama al sistema

    ; Leer los datos de esa posición en un buffer
    mov eax, 3          ; syscall para leer archivo
    mov ebx, esi        ; descriptor de archivo
    mov ecx, buffer     ; buffer de lectura
    mov edx, 32         ; tamaño máximo de lectura
    int 0x80            ; llama al sistema

    ; close the file
   mov eax, 6
   mov ebx, esi
   int  0x80

        ; Imprimir la cadena que se leyó
    mov edx, 32          ; tamaño de la cadena a imprimir
    mov ecx, buffer       ; cadena a imprimir
    mov ebx, 1            ; descriptor de archivo estándar de salida (stdout)
    mov eax, 4            ; syscall para escribir en archivo
    int 0x80              ; llama al sistema


    ; Buscar el primer espacio en blanco en el buffer a partir de la posición deseada
    mov edi, 0          ; posición actual en el buffer
    mov ebp, 0          ; posición del primer espacio en blanco después de la posición deseada
    cmp byte [buffer+edi], 0 ; verifica si el buffer está vacío
    je end_search
search_loop:
    cmp byte [buffer+edi], ' ' ; compara el byte actual con un espacio en blanco
    je space_found
    inc edi               ; incrementa la posición actual en el buffer
    cmp edi, 32           ; verifica si se ha llegado al final del buffer
    je end_search
    jmp search_loop
space_found:
    add ebp, edi           ; suma la posición actual en el buffer a la posición del primer espacio en blanco
    ; Calcular la posición en el archivo donde se encuentra el espacio en blanco
    sub ebp, edi           ; resta la posición actual en el buffer para obtener la posición relativa del espacio en blanco
    add ebp, eax           ; suma la posición relativa a la posición deseada para obtener la posición absoluta en el archivo
end_search:

    ; Si no se encontró el espacio en blanco, volver a leer más datos del archivo
    ;cmp ebp, 0
    ;je search_loop
    ;add eax, 32

    ; Imprimir la lectura desde la posición inicial hasta el espacio en blanco que se encontró
    mov edx, ebp          ; tamaño de la cadena a imprimir (posición del espacio en blanco)
    mov ecx, buffer       ; cadena a imprimir
    mov ebx, 1            ; descriptor de archivo estándar de salida (stdout)
    mov eax, 4            ; syscall para escribir en archivo
    int 0x80              ; llama al sistema
