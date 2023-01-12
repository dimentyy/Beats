setupInputDriver:
	call setupMouseDriver
	ret

; check if command is accepted
checkPort:
	xor cx, cx
	.loop:
		in   al, 0x64
		test al, 2
		jz   .done
		jmp  .loop

	.done:
		ret

disableKeyboard:
	mov  al, 0xad
	out  0x64, al
	call checkPort
	ret

enableKeyboard:
	mov  al, 0xae
	out  0x64, al
	call checkPort
	ret

%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats/system/extended_program/input_driver/mouse/setup.asm"
%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats/system/extended_program/input_driver/mouse/get.asm"