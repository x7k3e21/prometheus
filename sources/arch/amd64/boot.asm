
[org 0x7C00]

KERNEL_LOCATION equ 0x1000

%include "bios.asm"

    section .text

_bootloader_entry:
    xor ax, ax
    mov ds, ax

    mov bh, (BIOS_COLOR_BLACK << 4) | (BIOS_COLOR_WHITE)

    call clear.start

    cli
    lgdt [GDT32.descriptor]
    
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    jmp GDT32.code:_pm_bootloader_entry

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

    [bits 32]

_pm_bootloader_entry:
    mov ax, GDT32.data
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov esp, stack.top

    mov ebx, greeting_message

    call _print_message.begin

    jmp $

%define VIDEO_MEMORY_ADDRESS 0xB8000

_print_message.begin:
    pusha
    mov edx, VIDEO_MEMORY_ADDRESS

_print_message.loop:
    mov al, [ebx]
    mov ah, 0x0F

    cmp al, 0
    je _print_message.end

    mov [edx], ax
    add ebx, 1
    add edx, 2 

    jmp _print_message.loop

_print_message.end:
    popa

    ret

    times 510 - ($ -$$) db 0

    db 0x55
    db 0xAA

    section .bss

stack.bottom:
    resb 16 * 1024
stack.top: