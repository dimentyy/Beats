;   888b    888                    888                                                    888
;   8888b   888                    888                                                    888
;   88888b  888                    888                                                    888
;   888Y88b 888       .d88b.       888888                 .d8888b       .d88b.        .d88888       .d88b.
;   888 Y88b888      d88""88b      888                   d88P"         d88""88b      d88" 888      d8P  Y8b
;   888  Y88888      888  888      888                   888           888  888      888  888      88888888
;   888   Y8888      Y88..88P      Y88b.                 Y88b.         Y88..88P      Y88b 888      Y8b.
;   888    Y888       "Y88P"        "Y888                 "Y8888P       "Y88P"        "Y88888       "Y8888

.headerString: db " menu:", 0x00
.footerString: db   "Load data from a drive to memory or", 0x0D, "Write data to the drive from memory", 0x0D, "Action Sectors Drive Segment : Offset", 0x0D, 0x0D, 0x1b, 0x1a, " to select", 0x0D, 0x19, 0x18, " to change value", 0x0D, "Enter to continue", 0x0D, 0x0D, "Write 0x00 sectors to   drive 0x00", 0x0D, "from 0x0000 : 0x7C00   <OK>", 0x00
.beCarefullyHeader: db "Please, be carefully.", 0x00
.beCarefullyFooter: db "Writing data to ", 0x00

.loadWriteMenuControl:
;	dw .upArrowKeyPress
;	dw .downArrowKeyPress
;	dw .returnKeyPress
;	dw .escapeKeyPress
;	dw .leftArrowKeyPress
;	dw .rightArrowKeyPress