org 0x7C00
bits 16

start:
	mov al, 13h
	mov ah, 0
	int 10h

	mov dl, 0
	mov dh, 0

	call matrix	

matrix:						

	mov ah, 01h
	int 16h
	jnz read
	call sleep

	jmp matrix

sleep:

	mov cx, 20h
	mov dx, 968h
	mov ah, 86h
	int 15h

	call scrollup

	ret

scrollup:
	
	mov ah, 7
	mov al, 1
	mov dx, 184FH
	mov bh, 0
	mov cx, 000h
	
	int 10h
	ret	

write:	
		
	mov dh,0
	mov dl, 5
	mov bh, 0
	mov ah, 2
	int 10h

	mov cx, 1
	mov ah, 09h
	mov bh, 0
	mov bl, 0x02
	int 10h

	ret

read:
	mov ah, 00h
	int 16h

	call write
	call scrollup
	call matrix
	ret

times 510-($-$$) db 0
dw 0xAA55

