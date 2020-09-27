org 0x7C00
bits 16

start:
	mov al, 13h
	mov ah, 0
	int 10h

	call matrix	

matrix:						

	mov ah, 00h
	int 16h

	mov ah, 0x0E
	mov bh, 0
	mov bl, 0x07
	int 10h

	call matrix

times 510-($-$$) db 0
dw 0xAA55

