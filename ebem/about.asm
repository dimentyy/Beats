mov ah, 02h
mov bh, 0
mov dx, 0x0115
int 10h

mov bx, 7
mov si, aboutString
call printString
mov si, aboutHeaderString
call printString

; cursor position
mov ah, 02h
xor bh, bh
mov dx, 0x0215
int 10h

; print underline
mov ax, 0ecdh
mov cx, 14
.underLine:
	int 10h
	loop .underLine

; cursor position
mov dx, 0x0416
call cursorPosition

mov bx, 7
mov si, aboutFooterString
call printMenuString