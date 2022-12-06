printString:
	.loop:
		cld
		lodsb
		cmp al, 0
		je .done
		mov ah, 0eh
		mov bh, 0
		int 10h
		jmp .loop

	.done:
		ret