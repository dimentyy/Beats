: variables;
	utmctl=/Applications/UTM.app/Contents/MacOS/utmctl
	temp=temp/
	utm_vm_name=Beats
	utm_vm_file=Beats.utm

clear
cd "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats"

truncate -s 0 error_log.txt
truncate -s 0 boot.img

function compile {
  nasm ${1}.asm -f bin -o $temp/${2}.bin -s >> error_log.txt
  if [[ -e $temp/${2}.bin ]]; then cat $temp${2}.bin >> boot.img; fi;
}


compile ebem/boot_sector/main   mbr_boot_sector
compile ebem/boot               ebem_boot_sector
compile ebem/main               ebem_main

if [[ -s error_log.txt ]]; then
  cat error_log.txt
else
  clear
  open $utm_vm_file;
  $utmctl stop  $utm_vm_name
  $utmctl start $utm_vm_name
  exit; fi