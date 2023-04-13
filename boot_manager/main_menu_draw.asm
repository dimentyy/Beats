;   888b     d888          d8b               888b     d888
;   8888b   d8888          Y8P               8888b   d8888
;   88888b.d88888                            88888b.d88888
;   888Y88888P888  8888b.  888 88888b.       888Y88888P888  .d88b.  88888b.  888  888
;   888 Y888P 888     "88b 888 888 "88b      888 Y888P 888 d8P  Y8b 888 "88b 888  888
;   888  Y8P  888 .d888888 888 888  888      888  Y8P  888 88888888 888  888 888  888
;   888   "   888 888  888 888 888  888      888   "   888 Y8b.     888  888 Y88b 888
;   888       888 "Y888888 888 888  888      888       888  "Y8888  888  888  "Y88888
;
;
;
;   8888888b.
;   888  "Y88b
;   888    888
;   888    888      888d888       8888b.       888  888  888
;   888    888      888P"            "88b      888  888  888
;   888    888      888          .d888888      888  888  888
;   888  .d88P      888          888  888      Y88b 888 d88P
;   8888888P"       888          "Y888888       "Y8888888P"

mainMenuDraw:
	call clearScreen
;	call invisibleCursor

	; cursor position
	mov dx, 0x0102
	call cursorPosition

	mov si, ebemOptionsString
	mov bx, boldTextAttributes
	call printString

	; cursor position
	mov dx, 0x0202
	call cursorPosition

	; print underline
	mov ax, 09cdh
	mov bx, boldTextAttributes
	mov cx, 16
	int 10h

	.drawStrings:
		mov cx, numberOfOptions
		.stringLoop:
			mov bx, defaultTextAttributes
			call printMainMenuString

			loop .stringLoop


		jmp printMainMenuSelectedString
		; return in line above