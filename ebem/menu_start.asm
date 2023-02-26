; video mode
mov ax, 7
int 10h

; invisible cursor
mov ah, 01h
mov ch, 3fh
int 10h

; cursor position
mov dx, 0x0102
call cursorPosition

; print string
mov si, ebemOptionsString
mov bx, 7
call printString
call newString

; cursor position
mov dx, 0x0202
call cursorPosition

; print underline
mov ax, 0ecdh
mov cx, 13
.underLine:
	int 10h
	loop .underLine

mov cx, numberOfOptions
mov byte [mainMenuChoose], numberOfOptions
.stringLoop:
	; set cursor position
	mov dx, 0x0304
	add dh, [mainMenuChoose]
	call cursorPosition

	dec byte [mainMenuChoose]

	mov si, cx
	dec si
	push cx
	mov bx, 7
	call printMainMenuString
	pop cx
	loop .stringLoop