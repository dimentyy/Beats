%define bootSector 0x7C00                           ; address where bs is loaded
%define mbrCopyOffset 1024                           ; bs copy address offset
%define mbrCopyAddress bootSector - mbrCopyOffset   ; bs copy address

org mbrCopyAddress
cpu 8086
bits 16

mov bp, bootSector
mov [bp+2], dx

; copy mbr to new dest
mov di, mbrCopyAddress
mov si, bp
mov cx, 512
rep movsb
jmp $ - mbrCopyOffset + 2

mov ax, 0500h
int 10h
mov ax, 3
int 10h

cmp byte [lastBootPartition], 0
je menuStart
%include "ebem/boot_sector/auto.asm"
%include "ebem/boot_sector/boot.asm"

menuStart:

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
	mov byte [bp], 5

	.partitionDec4:

	sub byte [bp], 8

	.partitionInc4:

	add byte [bp], 4

	.menuLoop:
		mov al, [bp]
		mov byte [lastBootPartition], al

		mov bx, 0xad2d
		mov es, bx
		mov al, [bp]
		add al, "0"
		mov [es:bx+3+186], al

		mov ah, 0
		int 16h
		cmp ah, 0x48
		je .partitionInc
		cmp ah, 0x50
		je .partitionDec
		cmp ah, 0x1C
		je autoChooseStart

		jmp .menuLoop

		.partitionInc:
			add byte [bp], 2

		.partitionDec:
			dec byte [bp]

			cmp byte [bp], 1
			jl .partitionInc4
			cmp byte [bp], 4
			jg .partitionDec4

			jmp .menuLoop

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

cursorPosition:
	mov ah, 2
	xor bh, bh
	int 10h

return:
	ret

; strings
partitionString: db "Partition:", 0
hErrString: db "h err", 0
notABootSectorString: db "Non boot sector", 0
notActive: db "Not active"

; fill other bytes with zeros
times 445 - ($ - $$) db 0x00

; selected partition
; 0     — not selected
; 1 - 4 — auto select
lastBootPartition: db 0

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