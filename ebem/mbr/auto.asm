autoChooseStart:
	call startBooting.int13hBasic

	mov dx, 1700h
	call cursorPosition

	mov cx, 80

	.loop:
		push cx
		mov ah, 11h
		int 16h
		jne menuStart

		mov ah, 86h
		xor cx, cx
		mov dx, 6250
		int 15h

		mov ax, 0x0edb
		int 10h

		pop cx

		loop .loop

		jmp startBooting.launch