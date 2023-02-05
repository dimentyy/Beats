debugAL:
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