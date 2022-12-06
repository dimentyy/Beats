cd "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats"
truncate -s 0 temp/nasm_error_log.txt
truncate -s 0 boot.img

function compile {
	nasm ${1}.asm -f bin -o temp/${2}.bin -s >> temp/nasm_error_log.txt;
	if [[ -e temp/${2}.bin ]]; then cat temp/${2}.bin >> boot.img; fi
}

compile ebem/mbr/main mbr
compile system/extended_program/main ext

clear

if [[ -s temp/nasm_error_log.txt ]]
then cat temp/nasm_error_log.txt
else open Beats.utm; osascript -e 'tell app "Terminal" to close front window'; fi