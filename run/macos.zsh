: variables;
	utmctl=/Applications/UTM.app/Contents/MacOS/utmctl
	temp=temp
	utm_vm_name=Beats
	utm_vm_file=Beats.utm
	box=/Applications/.86Box/86Box.app/Contents/MacOS/86Box

clear

cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats"

truncate -s 0 error_log.txt
truncate -s 0 boot.img

function compile {
  nasm ${1}.asm -f bin -o $temp/${2}.bin -s >> error_log.txt
  if [[ -e $temp/${2}.bin ]]; then cat $temp/${2}.bin >> boot.img; fi;
}

compile boot_sector/main          mbr_boot_sector
compile boot_manager/boot_sector  boot_manager_boot_sector
compile boot_manager/main         boot_manager_main

clear
if [[ -s error_log.txt ]]; then
  cat error_log.txt
else
  $box; fi
  # open $utm_vm_file;
  # $utmctl stop  $utm_vm_name
  # $utmctl start $utm_vm_name; fi