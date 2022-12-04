debugWord:
	mov cx, 0x184c

	push dx
	push dx
	push dx

	and dl, 0xf0
	shr dl, 4
	call .nibble

	pop dx
	and dl, 0x0f
	call .nibble

	pop dx
	mov dl, dh
	and dl, 0xf0
	shr dl, 4
	call .nibble

	pop dx
	mov dl, dh
	and dl, 0x0f
	call .nibble

	ret

	.nibble:
		cmp dl, 0x0a
		jge .add
		add dl, 0x30
		mov dh, 0x1f
		call printChar
		ret

	.add:
		add dl, 0x11
		ret