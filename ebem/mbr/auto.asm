autoChooseStart:
	mov [selectedPartition], bl
	call start
	ret