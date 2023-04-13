aboutMenu:
	mov dx, 0x0118
	call cursorPosition

	mov bx, boldTextAttributes
	mov si, aboutString
	call printString
	mov si, .aboutHeaderString
	call printString

	; cursor position
	mov dx, 0x0218
	call cursorPosition

	; print underline
	mov ax, 09cdh
	mov bx, boldTextAttributes
	mov cx, 21
	int 10h

	; cursor position
	mov dx, 0x0419
	call cursorPosition

	mov bx, defaultTextAttributes
	mov si, .aboutFooterString
	call printMultiLineString
	mov bx, boldTextAttributes
	call printMultiLineString
	mov dx, 0x0619
	call cursorPosition
	mov bx, boldTextAttributes
	call printMultiLineString
	mov bx, defaultTextAttributes
	call printMultiLineString

	jmp mainMenuLoop

	.aboutHeaderString: db " BootManager b5:", 0x00
	.aboutFooterString: db   "Creation of ", 0x00, "@MatviCoolk", 0x00, "Beats Boot Manager", 0x0D, 0x00, " Build 5, 23.03", 0x0D, 0x0D, 0x0D, "Thank you for attention! ", 0x03, 0x00 ; 0x03 - heart