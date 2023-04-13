loadWriteMenu:
	; start
	%include "boot_manager/load_write/start.asm"

	jmp $

	; not code
	%include "boot_manager/load_write/not_code.asm"

	.afterKeyPress:


;		mov si