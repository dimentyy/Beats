%define bootSector 0x7C00
%define bootDx bootSector - 2

%define ebemStartSector 3
%define ebemStartHead 0
%define ebemOffsetStart 0x7000
%define ebemSectorCount 16

; nasm options
org bootSector
cpu 8086
bits 16

; variables
mov [bootDx], dx

int13h:
	xor ax, ax
	mov dx, [bootDx]
	int 13h

	xor ax, ax
	mov es, ax
	mov ax, 0x0206
	mov bx, 0x7000
	mov cx, 3
	mov dx, [bootDx]
	mov dh, 0

	int 13h
	cmp ah, 0x00
	jz ebemOffsetStart

	push ax

	; video settings
	mov ax, 3
	int 10h ; video mode
	mov ax, 500h
	int 10h ; active page

	; cursor position
	mov ah, 2
	xor bh, bh
	mov dx, 0102h
	int 10h

	pop ax

	mov al, ah
	mov ah, 0eh
	push ax

	mov cl, 4
	shr al, cl
	call .nibble

	pop ax
	and al, 0x0f

	call .nibble

	; print string
	mov ah, 0eh
	xor bh, bh
	mov si, hErrString
	.loop:
		lodsb
		cmp al, bh
		jz .waitForKeyPress
		int 10h
		mov cx, 6000
		.slowMo:
			loop .slowMo
		jmp .loop

	.waitForKeyPress:
		xor ah, ah
		int 16h

	jmp int13h

	.nibble:
		cmp al, 0x0a
		jl .afterAdd
		add al, 0x11
		.afterAdd:
		add al, 0x30
		xor bh, bh
		int 10h
		ret

hErrString: db "h - int13h (2h) error while loading EBeM. Any key to try again", 0

; fill other bytes with zeros
times 510 - ($ - $$) db 0x00

; boot_manager info


; boot sector signature
dw 0xaa55