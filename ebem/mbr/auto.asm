autoChooseStart:
	call startBooting.int13hBasic

	mov dx, 1700h
	call cursorPosition

	mov ah, 01h
	mov cx, 2607h
	int 10h

	mov cx, 80

	.loop:
		push cx
		mov ah, 11h
		int 16h
		jne menuStart

		mov ah, 86h
		mov dx, 6250
		xor cx, cx
		int 15h

		mov ax, 0x0edb
		int 10h

		pop cx
		loop .loop
		jmp startBooting.launch