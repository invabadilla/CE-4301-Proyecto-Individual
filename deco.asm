
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

    ; Establecer el puntero de archivo en la posición deseada
    mov eax, 3         ; posición deseada (por ejemplo, 1 bytes desde el inicio del archivo)
    mov ebx, [fd_in]        ; descriptor de archivo
    mov ecx, eax        ; posición de desplazamiento
    mov edx, 0          ; origen de desplazamiento (0 = desde el inicio del archivo)
    mov eax, 19         ; syscall para establecer el puntero de archivo
    int 0x80            ; llama al sistema

   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 32
   int 0x80
    
   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80

    ; imprimir lo que leyo del archivo
   mov eax, 4
   mov ebx, 1
   mov ecx, info
   mov edx, 32
   int 0x80

	
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
file_name db 'test.txt'



section .bss
fd_out resb 1
fd_in  resb 1
info resb 1
num resb 2
cont resb 2

