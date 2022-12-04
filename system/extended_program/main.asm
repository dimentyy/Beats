%define bootSector 0x7c00
org bootSector

mov ax, 0x0206
mov bx, bootSector + 512
mov cx, 3
mov dl, 0
mov dh, 0
int 13h

jmp bootSector + 512

;%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats/system/extended_program/input_driver/setup.asm"
;%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats/system/extended_program/custom_interrupts.asm"

times 510-($-$$) db 0
dw 0xaa55

mov ax, 3
int 10h

mov ax, 0x0103
mov cx, 0x0007
int 10h

system:
	mov ah, 02h
	mov bh, 0
	mov dx, 1701h
	int 10h

	.loop:
		.waitForKeyPress:
			mov si, .keyPressed
			call keyPress

			jmp .waitForKeyPress

			.keyPressed:
				cmp al, 0x0d
				je .return

				mov ah, 0x0e
				int 10h

				mov bx, 0
				mov cx, 0
				mov dx, 0
				mov ax, 0x0c8f
				int 10h

				ret

		.done:
			ret

		jmp .loop

		.return:
			mov al, 1
			mov ah, 06h
			mov bh, 0x07
			mov cx, 0x0000
			mov dx, 0xffff
			int 10h
			mov ah, 02h
			mov bh, 0
			mov dx, 1701h
			int 10h
			ret

keyPress:
	; si - call if key has pressed

	mov ah, 11h
	int 16h

	jz .noKeyPress

	mov ah, 10h
	int 16h

	call si

	.noKeyPress:
		ret

times 512*7-($-$$) db 0