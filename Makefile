all:
	nasm -f elf32 -o calculator.o calculator.asm
	ld -m elf_i386 -o calculator ./calculator.o

clean:
	rm -f ./calculator ./calculator.o
