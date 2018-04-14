;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; 	Kurtis B Waldner

;MAKEFILE

;object:Lab0x02-diagonal.asm
;	nasm -f elf32 -g -F dwarf Lab0x02-diagonal.asm
;
;go: Lab0x02-diagonal.o
;	ld -m elf_i386 Lab0x02-diagonal.o -o go
	
; run commands:
;		make
;		make go
;		./go
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .text      
	global _start         
_start:
_read:
    
    mov edx, BUFFERSIZE  ;;; use sys_read to read a line or buffer full of bytes
    mov ecx, inBuffer 
    mov ebx, stdin       ;;; notice I am using a defined symbol instead of plain 0x00  
    mov eax, sys_read    ;;; again, a defined constant instead of a bare 0x03
    int 0x80             

   cmp eax, 0       ; is EOF? if so...
   jle _exit         ; jump to exit

   add eax, inBuffer ;save the number of characters in buffer
   sub eax, 1 
   mov [LastByte], eax ;save the number for later
   mov edi, 0x00 ;bytes per line counter
   mov esi, inBuffer ;fist byte pointer
   inc ebp
   
_printLoop:
   mov eax, 0x00
   mov byte al, [esi]
   mov [outBuffer], al
   cmp al, NEWLINE
   je _resetCounter
_resume:
   mov edx, 1
   mov ecx, outBuffer
   mov ebx, stdout
   mov eax, sys_write
   int 0x80
          
   inc esi
   inc edi      

   cmp esi, [LastByte]
   jle _newLineSpacesPrint

jmp _read

_newLineSpacesPrint:
   mov edx, 1          
   mov ecx, newLine
   mov ebx, stdout
   mov eax, sys_write
   int 0x80  
   
   mov [counter], ebp
   
   .spaces:
      cmp ebp, 0
      je _endLoop
      dec ebp
      mov byte [outBuffer], SPACE
      mov edx, 1          
      mov ecx, outBuffer
      mov ebx, stdout
      mov eax, sys_write
      int 0x80
      jmp .spaces
   
_endLoop:
   mov ebp, [counter]
   inc ebp
   mov [counter], ebp
   cmp esi, [LastByte]
   jmp _printLoop
   
_resetCounter:
    mov edx, 1          
    mov ecx, newLine
    mov ebx, stdout
    mov eax, sys_write
    int 0x80

   mov ebp, 0
   mov [counter], ebp
   jmp _resume
   
_exit:
    mov edx, 1           
    mov ecx, newLine
    mov ebx, stdout
    mov eax, sys_write
    int 0x80            

    mov ebx, 0          
    mov eax, 1         
    int 0x80               

    
section .data

    newLine    db 0x0A

section .bss

    inBuffer   resb BUFFERSIZE
    outBuffer  resb 1   
    LastByte   resb 4
    counter resb 4

;;;;;;;;;;;;;; Constants ;;;;;;;;;;;;;;;;;;;;;;
sys_read  equ 0x03
sys_write equ 0x04
stdin     equ 0x00
stdout    equ 0x01
stderr    equ 0x02
BUFFERSIZE equ 1000
SPACE     equ 0x20  
NEWLINE   equ 0x0A  
BYTES_PER_LINE equ 1
