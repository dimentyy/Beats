%define bootSector 0x7C00          ; Address at which BIOS will load MBR
%define mbrCopyOffset 512         ; Address at which MBR should be copied
%define mbrCopyAddress bootSector - mbrCopyOffset         ; Address at which MBR should be copied

%define savedDX 0x7E00

org mbrCopyAddress
cpu 8086
bits 16

mov [savedDX], dx

; copy mbr to new dest
mov di, mbrCopyAddress
mov si, bootSector
mov cx, 512
rep movsb
jmp $ - mbrCopyOffset + 2

call countActiveParts
cmp ax, 1
je autoChooseStart

%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/include.asm"

; partition table
times 446 - ($ - $$) db 0x00
%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats/ebem/mbr/part_table.asm"

; boot sector signature
dw 0xaa55