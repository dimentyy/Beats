%define bootSector 0x7C00                           ; address where mbr is loaded
%define mbrCopyOffset 1024                           ; mbr copy address offset
%define mbrCopyAddress bootSector - mbrCopyOffset   ; mbr copy address

; value addresses
%define savedDX 0x7E00

org mbrCopyAddress
cpu 8086
bits 16

mov [savedDX], dx

; copy mbr to new dest
mov di, mbrCopyAddress
mov si, bootSector
mov cx, 512
rep movsb
jmp $ - mbrCopyOffset + 2

call videoMode

cmp byte [lastBootPartition], 0
je menuStart
%include "ebem/mbr/auto.asm"

menuStart:
	call videoMode
	mov dx, 0202h
	call cursorPosition

	; print underline
	mov ax, 0ecdh
	mov cx, 12
	.underLine:
		int 10h
		loop .underLine

	mov dx, 0102h
	call cursorPosition

	mov si, partitionString
	call printString

	mov word [bootSector], 5

	.partitionDec4:

	sub word [bootSector], 8

	.partitionInc4:

	add word [bootSector], 4

	.menuLoop:
		mov ax, [bootSector]
		mov word [lastBootPartition], ax

		mov ax, 0xb800
		mov es, ax
		mov bx, 186
		mov ax, [bootSector]
		add ax, "0"
		mov [es:bx], al

		mov ah, 0
		int 16h
		cmp ah, 0x48
		je .partitionInc
		cmp ah, 0x50
		je .partitionDec
		cmp ah, 0x1C
		je autoChooseStart
		.afterKeyPress:

		jmp .menuLoop

		.partitionInc:
			add word [bootSector], 2

		.partitionDec:
			dec word [bootSector]

			cmp word [bootSector], 1
			jl .partitionInc4
			cmp word [bootSector], 4
			jg .partitionDec4

			jmp .menuLoop

; check if partition is active
getPartitionState:
	mov bp, cx
	push cx
	mov cl, 4
	shl bp, cl
	pop cx
	add bp, partitionTableStart - 16
	cmp byte [bp], 0x80
	ret

; printing
printString:
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

; change video mode
videoMode:
	mov ax, 0500h
	int 10h
	mov ax, 3
	int 10h
	ret

cursorPosition:
	mov ah, 2
	xor bh, bh
	int 10h
	ret

%include "ebem/mbr/boot.asm"

; strings
partitionString: db "Partition: ", 0
int10hErrorString: db "Err: 0x", 0
notABootSectorString: db "No.", 0

; fill other bytes with zeros
times 444 - ($ - $$) db 0x00

; variables
lastBootPartition: dw 1

; partition table
partitionTableStart:
	; beef partition
	db 0x80
	db 2
	db 0
	db 0
	db 0xEA
	db 0
	db 0x01
	db 0
	dq 0

	;  empty partitions
	times 48 db 0x00

; boot sector signature
dw 0xaa55