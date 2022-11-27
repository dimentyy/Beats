setupMouseDriver:
	; enable mouse port
	mov  al, 0xa8
	out  0x64, al
	call checkPort

	; activate mouse hardware
	mov  al, 0xd4 ; write with mouse instead of keyboard
	out  0x64, al
	call checkPort
	mov  al, 0xf4 ; stream mode
	out  0x60, al
	call checkPort
	call checkMouse

	call getMouseByte
	call checkPort
	call getMouseByte

	ret

	; check if mouse has info
	checkMouse:
		mov bl, 0
		xor cx, cx
		.loop:
			in   al, 0x64
			test al, 1
			jnz  .done
			loop .loop
			mov  bl, 1
		.done:
			ret
		ret