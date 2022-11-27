cd "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats"

clear

nasm ebem/mbr/main2.asm -f bin -o boot.bin
nasm system/extended_program/main.asm -f bin -o ext_prog.bin

cat boot.bin ext_prog.bin > boot

rm boot.bin
rm ext_prog.bin

echo
echo ================================================================================
echo

open /Users/MatviCoolk/Library/Containers/com.utmapp.UTM/Data/Documents/Beats.utm