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


.drawSelection:

	mov bx, underlinedTextAttributes
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
	je .callOrJumpDraw
	cmp dh, 9
	jle .segmentOffset
	jmp .okDraw

.callOrJumpDraw:
	push si
	push bx
	mov dx, 0x0b19
	call cursorPosition

	mov si, .callString
	cmp byte [.callOrJumpChoice], 1
	je .notJump
		mov si, .jumpString
	.notJump:
	pop bx
	call printString
	pop si
	jmp si

.segmentOffset:
	mov ax, [.segmentChoice]
	mov dl, dh
	cmp dh, 5
	jle .notOffset
	add dx, -4 * 256 + 5
	mov ax, [.offsetChoice]
	.notOffset:

.memoryDraw:
	; push everything
	push si
	push ax
	push dx

	xor dh, dh
	add dx, 0x0b1e      ; calculate address
	call cursorPosition

	pop dx

	sub dh, 2           ; because first segment nibble choice is number 2
	xor dh, 3           ; reverse
	mov cl, 2
	shl dh, cl          ; multiply by 4
	mov cl, dh

	pop ax              ; restore segment / offset
	shr ax, cl          ; shift value to get correct nibble in low half of al
	and al, 0x0f        ; get low nibble from byte
	call debugNibble    ; draw nibble

	pop si
	jmp si

.drawCancelExecuteButtons:
	push cx
	push cx
	mov dx, 0x131e
	call cursorPosition
	mov bx, defaultTextAttributes
	cmp byte [.finalWarningChoice], 2
	je .afterUnderlineCancelButtonSet
		mov bx, underlinedTextAttributes
	.afterUnderlineCancelButtonSet:
	mov si, .cancelString
	pop cx
	shl bx, cl
	call printString

	mov dx, 0x1329
	call cursorPosition
	mov bx, defaultTextAttributes
	cmp byte [.finalWarningChoice], 1
	je .afterUnderlineExecuteButtonSet
		mov bx, underlinedTextAttributes
	.afterUnderlineExecuteButtonSet:
	mov si, .executeString
	pop cx
	shl bx, cl
	call printString
	ret