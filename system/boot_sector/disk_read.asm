loadedExtendedProgram equ 0x500

bootDisk:
    db 0

diskRead:
    mov ah, 0x02
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02

    mov bx, loadedExtendedProgram
    mov dl, [bootDisk]
    mov al, 32

    int 0x13
    jc .fail
    ret

    .fail: