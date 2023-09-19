
[org 0x7C00]

    section .text

    global _bootloader_entry

_bootloader_entry:
    jmp _bootloader_entry

    times 510 - ($ - $$) db 0

    db 0x55
    db 0xAA