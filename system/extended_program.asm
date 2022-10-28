org 0x500

mov bx, 0
mov ax, 320 * 200
mov cl, 0x3a
call writingColorToVM

writingColorToVM:
    .loop:
        cmp ax, 0
        jz .done
        mov dx, 0xa000
        mov es, dx
        mov byte [es:bx], cl
        inc bx
        sub ax, 1
        jmp .loop

    .done:
        ret

jmp $

times 16384-($-$$) db 0