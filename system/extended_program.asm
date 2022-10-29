org 0x500

; video mode
mov ah, 00h
mov al, 13h
int 10h

call setupColorPallete

mov bx, 0
mov ax, 320 * 200
mov cl, 01001001b
mov dx, 0xa000

call writingByteToRAM

writingByteToRAM:
    .loop:
        cmp ax, 0
        jz .done
        mov es, dx
        mov byte [es:bx], bh
        inc bx
        sub ax, 1
        jmp .loop
    .done:
        ret

jmp $

setupColorPallete:
    mov bl, 0
    mov dh, 0
    mov cx, 0
    mov bh, 0
    .loop:
        ; red
        mov bh, bl
        and bh, 11100000b
        shr bh, 2
        mov dh, bh

        ; green
        mov bh, bl
        and bh, 00011100b
        shl bh, 1
        mov ch, bh

        ; blue
        mov bh, bl
        and bh, 00000011b
        shl bh, 4
        mov cl, bh

        mov bh, 0
        mov ah, 10h
        mov al, 10h
        int 10h

        inc bl
        cmp bl, 0
        jz .done
        jmp .loop

    .done:
        ret

jmp $

times 512*48-($-$$) db 0