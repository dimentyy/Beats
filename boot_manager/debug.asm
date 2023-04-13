debugAl:
	push ax
	push ax

	and al, 0xf0
	mov cl, 4
	shr al, cl
	call .nibble

	pop ax
	and al, 0x0f
	call .nibble

	pop ax

	ret

	.nibble:
		cmp al, 10

		jl  .afterAdd
			add al, "A" - "9" - 1
		.afterAdd:

		add al, "0"
		mov ah, 0x0e
		xor bh, bh
		int 10h
		ret

debugNibble:
	push cx
	mov cx, 1
	cmp al, 10

	jl  .afterAdd
		add al, "A" - "9" - 1
	.afterAdd:

	add al, "0"
	mov ah, 0x09
	xor bh, bh
	int 10h
	pop cx
	ret

debugAx:


; ax - one block length
; cx - blocks count
; si - memory address to debug
debugMemory:
	.loop:
		push cx

		mov cl, 4
		rol bl, cl
		push ax
		mov cx, ax
		.colorLoop:
			push cx
			lodsb
			push ax

			and al, 0xf0
			mov cl, 4
			shr al, cl
			call .nibble

			pop ax
			and al, 0x0f
			call .nibble

			pop cx
			loop .colorLoop
		pop ax

		pop cx

		loop .loop
	ret

	.nibble:
		cmp al, 10

		jl  .afterAdd
			add al, "A" - "9" - 1
		.afterAdd:

		add al, "0"

		mov ah, 03h
		int 10h
		inc dl
		mov ah, 02h
		int 10h

		mov cx, 1
		mov ah, 09h
		int 10h

		ret