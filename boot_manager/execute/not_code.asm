;   888b    888                    888                                                    888
;   8888b   888                    888                                                    888
;   88888b  888                    888                                                    888
;   888Y88b 888       .d88b.       888888                 .d8888b       .d88b.        .d88888       .d88b.
;   888 Y88b888      d88""88b      888                   d88P"         d88""88b      d88" 888      d8P  Y8b
;   888  Y88888      888  888      888                   888           888  888      888  888      88888888
;   888   Y8888      Y88..88P      Y88b.                 Y88b.         Y88..88P      Y88b 888      Y8b.
;   888    Y888       "Y88P"        "Y888                 "Y8888P       "Y88P"        "Y88888       "Y8888

.headerString: db " menu:", 0x00
.footerString: db   "Execute code in 20-bit address", 0x0D, "Action Segment : Offset", 0x0D, 0x0D, 0x1b, 0x1a, " to select", 0x0D, 0x19, 0x18, " to change value", 0x0D, "Enter to execute", 0x0D, 0x0D, "Jump 0x0000 : 0x7C00   <OK>", 0x00
.beCarefullyHeader: db "Please, be carefully.", 0x00
.beCarefullyFooter: db "Executing corrupted code or", 0x0D, "code at wrong memory address", 0x0D, "may work differently or", 0x0D, "be harmful for Your computer", 0x00
.callString: db "Call", 0x00
.jumpString: db "Jump", 0x00
.okString: db "<OK>", 0x00

; 0 or 1
.finalWarningState: db 0x00
.finalWarningChoice: db 0x00

.cancelString: db "<CANCEL>", 0x00
.executeString: db "<EXECUTE>", 0x00

.selectionNumber: db 1
.lastSelectionNumber: db 1
.callOrJumpChoice: db 0
.segmentChoice: dw 0x0000
.offsetChoice: dw 0x7C00

.executeMenuControl:
	dw .upArrowKeyPress
	dw .downArrowKeyPress
	dw .returnKeyPress
	dw .escapeKeyPress
	dw .leftArrowKeyPress
	dw .rightArrowKeyPress