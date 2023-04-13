%define numberOfOptions 5
%define numberOfMenuActions 6
%define defaultTextAttributes 2
%define boldTextAttributes 10
%define underlinedTextAttributes 113
%define highlightedTextAttributes 112

%define upArrowKeyPress 0x48
%define arrowDownKeyPress 0x50
%define returnKeyPress 0x0D
%define escapeKeyPress 0x01
%define leftArrowKeyPress 0x4B
%define rightArrowKeyPress 0x4D

%define bootSector 0x7c00
org 0x6000
cpu 8086

start:
	call mainMenuDraw

mainMenuLoop:
	mov si, mainMenuControl
	jmp menuControl

	.afterKeyPress:

	call mainMenuDraw.drawStrings

	jmp mainMenuLoop

	.returnKeyPress:
		call mainMenuDraw

		jmp mainMenuJumps

	.upArrowKeyPress:
		call .arrowKeyPress
		cmp byte [mainMenuSelectedOption], 1
		jle .afterKeyPress
		dec byte [mainMenuSelectedOption]
		jmp .afterKeyPress

	.arrowDownKeyPress:
		call .arrowKeyPress
		cmp byte [mainMenuSelectedOption], numberOfOptions
		jge .afterKeyPress
		inc byte [mainMenuSelectedOption]
		jmp .afterKeyPress

	.arrowKeyPress:
		ret

mainMenuJumps:
	cmp byte [mainMenuSelectedOption], 2
	jl loadWriteMenu
	je moveMenu

	cmp byte [mainMenuSelectedOption], 4
	jl executeMenu
	je aboutMenu

jmp start

menuControl:
	mov cx, numberOfMenuActions
	mov di, selectedMenuControl + 1

	xor ax, ax

	.setupLoop:
		add ax, 3

		mov dx, [si]
		sub dx, ax
		sub dx, selectedMenuControl
		mov [di], dx

		add di, 3 ; copy to     address
		add si, 2 ; copy from   address

		loop .setupLoop

	; wait for key presses
	.loop:
		mov ah, 0x00
		int 16h
		cmp ah, upArrowKeyPress
		je selectedMenuControl + 0
		cmp ah, arrowDownKeyPress
		je selectedMenuControl + 3
		cmp al, returnKeyPress
		je selectedMenuControl + 6
		cmp ah, escapeKeyPress
		je selectedMenuControl + 9
		cmp ah, leftArrowKeyPress
		je selectedMenuControl + 12
		cmp ah, rightArrowKeyPress
		je selectedMenuControl + 15
		jmp .loop

selectedMenuControl:
	jmp 0x0000 ; up arrow
	jmp 0x0000 ; down arrow
	jmp 0x0000 ; return
	jmp 0x0000 ; escape
	jmp 0x0000 ; left arrow
	jmp 0x0000 ; right arrow

mainMenuControl:
	dw mainMenuLoop.upArrowKeyPress
	dw mainMenuLoop.arrowDownKeyPress
	dw mainMenuLoop.returnKeyPress
	dw mainMenuLoop
	dw mainMenuLoop.upArrowKeyPress
	dw mainMenuLoop.arrowDownKeyPress

; menus
%include "boot_manager/load_write/main.asm"
%include "boot_manager/move.asm"
%include "boot_manager/execute/main.asm"
%include "boot_manager/about.asm"

; other stuff
%include "boot_manager/debug.asm"
%include "boot_manager/video.asm"
%include "boot_manager/strings.asm"
%include "boot_manager/variables.asm"
%include "boot_manager/functions.asm"
%include "boot_manager/main_menu_draw.asm"

times 512 * 16 - ($ - $$) db 0x00