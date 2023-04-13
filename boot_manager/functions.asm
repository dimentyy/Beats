; bl = offset
; si = word address
nibbleInWordIncDecClamp:

	; I really don't know how I did this...
	; I will leave comments later as I figure it out

	; ax = 0 / 1
	xor ah, ah
	mov dl, al
	add ax, ax
	dec ax
	; dl = 0 (dec) / 1 (inc)
	; ax = -1 / 1

	; get word offset to get nibble
	xor bl, 3 ; backwards

	mov cl, 2
	shl bl, cl ; multiply by 4

	mov cl, bl
	mov bx, ax
	shl bx, cl ; get 2 ^ prev value

	; get nibble
	mov ax, [di]
	shr ax, cl
	and al, 0x0f

	; return if decreasing 0
	cmp al, 0
	jnz .skip0
		cmp dl, 1
		je .skip0
		ret
	.skip0:

	; return if increasing F
	cmp al, 0x0F
	jne .skipF
		cmp dl, 0
		je .skipF
		ret
	.skipF:

	; finally do decrease / increase
	add [di], bx
	ret