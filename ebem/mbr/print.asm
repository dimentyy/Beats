setupPrinting:
	mov ah, 0x0f
	int 10h
	mov byte [bootSector + 512], ah
	ret

printChar:
	; calculate address
	mov al, [bootSector + 512]
	mov bx, cx

	mul bh
	mov bh, 0

	add bx, ax
	shl bx, 1

	; set char
	mov ax, 0xb800
	mov es, ax
	mov word [es:bx], dx
	ret

printString:
	.loop:
		cld
		lodsb
		mov dl, al
		cmp dl, 0
		je .done
		call printChar
		inc cx
		jmp .loop

	.done:
		ret