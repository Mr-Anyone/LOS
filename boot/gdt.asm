; global descriptor table 

gdt_start:

gdt_null:
    dd 0x0 ; ’dd’ means define double word (i.e. 4 bytes) dd 0x0
    dd 0x0

gdt_code: ; the code segment descriptor
    dw 0xffff
    dw 0x0 
    db 0x0
    db 10011010b 
    db 11001111b 
    db 0x0
gdt_data: ;the data segment descriptor
    ; Same as code segment except for the type flags:
    ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b 
    db 11001111b 
    db 0x0
gdt_end:

; GDT descriptior
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[extern CODE_SEG]
[extern DATA_SEG]
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
