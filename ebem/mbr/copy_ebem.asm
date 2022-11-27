%define bootSector 0x7c00

copyEbem:
	mov bx, 0
	.loop:
		add bx, bootSector
		mov dx, word [bx]
		mov word [bx - 512], dx
		sub bx, bootSector - 2
		cmp bx, 512
		je .done
		jmp .loop

	.done:
		ret