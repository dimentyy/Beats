%define bootSector 0x7C00
%define mbrCopyOffset 1024
%define mbrCopyAddress bootSector - mbrCopyOffset
%define bootDx mbrCopyAddress - 2

; nasm options
org mbrCopyAddress
cpu 8086
bits 16

; variables
mov [bootDx], dx
mov bp, bootSector

; copy mbr to new location
cld
mov di, mbrCopyAddress
mov si, bp
mov cx, 256
rep movsw
jmp $ - mbrCopyOffset + 2

mov di, selectedPartition + mbrCopyOffset

cmp byte [di], 0
jnz animationStart

menuStart:
	call video
	.afterVideo:

	; cursor position
	mov dx, 0202h
	call cursorPosition

	; print underline
	mov ax, 0ecdh
	mov cx, 12
	.underLine:
		int 10h
		loop .underLine

	; cursor position
	mov dx, 0102h
	call cursorPosition

	; print
	mov si, partitionString
	call printString

	.partitionDec:
		sub byte [di], 2

	.partitionInc:
		inc byte [di]

		cmp byte [di], 1
		jl .partitionInc
		cmp byte [di], 4
		jg .partitionDec

	.menuLoop:
		mov bx, 0xad2d ; just because
		mov es, bx
		mov ax, "0" + 7 * 256
		add al, [di]
		mov ah, 7
		mov [es:bx+189], ax ; just because

		xor ah, ah
		int 16h
		cmp ah, 0x48
		je .partitionInc
		cmp ah, 0x50
		je .partitionDec
		cmp ah, 0x1C
		jne .menuLoop

animationStart:
	.int13h:
		mov cl, 4
		mov si, [di]
		and si, 0xff
		shl si, cl
		add si, partitionTableStart - 16
		cmp byte [si], 0x80
		jne .notActive

		xor ax, ax

		mov dx, [bootDx]

		int 13h

		xor ax, ax
		mov es, ax
		mov ax, 0x0201              ; Function 02h, read only 1 sector
		mov bx, bp              ; Buffer for read starts at 7C00
		mov dx, [bootDx]
		mov dh, [si+3]
		mov cx, [si+1]

		int 13h
		jb .error

		cmp byte [bootSector], 0
		je .notABootLoader              ; Bootloader code
		cmp word [bootSector + 510], 0xAA55
		je .afterInt13h             ; Boot mark

	.notABootLoader:
		call .notA
		mov si, bootloaderString
		call printString
		jmp menuStart.afterVideo

	.notActive:
		call .notA
		mov si, ctiveString
		call printString
		mov cx, 6
		mov ax, 0e00h
		.whitespace:
			int 10h
			loop .whitespace
		jmp menuStart.afterVideo

	.notA:
		mov dx, 0x0403
		call cursorPosition
		mov si, notAString
		call printString
		ret

	.afterInt13h:
		mov dx, 1700h
		call cursorPosition

		mov ah, 01h
		mov cx, 2607h
		int 10h

		mov cx, 80

		.loop:
			push cx

			mov ax, 0x0edb
			int 10h

			mov ah, 86h
			mov dx, 5000
			xor cx, cx
			int 15h

			mov cx, 3000
			.wait:
				loop .wait

			mov ah, 1
			int 16h
			jne menuStart

			pop cx
			loop .loop
		mov dx, [bootDx]
		jmp bootSector

	.error:
		push ax
		mov dx, 0x0403
		call cursorPosition
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
		call printString

		.waitForKeyPress:
			xor ah, ah
			int 16h

		jmp menuStart

		.nibble:
			cmp al, 0x0a
			jl .afterAdd
			add al, 0x11
			.afterAdd:
			add al, 0x30
			xor bh, bh
			int 10h
			ret

; printing
printString:
	mov ah, 0eh
	xor bh, bh
	.loop:
		lodsb
		cmp al, bh
		int 10h
		jz return
		jmp .loop

; set cursor position
cursorPosition:
	mov ah, 2
	xor bh, bh
	int 10h

; return optimization
return:
	ret

; video settings
video:
	mov ax, 3
	int 10h ; video mode
	mov ax, 500h
	int 10h ; active page
	ret

; strings
partitionString: db "Partition:", 0
notAString: db "Not a", 0
bootloaderString: db "bootloader", 0
ctiveString: db 8, "ctive", 0 ; ascii 8 - go back one symbol
hErrString: db "h - int13h (2h) err", 0


; fill other bytes with zeros
times 445 - ($ - $$) db 0x00

; selected partition
; 0   - not selected
; 1-4 - selected
selectedPartition: db 1

; partition table
partitionTableStart:
	; main partition
	db 0x80
	db 2
	db 0
	db 0
	db 0xEA
	db 0
	db 0x01
	db 0
	dq 0

	; empty partitions
	times 48 db 0x00

; boot sector signature
dw 0xaa55