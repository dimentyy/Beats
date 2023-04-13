executeMenu:
	; start
	%include "boot_manager/execute/start.asm"

	.afterKeyPress:
		mov si, .afterFullSelectionUpdate
		jmp menuFullSelectionUpdate

		.afterFullSelectionUpdate:

		mov si, .executeMenuControl
		jmp menuControl

	; arrows key presses
	%include "boot_manager/execute/arrows.asm"

	.returnKeyPress:
		cmp byte [.finalWarningState], 1
		je .finalWarningReturnKeyPress
			cmp byte [.selectionNumber], 10
			je .okPress
			mov byte [.selectionNumber], 10
			jmp .afterKeyPress
		.finalWarningReturnKeyPress:
			cmp byte [.finalWarningChoice], 1
			je .okAborted

	.okConfirmed:
		call clearScreen
		cmp byte [.callOrJumpChoice], 0
		je .jump

		.jump:
			mov bx, [.segmentChoice]
			mov es, bx
			mov bx, [.offsetChoice]
			jmp [es:bx]


	.okDraw:
		push si
		mov dx, 0x0b30
		call cursorPosition
		mov si, .okString
		call printString
		pop si
		jmp si

	.beCarefullyDraw:
		push bx
		push ax
		mov dx, 0x0d1d
		call cursorPosition
		pop bx
		mov si, .beCarefullyHeader
		call printMultiLineString
		mov dx, 0x0e1a
		call cursorPosition
		pop bx
		mov si, .beCarefullyFooter
		call printMultiLineString
		ret

	.okPress:
		mov ax, 129
		mov bx, defaultTextAttributes
		call .beCarefullyDraw

		mov byte [.finalWarningState], 1
		mov byte [.finalWarningChoice], 1

		mov cx, 0
		call .drawCancelExecuteButtons

		jmp .afterKeyPress

	; go back to main menu
	.escapeKeyPress:
		cmp byte [.finalWarningState], 1
		je .finalWarningEscapeKeyPress
			mov si, mainMenuLoop
			jmp .clearSelection
		.finalWarningEscapeKeyPress:

	.okAborted:
		xor ax, ax
		xor bx, bx
		call .beCarefullyDraw
		mov cx, 16
		call .drawCancelExecuteButtons
		mov byte [.finalWarningState], 0
		jmp .afterKeyPress




	; drawing
	%include "boot_manager/execute/drawing.asm"

	; not code
	%include "boot_manager/execute/not_code.asm"