startBooting:
	.launch:
		mov dx, [bp+2]
		jmp bootSector

	.int13hBasic:
		mov di, [lastBootPartition]
		and di, 255

		mov cl, 4
		shl di, cl
		add di, partitionTableStart - 16
		cmp byte [di], 0x80
		jne .notActive

		xor ax, ax
		mov dx, [bp+1]
		int 13h
		mov es, ax

		mov ax, 0x0201              ; Function 02h, read only 1 sector
		mov bx, bp              ; Buffer for read starts at 7C00
		mov dx, [bp+2]             ; DL = Disk Drive
		mov cx, [di+1]

		int 13h
		jnb .checkForCorrectLaunch

	.error:
		mov dx, 0404h
		call cursorPosition

		mov al, ah
		mov ah, 0eh
		push ax

		mov cl, 4
		shr al, cl
		call .nibble

		pop ax
		and al, 0x0f

		call .nibble

		mov si, hErrString
		call printString

		ret

		.nibble:
			cmp al, 0x0a
			jl .afterAdd
			add al, 0x11
			.afterAdd:
			add al, 0x30
			xor bh, bh
			int 10h
			ret

	.notActive:
		mov dx, 0404h
		call cursorPosition

		mov si, notActive
		call printString
		ret


	.checkForCorrectLaunch:
		cmp byte [bp], 0
		jne autoChooseStart.afterInt13h              ; Bootloader code
		cmp word [bp + 510], 0xAA55
		je autoChooseStart.afterInt13h             ; Boot mark

	.notABootSector:
		mov dx, 0x0403
		call cursorPosition
		mov si, notABootSectorString
		call printString