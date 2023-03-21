
section	.text
   global _start         ;must be declared for using gcc

_start:                  ;tell linker entry point

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

   ; imprimir lo que leyo del archivo
   mov eax, 4
   mov ebx, 1
   mov ecx, info
   mov edx, 8
   int 0x80

    ; imprimir lo que leyo del archivo
   mov eax, 4
   mov ebx, 1
   mov ecx, espacio
   mov edx, 1
   int 0x80

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
    ;add edi,1
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
    jmp read_loop

end_search:

   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel



section .bss
fd_in  resb 1
info resb 8
fd resd 1 ; descriptor de archivo

section	.data
file_name db 'test.txt',0
file db 'deco.txt',0
two dd 2    ; valor constante para utilizar en la división por 2
espacio dd 10
binary: times 16 db 0
;num1 db 0000000000000000b, 0
;num2 db 00000000b, 0

num1 db '0000000000000000', 0
num2 db '00000000', 0
decodi db '    ' ,0
decimal db 00000 , 0
write db 4, 0
d dd 1631 , 0
n dd 5963 , 0
modulo db 0





