partitionTableStart:
	times 32 db 0x00

	; main beef partition
	db 0x80
	db 0
	db 0x02
	db 0
	db 0xEA
	db 0
	db 0x01
	db 0
	dq 0

	times 16 db 0x00