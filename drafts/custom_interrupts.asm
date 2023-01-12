createCustomInterrupt:
	shl bx, 2
	mov ax, 0
	mov es, ax
	mov word [bx], si
	mov word [bx + 2], 0
	ret