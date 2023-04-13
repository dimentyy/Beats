;   888     888      d8b           888
;   888     888      Y8P           888
;   888     888                    888
;   Y88b   d88P      888       .d88888       .d88b.        .d88b.
;    Y88b d88P       888      d88" 888      d8P  Y8b      d88""88b
;     Y88o88P        888      888  888      88888888      888  888
;      Y888P         888      Y88b 888      Y8b.          Y88..88P
;       Y8P          888       "Y88888       "Y8888        "Y88P"

videoMode:
	mov ax, 7
	int 10h

	call videoPage

	xor dx, dx
	call cursorPosition
	; return in next function

clearScreen:
	mov dx, 0
	call cursorPosition
	mov ax, 0900h
	mov bx, defaultTextAttributes
	mov cx, 2000
	int 10h
	mov dx, 0
	call cursorPosition

videoPage:
	mov ax, 500h
	int 10h
	ret

cursorPosition:
	push bx
	mov ah, 2
	xor bh, bh
	int 10h
	pop bx
	ret

invisibleCursor:
	mov ah, 01h
	mov ch, 3fh
	int 10h

defaultCursor:
	mov ah, 01h
	mov ch, 56h
	int 10h

newString:
	mov ah, 0Eh
	mov al, 0Ah
	int 10h
	mov al, 0Dh
	int 10h
	ret


printString:
	push cx
	.loop:
		lodsb
		cmp al, 0
		jz .return

		mov cx, 1
		mov ah, 09h
		int 10h

		mov ah, 03h
		int 10h
		inc dl
		xor ax, ax
		mov ah, 02h
		int 10h

		jmp .loop

	.return:
		pop cx
		ret

printMultiLineString:
	mov ah, 3
	xor bh, bh
	int 10h

	push dx

	mov ax, 0xb800
	mov es, ax

	.loop:
		lodsb
		cmp al, 0
		jz .return

		cmp al, 0x0D
		je .changeCursorPosition

		mov cx, 1
		mov ah, 09h
		int 10h

		mov ah, 03h
		int 10h
		inc dl
		mov ah, 02h
		int 10h

		jmp .loop

		.changeCursorPosition:
			pop dx
			inc dh
			push dx
			call cursorPosition
			jmp .loop

		.return:
			pop dx
			ret

;   888b     d888                    d8b
;   8888b   d8888                    Y8P
;   88888b.d88888
;   888Y88888P888       8888b.       888      88888b.
;   888 Y888P 888          "88b      888      888 "88b
;   888  Y8P  888      .d888888      888      888  888
;   888   "   888      888  888      888      888  888
;   888       888      "Y888888      888      888  888
;
;
;
;   888b     d888
;   8888b   d8888
;   88888b.d88888
;   888Y88888P888       .d88b.       88888b.       888  888
;   888 Y888P 888      d8P  Y8b      888 "88b      888  888
;   888  Y8P  888      88888888      888  888      888  888
;   888   "   888      Y8b.          888  888      Y88b 888
;   888       888       "Y8888       888  888       "Y88888

getMainMenuStringAddress:
	xor ax, ax
	mov al, [mainMenuStringAddresses + si]
	mov si, ax
	add si, mainMenuStringAddresses

	ret

printMainMenuString:
	mov dx, 0x0304
	add dh, cl
	call cursorPosition

	; string number
	mov si, cx
	dec si

	; print string
	call getMainMenuStringAddress
	call printString

	ret

printMainMenuSelectedString:
	mov bx, highlightedTextAttributes
	mov cl, [mainMenuSelectedOption]
	call printMainMenuString
	ret


; menus

menuFullSelectionUpdate:
	push dx
	push di

	; clear selection
	mov di, .afterClearing
	call si

	.afterClearing:

	; update selection
	pop di
	pop dx
	jmp drawSelection