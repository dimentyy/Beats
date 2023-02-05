%define mainMenuChoose 0x2000
%define bootSector 0x7c00
%define numberOfOptions 4
org 0x1000
cpu 8086

mainMenu:
	mainMenuStart:
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
		mov dx, 0x0101
		int 10h

		; print string
		mov si, ebemOptionsString
		mov bx, 7
		call printString
		call newString

		; cursor position
		mov ah, 02h
		xor bh, bh
		mov dx, 0x0201
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
			mov dx, 0x0303
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

	mainMenuLoop:
		.showSelectedOption:
			mov ah, 02h
			mov bh, 0
			mov dl, 3
			mov dh, [mainMenuChoose + 0x1000]
			add dh, 4
			int 10h

			mov bx, 7 * 16
			mov si, [mainMenuChoose + 0x1000]
			call printMainMenuString + $$ + 0x1000

		.waitForKeyPress:
			mov ah, 0x00
			int 16h
			push ax
			cmp ah, 0x48
			je .arrowUpKeyPress
			cmp ah, 0x50
			je .arrowDownKeyPress
			cmp al, 0x0D
			je .returnKeyPress
			jmp .waitForKeyPress

		.arrowKeyPress:
			mov ah, 02h
			mov bh, 0
			mov dl, 3
			mov dh, [mainMenuChoose + 0x1000]
			add dh, 4
			int 10h

			mov bx, 7
			mov si, [mainMenuChoose + 0x1000]
			call printMainMenuString
			ret

		.arrowUpKeyPress:
			call .arrowKeyPress
			dec byte [mainMenuChoose + 0x1000]
			jmp .afterKeyPress

		.arrowDownKeyPress:
			call .arrowKeyPress
			inc byte [mainMenuChoose + 0x1000]
			jmp .afterKeyPress

		.afterKeyPress:
			pop ax
			.noAx:
			cmp byte [mainMenuChoose + 0x1000], numberOfOptions
			jge .decreaseBy5Choose
			cmp byte [mainMenuChoose + 0x1000], 0
			jl .increaseBy5Choose

		jmp mainMenuLoop

		.returnKeyPress:
			jmp $

		.decreaseBy5Choose:
			sub byte [mainMenuChoose + 0x1000], numberOfOptions
			jmp .noAx

		.increaseBy5Choose:
			add byte [mainMenuChoose + 0x1000], numberOfOptions
			jmp .noAx

printMainMenuString:
	xor ax, ax
	mov al, [stringAddresses + si]
	mov si, ax
	add si, stringAddresses

	call printString

	ret

jmp $

%include "ebem/video.asm"
%include "ebem/debug.asm"

stringAddresses:
	db -stringAddresses + loadString
	db -stringAddresses + writeString
	db -stringAddresses + moveString
	db -stringAddresses + executeString

ebemOptionsString:    db "EBeM options:", 0x00
loadString:    db "1. Load", 0x00
writeString:    db "2. Write", 0x00
moveString:     db "3. Move", 0x00
executeString:  db "4. Execute", 0x00

loadOffset: dw 0x1000

times 512 * 16 - ($-$$) db 0