menuLoop:
	.loop:
		mov cx, 6 * 255 + 36
		mov dh, 0x07
		mov si, ebem_mbr_name
		call printString
		jmp .loop