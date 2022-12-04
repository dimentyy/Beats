%define bootSector 0x7c00
org bootSector - 512

mov [bootDrive], dl
call setupPrinting

mov ax, 3
int 10h

call copyEbem
jmp $ - 510

call menuLoop

jmp $

mov al, 4
mov ah, 2h
mov bx, bootSector
mov cx, 2
mov dl, [bootDrive]
mov dh, 0
int 13h

jmp bootSector

bootDrive equ 0x00

ebem_mbr_name:
	db 'MBR EBeM', 0x00

ebem_mbr_ver:
	db 'pre 0.1', 0x00

%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/copy_ebem.asm"
%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/print.asm"
%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/menu.asm"

times 446 - ($-$$) db 0

; beef partition
db 0x80
db 0
db 0x02
db 0
db 0xEA
db 0
db 0x06
db 0
dq 0

times 48 db 0x00

dw 0xaa55