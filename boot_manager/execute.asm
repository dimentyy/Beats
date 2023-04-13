executeMenu:
	; first draw
	mov dx, 0x0118
	call cursorPosition

	mov bx, defaultTextAttributes
	mov si, executeString
	call printString
	mov si, .executeHeaderString
	call printString

	mov dx, 0x0218
	call cursorPosition

	; print underline
	mov ax, 09cdh
	mov bx, defaultTextAttributes
	mov cx, 13
	int 10h

	; cursor position
	mov dx, 0x0419
	call cursorPosition

	mov bx, defaultTextAttributes
	mov si, .executeFooterString
	call printMultiLineString

	; first draw END

	.afterKeyPress:

	mov si, .afterFullSelectionUpdate
	jmp .fullSelectionUpdate

	.afterFullSelectionUpdate:

	mov si, .executeMenuControl
	jmp menuControl

	.rightArrowKeyPress:
		add byte [.selectionNumber], 2

	.leftArrowKeyPress:
		dec byte [.selectionNumber]

		cmp byte [.selectionNumber], 10
		jle .skipSelection10set
		mov byte [.selectionNumber], 10
		.skipSelection10set:

		cmp byte [.selectionNumber], 0
		jg .skipSelection1set
		mov byte [.selectionNumber], 1
		.skipSelection1set:

		jmp .afterKeyPress

	.upArrowKeyPress:
		mov al, 1

	.downArrowKeyPress:
		cmp al, 1
		je .afterAlZero
			xor al, al
		.afterAlZero:

		cmp byte [.selectionNumber], 1
		jne .notCallOrJumpSelection
			xor byte [.callOrJumpChoice], 1 ; only two values - 0 or 1 - call or jump
			jmp .notOffsetSelection
		.notCallOrJumpSelection:
		cmp byte [.selectionNumber], 5
		jg .notSegmentSelection
			mov bl, -2
			mov di, .segmentChoice
			jmp .memoryKeyPressChange

		.notSegmentSelection:
		cmp byte [.selectionNumber], 9
		jg .notOffsetSelection
	        mov bl, -6
	        mov di, .offsetChoice
	        jmp .memoryKeyPressChange
		.notOffsetSelection:
		.afterUpDownKeyPress:
		jmp .afterKeyPress

	.returnKeyPress:
		cmp byte [.selectionNumber], 10
		je .okPress
		mov byte [.selectionNumber], 10
		jmp .afterKeyPress

	.escapeKeyPress:
		mov si, mainMenuLoop
		jmp .clearSelection

	.fullSelectionUpdate:
		push si

		; clear selection
		mov si, .afterClearing
		jmp .clearSelection

		.afterClearing:

		; update selection
		pop si
		jmp .drawSelection

	.drawSelection:
		mov bx, underlinedTextAttributes
		mov dh, [.selectionNumber]
		jmp .selectionDrawUnified

	.clearSelection:
		; update last selection number
		mov dl, [.selectionNumber]
		mov dh, [.lastSelectionNumber]
		mov byte [.lastSelectionNumber], dl

		mov bx, defaultTextAttributes
		jmp .selectionDrawUnified

	.selectionDrawUnified:
		cmp dh, 1
		je .callOrJump
		cmp dh, 5
		jle .segment
		cmp dh, 9
		jle .offset
		cmp dh, 10
		je .okDraw
		jmp si

	; -bl = offset
	; di = segment or offset choice
	.memoryKeyPressChange:
		xor ah, ah
		mov dl, al
		add ax, ax
		dec ax

		add bl, [.selectionNumber]
		xor bl, 3

		mov cl, 2
		shl bl, cl
		mov cl, bl
		mov bx, ax
		shl bx, cl

		mov ax, [di]
		shr ax, cl
		and al, 0x0f

		cmp al, 0
		jnz .not0
			cmp dl, 0
			jz .afterUpDownKeyPress
		.not0:

		cmp al, 0x0F
		jne .notF
			cmp dl, 1
			je .afterUpDownKeyPress
		.notF:

		add [di], bx
		jmp .afterUpDownKeyPress


	;   8888888b.                                                     d8b
    ;   888  "Y88b                                                    Y8P
    ;   888    888
    ;   888    888      888d888       8888b.       888  888  888      888      88888b.        .d88b.
    ;   888    888      888P"            "88b      888  888  888      888      888 "88b      d88P"88b
    ;   888    888      888          .d888888      888  888  888      888      888  888      888  888
    ;   888  .d88P      888          888  888      Y88b 888 d88P      888      888  888      Y88b 888
    ;   8888888P"       888          "Y888888       "Y8888888P"       888      888  888       "Y88888
    ;                                                                                             888
    ;                                                                                        Y8b d88P
    ;                                                                                         "Y88P"


	.callOrJump:
		push si
		push bx
		mov dx, 0x0b19
		call cursorPosition

		mov si, .callString
		cmp byte [.callOrJumpChoice], 1
		jz .notJump
			mov si, .jumpString
		.notJump:
		pop bx
		call printString
		pop si
		jmp si

	.segment:
		mov dl, dh
		sub dl, 2
		mov ax, [.segmentChoice]
		jmp .memoryDraw

	.offset:
		mov dl, dh
		sub dl, 6
		add dh, 5
		mov ax, [.offsetChoice]
		jmp .memoryDraw

	.memoryDraw:
		push si
		push ax
		push dx
		push bx
		mov dl, dh
		xor dh, dh
		add dx, 0x0b1e
		call cursorPosition

		pop bx
		pop dx

		xor dl, 3
		mov cl, 2
		shl dl, cl


		mov cl, dl
		pop ax
		shr ax, cl
		and al, 0x0f

		call debugNibble

		pop si
		jmp si

	.okDraw:
		push si
		mov dx, 0x0b30
		call cursorPosition
		mov si, .okString
		call printString
		pop si
		jmp si

	.okPress:
		mov dx, 0x0d18
		call cursorPosition
		mov bx, 129
		mov si, .beCarefullyHeader
		call printMultiLineString
		mov dx, 0x0e1a
		call cursorPosition
		mov bx, defaultTextAttributes
		mov si, .beCarefullyFooter
		call printMultiLineString
		jmp $


	;   888b    888                    888                                                    888
    ;   8888b   888                    888                                                    888
    ;   88888b  888                    888                                                    888
    ;   888Y88b 888       .d88b.       888888                 .d8888b       .d88b.        .d88888       .d88b.
    ;   888 Y88b888      d88""88b      888                   d88P"         d88""88b      d88" 888      d8P  Y8b
    ;   888  Y88888      888  888      888                   888           888  888      888  888      88888888
    ;   888   Y8888      Y88..88P      Y88b.                 Y88b.         Y88..88P      Y88b 888      Y8b.
    ;   888    Y888       "Y88P"        "Y888                 "Y8888P       "Y88P"        "Y88888       "Y8888

	.executeMenuControl:
		dw .upArrowKeyPress
		dw .downArrowKeyPress
		dw .returnKeyPress
		dw .escapeKeyPress
		dw .leftArrowKeyPress
		dw .rightArrowKeyPress

	.executeHeaderString: db " menu:", 0x00
	.executeFooterString: db   "Execute code in 20-bit address", 0x0D, "Action Segment : Offset", 0x0D, 0x0D, 0x1b, 0x1a, " to select", 0x0D, 0x19, 0x18, " to change value", 0x0D, "Enter to execute", 0x0D, 0x0D, "Jump 0x0000 : 0x7C00   <OK>", 0x00
	.beCarefullyHeader: db "Please, be carefully.", 0x00
	.beCarefullyFooter: db "Executing corrupted code or", 0x0D, "code at wrong memory address", 0x0D, "may work differently or", 0x0D, "be harmful for Your computer", 0x00
	.callString: db "Call", 0x00
	.jumpString: db "Jump", 0x00
	.okString: db "<OK>", 0x00

	.selectionNumber: db 1
	.lastSelectionNumber: db 1
	.callOrJumpChoice: db 0
	.segmentChoice: dw 0x0000
	.offsetChoice: dw 0x7C00