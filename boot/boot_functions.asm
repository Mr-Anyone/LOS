[bits 16]
; parameters
; bx stores the memory address of the first character 

; al registers stores the current character being examined 
; di stores the character offset
TELETYPE_CALL equ 0x10
print_string_real: 
    mov ah, 0x0e
    mov di, 0

print_string_real_loop:
    mov al, [bx + di]
    cmp al, 0
    je end_pring_string

    int TELETYPE_CALL
    inc di 
    jmp print_string_real_loop

end_pring_string: 
    ret
    
[bits 16]
LOADING_KERNEL_MESSAGE db "Loading Kernel", 0

load_kernel:
    mov bx, LOADING_KERNEL_MESSAGE
    call print_string_real

    ; loading the kernel to memory
    mov dh, 20 ; the disk sector to read 
    mov dl, [BOOT_DRIVE] ;  the boot drive 
    mov bx, KERNEL_OFFSET
    call read_disk

    ret
    
[bits 16]
DISK_CALL equ 0x13
; read disk 
; parameters 
; AH	02h
; AL	Sectors To Read Count
; CH	Cylinder
; CL	Sector
; DH	Head
; DL	Drive
; ES BX	Buffer Address Pointer

; dh, dl, bx will be set by the user
; dh - the number of sectors to be read
read_disk:
    ; save the amount of sector read 
    push dx

    mov ah, 0x02 
    mov al, dh
    mov ch, 0x00
    mov cl, 0x02 ; starting reading the second disk sector (i.e the first will be the boot_sect)
    mov dh, 0x00 ; 
    int DISK_CALL
    
    jc disk_error 
    
    pop dx
    cmp dh, al
    jne disk_error
    
    ret 

disk_error:
    mov bx, DISK_ERROR_MESSAGE
    call print_string_real
    jmp $

DISK_ERROR_MESSAGE db "CANNOT READ DISK", 0

[bits 16]
switch_to_pm:
    cli ; disable interrupt
    lgdt [gdt_descriptor]
    
    mov eax, cr0
    or eax, 0x1 
    mov cr0, eax 

    jmp CODE_SEG:init_pm
    

[bits 32]
; parameters
; ebx - starting memory address of a sentence
; local variables & registers
; edi - the current register being examined
; edx - stores the character being examined

VIDEO_MEMORY equ 0xb8000
COLOR_MEMORY equ 0xb8001
WHITE_COLOR equ 15 ; white in color table (https://wiki.osdev.org/Printing_To_Screen#Color_Table) 
print_string_pm: 
    mov edi, 0 
    mov edx, [ebx + edi]

print_string_pm_loop: 
    cmp edx, 0
    je end_print_string_pm
    
    ; the next characer 
    mov [VIDEO_MEMORY + 2 * edi], dl
    mov dl, WHITE_COLOR
    mov [COLOR_MEMORY + 2 * edi], dl
    inc edi
    mov edx, [ebx + edi]
    jmp print_string_pm_loop

end_print_string_pm: 
    ret

[bits 32]
init_pm: 
    mov ax, DATA_SEG 
    mov ds, ax 
    mov ss, ax
    mov es, ax
    mov fs, ax 
    mov gs, ax 

    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM 

[bits 16]
; This would switch to a graphics mode
switch_to_graphics_mode:
    mov ah, 0x00
    mov al, 0x13
    int 0x10
    ret