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
    
   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80
    
   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80    
	
   mov eax, info
   mov ebx, 10
   mul ebx
   mov ecx, num
   
_print:
   
   mov eax, 4
   mov ebx, 1
   mov ecx, num
   mov edx, 2
   int 0x80

   mov eax, 4
   mov ebx, 1
   mov ecx, info
   mov edx, 1
   int 0x80
       
   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel

section	.data
file_name db 'test.txt'

section .bss
fd_out resb 1
fd_in  resb 1
info resb  1
num resb 2
