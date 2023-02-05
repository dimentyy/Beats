%define loadOffset      0x1000
%define loadSegment     0x0000
%define sectorsToRead   16
%define head            0x00
%define sectorCylinder  0x0003

%define bootSector      0x7C00
org bootSector
cpu 8086

push dx
push dx

mov ax, loadSegment
mov es, ax

mov ah, 2h
mov al, sectorsToRead
mov bx, loadOffset
pop dx
mov dh, head
mov cx, sectorCylinder

int 13h

jb error

jmp loadOffset

error:
	push ax
	push ax

	mov si, int10hErrorString
	call .printString

	pop ax
	and al, 0xf0
	mov cl, 4
	shr al, cl
	call .nibble

	pop ax
	and al, 0x0f
	call .nibble

	mov si, tryAgainString
	call .printString

	xor ah, ah
	int 16h

	.tryAgain:
		xor ah, ah
		pop dx
		int 13h
		jmp bootSector

	.nibble:
		cmp al, 10
		jl  .afterAdd
			add al, "A" - "9" - 1
		.afterAdd:
		add al, "0"
		mov ah, 0x0e
		xor bh, bh
		int 10h
		ret

	.printString:
		.loop:
			lodsb
			cmp al, 0
			je .done
			mov ah, 0eh
			xor bh, bh
			int 10h
			jmp .loop

		.done:
			ret

int10hErrorString:  db "Int13h read error: 0x", 0
tryAgainString:     db 0x0A, 0x0D, "Press any key to try again...", 0x0A, 0x0A, 0x0D, 0

times 510-($-$$) db 0
dw 0xaa55