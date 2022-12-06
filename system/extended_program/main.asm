%define bootSector 0x7c00
org bootSector

cpu 8086

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

cpu 8086

mov ax, 2
int 10h

system:
	mov ah, 02h
	mov bh, 0
	mov dx, 0000h
	int 10h

	.loop:
		mov ah, 00h
		int 16h
		mov bl, 0x07
		mov ah, 0x0e
		int 10h
		jmp .loop

times 512*7-($-$$) db 0