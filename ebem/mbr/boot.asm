startBooting:
	.int13hBasic:
		mov al, [lastBootPartition]
		xor ah, ah

		mov bp, ax
		mov cl, 4
		shl bp, cl
		add bp, partitionTableStart - 16
		cmp byte [bp], 0x80
		jne menuStart

		mov bp, ax
		mov cl, 4
		shl bp, cl
		add bp, partitionTableStart - 16 + 1

		mov ax, 0
		mov es, ax

		mov ax, 0x0201              ; Function 02h, read only 1 sector
		mov bx, bootSector              ; Buffer for read starts at 7C00
		mov dx, [savedDX]             ; DL = Disk Drive
		mov dh, 0
		mov cx, 2

		int 13h
		jb .error

	.checkForCorrectLaunch:
		cmp byte [bootSector], 0
		je .notABootSector              ; No bootloader code
		cmp word [bootSector + 510], 0xAA55
		jne .notABootSector             ; Missing bootable mark

		ret

	.launch:
		mov dx, [savedDX]
		jmp bootSector

	.error:
		push ax
		push ax

		mov si, int10hErrorString
		call printString

		pop ax
		mov cl, 4
		shl al, cl
		call .nibble

		pop ax
		and al, 0x0f
		call .nibble

		jmp $

	.nibble:
		cmp al, 0x0a
		je .afterAdd
		add al, 0x11
		.afterAdd:
		add al, 0x30
		mov ah, 0x0e
		xor bh, bh
		int 10h
		ret

	.resetDisk:
		xor ah, ah
		mov dx, [savedDX]
		int 13h
		jmp .int13hBasic

	.notABootSector:
		mov si, notABootSectorString
		call printString
		jmp $