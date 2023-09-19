
[org 0x7C00]

    xor ax, ax
    mov ds, ax

    mov al, 'X'
    mov ah, 0x0E

    int 0x10

    times 510 - ($ -$$) db 0

    db 0x55
    db 0xAA