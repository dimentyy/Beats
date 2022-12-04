%define bootSector 0x7C00          ; Address at which BIOS will load MBR
%define mbrCopyOffset 512         ; Address at which MBR should be copied

%define color 0x07           ; Background and text color
%define errorColor 0x0c           ; Background and text color
%define warningColor 0x0e           ; Background and text color

bits 16
org bootSector - mbrCopyOffset

mov [savedDX], dx

; copy old
mov si, bootSector                 ; Source Index to copy code from
mov di, bootSector - mbrCopyOffset                 ; bootSector - mbrCopyOffsetination Index to copy code to
mov cx, 512                 ; Number of bytes to be copied
cld                          ; Clear Direction Flag (move forward)
rep movsb                    ; Repeat MOVSB instruction for CX times
jmp afterMbrCopy - mbrCopyOffset              ; Jump to copied code skipping part above

afterMbrCopy:           ; Go here in copied code

; video settings
mov ax, 0x0003  ; function 0, mode 3
int 0x10        ; change video mode

mov ax, 0x0103  ; function 1, mode 3
mov cx, 0x0105  ; cursor height 1-5 (max 0-7)
int 0x10        ; change cursor shape

call countActiveParts
cmp ax, 1
je autoChooseStart

countActiveParts:
	mov ax, 0
	mov bx, 0
	mov cx, 4

	.loop:
		call getPartitionState
		je .inc
		loop .loop
	ret

	.inc:
		mov bl, cl
		inc ax

getPartitionState:
	mov bp, cx
	shl bp, 4
	add bp, partitionTableStart - 16
	cmp byte [bp], 0x80
	ret


;values
savedDX equ 0x0000
selectedPartition equ 0x00

; strings
errorString: db "Erro", 0
warningString: db "Warn", 0
noBootString: db ": no boot ", 0
markString: db "mark", 0
codeString: db "code", 0

%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/auto.asm"
%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/print.asm"
%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/start.asm"
%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/debug.asm"

times 446 - ($ - $$) db 0x00

; partition table
partitionTableStart:
%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/part_table.asm"

; boot sector signature
dw 0xaa55