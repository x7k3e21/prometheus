
[org 0x7C00]

KERNEL_LOCATION equ 0x1000

%include "bios.asm"

    section .text

_bootloader_entry:
    mov [BOOTLOADER_DRIVE], dl

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov bp, 0x8000
    mov sp, bp

    mov ah, 02d
    mov al, 02d

    mov ch, 00d
    mov dh, 00d
    
    mov cl, 02d

    mov bx, KERNEL_LOCATION

    mov dl, [BOOTLOADER_DRIVE]

    int 0x13

    cli
    lgdt [GDT32.descriptor]
    
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    jmp GDT32.code:_pm_bootloader_entry

    hlt

GDT32.start:
    dq 0x0000000000000000
GDT32.code: equ $ - GDT32.start
    db 0xFF, 0xFF
    db 0x00, 0x00, 0x00

    db 10011010b
    db 11001111b

    db 0x00
GDT32.data: equ $ - GDT32.start
    db 0xFF, 0xFF
    db 0x00, 0x00, 0x00

    db 10010010b
    db 11001111b

    db 0x00
GDT32.end:

GDT32.descriptor:
    dw GDT32.end - GDT32.start - 1
    dd GDT32.start

BOOTLOADER_DRIVE: db 0

    [bits 32]

_pm_bootloader_entry:
    mov ax, GDT32.data
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov esp, 0x9000
    mov esp, ebp

    jmp KERNEL_LOCATION

    times 510 - ($ -$$) db 0

    db 0x55
    db 0xAA