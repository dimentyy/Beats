.rightArrowKeyPress:
	cmp byte [.finalWarningState], 1
	je .finalWarningRightArrowKeyPress
		add byte [.selectionNumber], 2
	.finalWarningRightArrowKeyPress:
	mov byte [.finalWarningChoice], 2
	cmp byte [.finalWarningState], 1
	je .afterLeftArrowFinalWarningChoiceSet

.leftArrowKeyPress:
	cmp byte [.finalWarningState], 0
	je .afterLeftArrowFinalWarningChoiceSetEscape
	mov byte [.finalWarningChoice], 1

	.afterLeftArrowFinalWarningChoiceSet:
		mov cx, 0
		call .drawCancelExecuteButtons

		jmp .afterKeyPress

	.afterLeftArrowFinalWarningChoiceSetEscape:

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
	cmp byte [.finalWarningState], 1
	je .afterKeyPress
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
		mov bl, [.selectionNumber]
		sub bl, 2
		mov di, .segmentChoice
		call nibbleInWordIncDecClamp
		jmp .afterUpDownKeyPress

	.notSegmentSelection:
	cmp byte [.selectionNumber], 9
	jg .notOffsetSelection
        mov bl, [.selectionNumber]
		sub bl, 6
        mov di, .offsetChoice
        call nibbleInWordIncDecClamp
        jmp .afterUpDownKeyPress
	.notOffsetSelection:
	.afterUpDownKeyPress:
	jmp .afterKeyPress
