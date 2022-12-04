printChar:
	; calculate address
	mov al, 80
	mov bx, cx

	mul bh
	mov bh, 0

	add bx, ax
	shl bx, 1

	; set char
	mov ax, 0xb800
	mov es, ax
	mov word [es:bx], dx
	inc cx
	ret

printString:
	.loop:
		cld
		lodsb
		mov dl, al
		cmp dl, 0
		je .done
		call printChar
		jmp .loop

	.done:
		ret