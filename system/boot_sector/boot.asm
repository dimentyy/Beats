org 0x7c00

; boot drive
mov [bootDisk], dl

call diskRead
jmp loadedExtendedProgram

%include "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats/system/boot_sector/disk_read.asm"

times 510-($-$$) db 0
dw 0xaa55