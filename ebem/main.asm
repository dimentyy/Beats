%define mainMenuChoose 0x2000
%define bootSector 0x7c00
%define numberOfOptions 5
org 0x1000
cpu 8086

mainMenu:
	mainMenuStart:
		%include "ebem/menu_start.asm"

	mainMenuLoop:
		.showSelectedOption:
			mov ah, 02h
			mov bh, 0
			mov dl, 4
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

		.afterKeyPress:
			pop ax
			.noAx:

		jmp mainMenuLoop

		.returnKeyPress:

		cmp byte [mainMenuChoose + 0x1000], 4
		je .about

		.load:
		.write:
		.move:
		.execute:

		jmp mainMenuLoop

		.about:
			%include "ebem/about.asm"

		jmp mainMenuLoop

		.arrowUpKeyPress:
			call .arrowKeyPress
			cmp byte [mainMenuChoose + 0x1000], 0
			jle .afterKeyPress
			dec byte [mainMenuChoose + 0x1000]
			jmp .afterKeyPress

		.arrowDownKeyPress:
			call .arrowKeyPress
			cmp byte [mainMenuChoose + 0x1000], numberOfOptions - 1
			jge .afterKeyPress
			inc byte [mainMenuChoose + 0x1000]
			jmp .afterKeyPress

		.arrowKeyPress:
			mov ah, 02h
			mov bh, 0
			mov dl, 4
			mov dh, [mainMenuChoose + 0x1000]
			add dh, 4
			int 10h

			mov bx, 7
			mov si, [mainMenuChoose + 0x1000]
			call printMainMenuString
			ret

jmp $

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

aboutHeaderString: db " EBeM v3:", 0x00
aboutFooterString: db   "Creation of @MatviCoolk", 0x0D, 0x0D, "Boot Manager from", 0x0D, "22.09 to 23.02", 0x0D, 0x0D, 0x0D, "Thank you for attention! ", 0x03, 0x00

executeHeaderString: db "Execute menu:"

loadOffset: dw 0x1000

times 512 * 16 - ($-$$) db 0