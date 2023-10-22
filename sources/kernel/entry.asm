
    [bits 32]

    section .text

global _kernel_entry

_kernel_entry:

    mov al, 'N'
    mov ah, 0x0F

    mov [0xB8000], ax

    jmp $