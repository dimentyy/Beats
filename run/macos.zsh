: some good stuff;
	clear
	cd "/Users/MatviCoolk/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive/Beats"

: variables;
	utmctl=/Applications/UTM.app/Contents/MacOS/utmctl
	temp=temp/
	utm_vm_name=Beats
	utm_vm_file=Beats.utm

: clearing output files;
	truncate -s 0 $temp/nasm_error_log.txt
	truncate -s 0 boot.img

: to reduce space;
	function compile {
		nasm ${1}.asm -f bin -o $temp/${2}.bin -s >> $temp/nasm_error_log.txt;
		if [[ -e $temp/${2}.bin ]]; then cat $temp${2}.bin >> boot.img; fi;
	}

: repeat for all assembly files;
	compile ebem/boot_sector/main   mbr_boot_sector
	compile ebem/boot               ebem_boot_sector
	compile ebem/main               ebem_main

: check if errors occured, show them;
  if [[ -s $temp/nasm_error_log.txt ]]; then
    cat $temp/nasm_error_log.txt
    zsh
: if not, run utm vm;
  else
    open $utm_vm_file;
    $utmctl stop  $utm_vm_name;
    $utmctl start $utm_vm_name;
    osascript -e 'tell app "Terminal" to close front window'
    exit; fi