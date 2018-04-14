object:Lab0x02-diagonal.asm
	nasm -f elf32 -g -F dwarf Lab0x02-diagonal.asm

go: Lab0x02-diagonal.o
	ld -m elf_i386 Lab0x02-diagonal.o -o go
	
debug: 


clean:
