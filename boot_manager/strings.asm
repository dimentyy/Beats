ebemOptionsString:    db "Manager options:", 0x00

mainMenuStringAddresses:
	db -mainMenuStringAddresses + loadWriteString
	db -mainMenuStringAddresses + moveString
	db -mainMenuStringAddresses + executeString
	db -mainMenuStringAddresses + aboutString
	db -mainMenuStringAddresses + fatReaderString

loadWriteString:     db "Load / Write", 0x00
writeString:    db "Write", 0x00
moveString:     db "Move", 0x00
executeString:  db "Execute", 0x00
aboutString:    db "About", 0x00
fatReaderString:    db "FAT reader", 0x00