%define bootSector 0x7c00

org bootSector

mov [bootDrive], dl

mov al, 3
mov ah, 2h
mov bx, bootSector + 512
mov cx, 3
mov dl, [bootDrive]
mov dh, 0
int 13h

jmp system

bootDrive equ 0x00

;%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats/system/extended_program/input_driver/setup.asm"
;%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats/system/extended_program/custom_interrupts.asm"

times 510-($-$$) db 0
dw 0xaa55

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

times 512*4-($-$$) db 0