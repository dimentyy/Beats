%define mainMenuChoose 0x2000

%define bootSector 0x7c00
org 0x1000
cpu 8086

mainMenu:
	mainMenuStart:
		mov si, matviCoolksBootManagerOptionsString
		mov bx, 7
		call printString
		call newString

		call newString

		mov cx, 5
		.stringLoop:
			mov si, 5
			sub si, cx
			push cx
			call printMainMenuString
			pop cx
			loop .stringLoop

	mainMenuLoop:
		.waitForKeys:
			mov ah, 0x00
			int 16h
			cmp al, "1"
			jge .jge1
			jmp .waitForKeys

			.jge1:
				cmp al, "5"
				jg .waitForKeys

		mov bp, mainMenuChoose + 0x1000
		sub al, "1"
		mov [bp], al
		mov si, [bp]
		call printMainMenuString

		jmp mainMenuLoop

printMainMenuString:
	xor ax, ax
	mov al, [stringAddresses + si]
	mov si, ax
	add si, stringAddresses

	mov bx, 7

	call printString
	call newString
	ret

jmp $

%include "ebem/video.asm"

stringAddresses:
	db -stringAddresses + loadSectorsFromDriveString
	db -stringAddresses + writeSectorsToDriveString
	db -stringAddresses + moveSomethingInMemoryString
	db -stringAddresses + callSomethingInMemoryString
	db -stringAddresses + jumpSomewhereInMemoryString

matviCoolksBootManagerOptionsString:    db "MatviCoolk's Boot Manager options:", 0x00
loadSectorsFromDriveString:     db "1. Load sectors from drive", 0x00
writeSectorsToDriveString:      db "2. Write sectors to drive", 0x00
moveSomethingInMemoryString:    db "3. Move something in memory", 0x00
callSomethingInMemoryString:    db "4. Call something in memory", 0x00
jumpSomewhereInMemoryString:    db "5. Jump somewhere in memory", 0x00

loadOffset: dw 0x1000

times 512 * 16 - ($-$$) db 0