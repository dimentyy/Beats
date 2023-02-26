printString:
	.loop:
		lodsb
		cmp al, 0
		jz .return

		mov ah, 09h
		mov cx, 1
		int 10h

		mov ah, 03h
		int 10h
		inc dl
		mov ah, 02h
		int 10h

		jmp .loop

	.return:
		ret

newString:
	mov ah, 0Eh
	mov al, 0Ah
	int 10h
	mov al, 0Dh
	int 10h
	.return:
		ret

printMainMenuString:
	xor ax, ax
	mov al, [stringAddresses + si]
	mov si, ax
	add si, stringAddresses

	call printString

	ret

printMenuString:
	mov ah, 3
	xor bh, bh
	int 10h

	push dx

	mov ax, 0xb800
	mov es, ax

	.loop:
		lodsb
		cmp al, 0
		jz .return

		cmp al, 0x0D
		je .changeCursorPosition

		mov [es:bx]

		mov ah, 03h
		int 10h
		inc dl
		mov ah, 02h
		int 10h

		jmp .loop

		.changeCursorPosition:
			pop dx
			inc dh
			push dx
			call cursorPosition
			jmp .loop

		.return:
			pop dx
			ret

cursorPosition:
	mov ah, 2
	xor bh, bh
	int 10h
	ret