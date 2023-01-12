autoChooseStart:
	call startBooting.int13hBasic

	mov ah, 2
	xor bh, bh
	mov dx, 1700h
	int 10h

	mov cx, 80

	.loop:
		push cx
		mov ah, 11h
		int 16h
		jne menuLoop

		mov ah, 86h
		xor cx, cx
		mov dx, 6250
		int 15h

		mov ax, 0x0edb
		int 10h

		pop cx
		loop .loop

		jmp startBooting.launch