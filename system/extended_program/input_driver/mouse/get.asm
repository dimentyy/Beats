getMouse:
	pusha

	getMouseByte1:
		call getMouseByte
		xor  ah, ah
		mov  byte [mouseByte1], al

	getMouseByte2:
		call getMouseByte
		xor  ah, ah
		mov  byte [mouseByte2], al

	getMouseByte3:
		call getMouseByte
		xor  ah, ah
		mov  byte [mouseByte3], al

	additionalVars:
		mov al, [mouseByte2]
		mov bl, [mouseByte3]
		mov dl, [mouseByte1]

		mov cl, dl
		and cl, 16
		cmp cl, 16

		jne .subX
		neg al
		sub word [mouseX], ax
		.subX:

		mov cl, dl
		and cl, 16
		cmp cl, 16

		je .addX
		add word [mouseX], ax
		.addX:

		mov cl, dl
		and cl, 32
		cmp cl, 32

		je .subY
		neg bl
		sub word [mouseY], bx
		.subY:

		mov cl, dl
		and cl, 32
		cmp cl, 32

		jne .addY
		add word [mouseY], bx
		.addY:

	popa
	ret

; get mouse byte from ps/2 port
getMouseByte:
	.loop:
		call checkMouse
		or   bl, bl
		jnz  .loop
		call disableKeyboard
		xor  ax, ax
		in   al, 0x60
		mov  dl, al
		call enableKeyboard
		mov  al, dl
		jmp .done

	.done:
		ret

; variables
mouseByte1 db 0x00
mouseByte2 db 0x00
mouseByte3 db 0x00
mouseX db word 0x0000
mouseY db word 0x0000