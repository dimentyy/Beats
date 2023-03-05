%define bootSector 0x7c00
%define numberOfOptions 5
org 0x1000
cpu 8086

mainMenu:
	mainMenuStart:
		%include "ebem/menu_start.asm"

	mainMenuLoop:
		.showSelectedOption:
			mov dx, 0404h
			add dh, [mainMenuChoose]
			call cursorPosition

			mov bx, 7 * 16
			mov si, [mainMenuChoose]
			call printMainMenuString

		mov si, mainMenuControl
		jmp menuControl

		.afterKeyPress:

		jmp mainMenuLoop

		.returnKeyPress:

		cmp word [mainMenuChoose], 1
		jl .load
		je .write

		cmp word [mainMenuChoose], 3
		jl .move
		je .execute
		jg .about

		.load:
		.write:
		.move:
		.execute:

		.about:
			%include "ebem/about.asm"

		jmp mainMenuLoop

		.arrowUpKeyPress:
			call .arrowKeyPress
			cmp byte [mainMenuChoose], 0
			jle .afterKeyPress
			dec byte [mainMenuChoose]
			jmp .afterKeyPress

		.arrowDownKeyPress:
			call .arrowKeyPress
			cmp byte [mainMenuChoose], numberOfOptions - 1
			jge .afterKeyPress
			inc byte [mainMenuChoose]
			jmp .afterKeyPress

		.arrowKeyPress:
			mov dx, 0404h
			add dh, [mainMenuChoose]
			call cursorPosition

			mov bx, 7
			mov si, [mainMenuChoose]
			call printMainMenuString
			ret

jmp $

menuControl:
	;mov di, menuControlChoose
	;mov cx, 5
	;rep movsw

	mov cx, 3

	mov di, menuControlChoose + 1

	.setupLoop:
		mov dx, [si]
		mov [di], dx

		add di, 3
		add si, 2
		loop .setupLoop

	mov ax, 3
	mov cx, 3
	mov si, menuControlChoose
	;call debugMemory

	.loop:
		mov ah, 0x00
		int 16h
		push ax
		cmp ah, 0x48
		je menuControlChoose
		cmp ah, 0x50
		je menuControlChoose + 3
		cmp al, 0x0D
		je menuControlChoose + 6
		jmp .loop

mainMenuControl:
	dw mainMenuLoop.arrowUpKeyPress - menuControlChoose - 3
	dw mainMenuLoop.arrowDownKeyPress - menuControlChoose - 6
	dw mainMenuLoop.returnKeyPress - menuControlChoose - 9

%include "ebem/video.asm"
%include "ebem/debug.asm"

stringAddresses:
	db -stringAddresses + loadString
	db -stringAddresses + writeString
	db -stringAddresses + moveString
	db -stringAddresses + executeString
	db -stringAddresses + aboutString

ebemOptionsString:    db "EBeM options:", 0x00
loadString:     db "Load", 0x00
writeString:    db "Write", 0x00
moveString:     db "Move", 0x00
executeString:  db "Execute", 0x00
aboutString:    db "About", 0x00

aboutHeaderString: db " EBeM v4:", 0x00
aboutFooterString: db   "Creation of @MatviCoolk", 0x0D, 0x0D, "Boot Manager from", 0x0D, "22.09 to 23.02", 0x0D, 0x0D, 0x0D, "Thank you for attention! ", 0x03, 0x00

executeHeaderString: db "Execute menu:"

mainMenuChoose: dw 0

menuControlChoose:
	jmp 0x0000
	jmp 0x0000
	jmp 0x0000

times 512 * 8 - ($-$$) db 0