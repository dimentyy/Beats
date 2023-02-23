; video mode
mov ax, 7
int 10h

; invisible cursor
mov ah, 01h
mov ch, 3fh
int 10h

; cursor position
mov ah, 02h
xor bh, bh
mov dx, 0x0102
int 10h

; print string
mov si, ebemOptionsString
mov bx, 7
call printString
call newString

; cursor position
mov ah, 02h
xor bh, bh
mov dx, 0x0202
int 10h

; print underline
mov ax, 0ecdh
mov cx, 13
.underLine:
	int 10h
	loop .underLine

mov cx, numberOfOptions
mov byte [mainMenuChoose + 0x1000], numberOfOptions
.stringLoop:
	; set cursor position
	mov ah, 02h
	mov bh, 0
	mov dx, 0x0304
	add dh, [mainMenuChoose + 0x1000]
	int 10h

	dec byte [mainMenuChoose + 0x1000]

	mov si, cx
	dec si
	push cx
	mov bx, 7
	call printMainMenuString
	pop cx
	loop .stringLoop