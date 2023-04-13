; header
mov dx, 0x0118
call cursorPosition

mov bx, boldTextAttributes
mov si, executeString
call printString
mov si, .headerString
call printString

mov dx, 0x0218
call cursorPosition

; print underline
mov ax, 09cdh
mov bx, boldTextAttributes
mov cx, 13
int 10h

; footer
mov dx, 0x0419
call cursorPosition

mov bx, defaultTextAttributes
mov si, .footerString
call printMultiLineString