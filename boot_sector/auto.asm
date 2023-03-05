autoChooseStart:
	call startBooting.int13hBasic
	jmp menuStart
	.afterInt13h:

	mov dx, 1700h
	call cursorPosition

	mov ah, 01h
	mov cx, 2607h
	int 10h

	mov cx, 80

	.loop:
		push cx

		mov ax, 0x0edb
		int 10h

		mov ah, 86h
		mov dx, 5000
		xor cx, cx
		int 15h

		mov ah, 11h
		int 16h
		jne menuStart

		pop cx
		loop .loop