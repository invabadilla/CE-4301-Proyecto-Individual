
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

search_loop:

    cmp byte [info+esi+edi], 0 ; verifica si el buffer está vacío
    je end_search

    cmp byte [info+esi+edi], ' ' ; compara el byte actual con un espacio en blanco
    je space_found
    add edi,1               ; incrementa la posición actual en el buffer
    cmp edi, 32           ; verifica si se ha llegado al final del buffer
    je end_search
    jmp search_loop
space_found:

    ;add esi,1

    mov eax, esi       ;Copia de puntero inicial
    mov ebx, edi       ;copia de puntero final

    ;add edi, esi       ; suma la posición actual en el buffer a la posición del primer espacio en blanco
    ; Set up the source and destination pointers
    mov ecx, eax
    add ecx, info
    mov esi,  ecx    ; Source pointer

    cmp r8,0
    je s_num1
    jne s_num2

s_num1:
    mov edi, num1   ; Destination pointer

    cmp eax,0
    je s1_num1
    jmp s2_num1
    ; Set up the length to copy
s1_num1:
    mov ecx, ebx       ;Caso en el que esi es 0
    ;sub ecx, eax
    jmp next

s2_num1:
    mov ecx, eax      ;Caso en el que esi es mayor a 0
    sub ecx, ebx
    jmp next


s_num2:
    mov edi, num2   ; Destination pointer
    ; Set up the length to copy
    mov ecx, eax
    sub ecx, ebx
    jmp next


next:


    ; Copy the buffer
    cld                 ; Clear the direction flag
    rep movsb           ; Move the bytes

    mov esi, eax       ;Copia de punteros
    add esi, ebx       ;Puntero inicial mas el final para obtener el nuevo valor inicial
    mov edi, 0       ;reseteo del contador de bits para saber cuando se encuentra un espacio en blanco
    mov edx, ecx     ;largo del array

    ;read from file
   ;mov eax, esi
   ;mov ebx, [fd_in]
   ;mov ecx, info
   ;mov edx, edi
   ;int 0x80

   ; close the file
   ;mov eax, 6
   ;mov ebx, [fd_in]
   ;int  0x80

    cmp r8,0
    je p_num1
    cmp r8,1
    je p_num2

    jmp next2

p_num1:
     ; imprimir lo que guardo en num1 del archivo
   mov eax, 4
   mov ebx, 1
   mov ecx, num1
   mov edx, 3
   int 0x80
    jmp next2

p_num2:
    ; imprimir lo que guardo en num1 del archivo
   mov eax, 4
   mov ebx, 1
   mov ecx, num2
   mov edx, 3
   int 0x80
    jmp next2

next2:
    add esi,1   ;Le sumo uno para descartar el espacio en blanco

    cmp r8,0
    je less

    cmp r8,1
    je less

    cmp r8,2
    je more

less:
    add r8,1
    jmp read_loop

more:
    mov r8,0  ;Resetear el contador de numeros



    ; Calcular la posición en el archivo donde se encuentra el espacio en blanco
    ;sub esi, edi           ; resta la posición actual en el buffer para obtener la posición relativa del espacio en blanco
    ;add esi, eax           ; suma la posición relativa a la posición deseada para obtener la posición absoluta en el archivo
end_search:



	
;   mov esi, info    ;Inicio del buffer info
;   mov eax, [esi]   ;Primer valor del buffer
;   sub eax,48       ;Se quita el valor ascii
;   imul eax, 2     ;Se multiplica
;   add eax, 48      ;Se agrega formato ascii
;   mov edi, num    ;Inicio del buffer num
;   mov [edi], eax  ;Guardar en el primer valor del buffer el registro eax
;
;    ;Se imprime el valor manipulado
;   mov eax, 4
;   mov ebx, 1
;   mov ecx, num
;   mov edx,1
;   int 0x80


       
   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel

section	.data
file_name db 'test.txt', 0
buffer   db 32


section .bss
fd_out resb 1
fd_in  resb 1
info resb 28
num resb 2
cont resb 2
num1 resb 3
num2 resb 3

