
[org 0x7C00]

KERNEL_LOCATION equ 0x1000

%include "bios.asm"

    section .text

_bootloader_entry:
    xor ax, ax
    mov ds, ax

    mov bh, (BIOS_COLOR_BLACK << 4) | (BIOS_COLOR_WHITE)

    call clear.start

    mov si, greeting_message

    call print.start

    jmp $

clear.start:
    mov ah, 0x06
    mov al, 0x00

    mov ch, 00d
    mov dh, 24d

    mov cl, 00d
    mov dl, 79d

    int 0x10

clear.done:
    mov ah, 0x02
    mov bh, 0x00

    mov dh, 0x00
    mov dl, 0x00

    int 0x10

    ret

print.start:
    cld

    mov ah, 0x0E

print.loop:
    lodsb
    
    cmp al, 0
    je print.done

    int 0x10
    jmp print.loop

print.done:
    ret

greeting_message db "Hello, world!", 0

    times 510 - ($ -$$) db 0

    db 0x55
    db 0xAA