CC = i686-elf-gcc
CFLAGS = -ffreestanding -I./kernel/include -I./drivers -std=c18
LD = i686-elf-ld
LD_FLAGS = -Ttext 0x1000 --oformat binary

# Inefficient - you could find a better achieve the same purpose but in a fewer lines of code
C_SOURCES = $(wildcard kernel/src/*.c drivers/*.c)
KERNEL_ASM_SOURCE  =$(wildcard kernel/src/*.asm)  
OBJ = ${C_SOURCES:.c=.o}

OBJ_ASM = ${KERNEL_ASM_SOURCE:.asm=.o}
HEADERS = $(wildcard kernel/include/*.h drivers/*.h)

all: run 

run: os-image 
	qemu-system-i386  -fda   os-image

os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

kernel.bin: kernel/kernel_entry.o  ${OBJ} ${OBJ_ASM}
	$(LD) $(LD_FLAGS) -o $@ $^
	
%.o:%.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@ 

%.o:%.asm 
	nasm -f elf -o $@  $<

# building the boot sector 
boot/boot_sect.bin: boot/boot_sect.asm boot/boot_functions.asm boot/gdt.asm
	nasm -f bin -I./boot -o $@ $<

clean: 
	rm -f kernel/src/*.o drivers/*.o boot/*.o boot/*.o boot/*.bin kernel/*.o
	rm kernel.bin os-image