[org 0x7c00]
_boot:
    mov [BOOT_DRIVE], dl ; saving the from dl register to boot_drive address


    ; setting up base pointer and stack pointer 
    mov bp, 0x9000
    mov sp, bp

    ; read + load kernel 
    call load_kernel

    ; switch graphics mode vga http://www.ctyme.com/intr/rb-0069.htm
    call switch_to_graphics_mode

    ; switch to proteced-32 bit mode 
    call switch_to_pm

%include "boot_functions.asm"
%include "gdt.asm"

[bits 32]
BEGIN_PM: 
    ; Enerted 32 bit mode 
    ; Jump to kernel code 
    mov ebx, DEBUG_PROTECED_MODE_ENTRY_MSG
    call print_string_pm
    
    call KERNEL_OFFSET
    jmp $


; Data
BOOT_DRIVE: db 0 

REAL_MODE_MSG:  db "Entered 16 bit", 0

DEBUG_PROTECED_MODE_ENTRY_MSG: db "Entered 32 bit protected mode!", 0

KERNEL_OFFSET equ 0x1000

times 510-($ - $$) db 0 
dw 0xaa55
