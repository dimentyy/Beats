loadedExtendedProgram equ 0x500

bootDisk:
    db 0

diskRead:
    mov ch, 0
    mov dh, 0
    mov cl, 2

    mov bx, loadedExtendedProgram
    mov dl, [bootDisk]
    mov al, 48

    mov ah, 2h
    int 13h
    ret