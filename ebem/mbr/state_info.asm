countActiveParts:
	mov ax, 0
	mov bx, 0
	mov cx, 4

	.loop:
		call getPartitionState
		je .inc
		loop .loop
	ret

	.inc:
		mov bx, cx
		inc ax

getPartitionState:
	mov bp, cx
	push cx
	mov cl, 4
	shl bp, cl
	pop cx
	add bp, partitionTableStart - 16
	cmp byte [bp], 0x80
	ret