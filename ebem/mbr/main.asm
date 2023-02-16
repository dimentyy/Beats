%define bootSector 0x7C00                           ; address where mbr is loaded
%define mbrCopyOffset 1024                          ; mbr copy address offset
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
mov ah, 1
mov cx, 2607h
int 10h

cmp byte [lastBootPartition], 0
je menuStart
%include "ebem/mbr/auto.asm"

menuStart:
	mov ah, 02h
	mov bh, 0
	mov dl, 2
	mov dh, 1
	int 10h

	mov si, partitionString
	call printString

	; print underline
	mov ax, 0ecdh
	mov cx, 13
	.underLine:
		int 10h
		loop .underLine

	menuLoop:


		jmp menuLoop

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

%include "ebem/mbr/boot.asm"

; strings
partitionString: db "Partition: ", 0x0d, 0x0a, "  ", 0
int10hErrorString: db "Int13h error: 0x", 0
notABootSectorString: db "Not a bootable sector", 0

; fill other bytes with zeros
times 445 - ($ - $$) db 0x00

; variables
lastBootPartition: db 1

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