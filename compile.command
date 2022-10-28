cd "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Sand Desert Beats"

nasm system/boot_sector/boot.asm -f bin -o boot.bin
nasm system/extended_program.asm -f bin -o ext_prog.bin

cat boot.bin ext_prog.bin > /Users/MatviCoolk/Desktop/boot.iso

rm boot.bin
rm ext_prog.bin

open /Users/MatviCoolk/Library/Containers/com.utmapp.UTM/Data/Documents/Beats.utm