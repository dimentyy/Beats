printString:
	.loop:
		lodsb
		cmp al, 0
		jz return

		mov ah, 09h
		mov cx, 1
		int 10h

		mov ah, 03h
		int 10h
		inc dl
		mov ah, 02h
		int 10h

		jmp .loop

newString:
	mov ah, 0Eh
	mov al, 0Ah
	int 10h
	mov al, 0Dh
	int 10h
	return:
		ret