org 0x7C00
bits 16			; It set the size of the registers

start:			; Main function

	mov al, 13h	; Start video mode 
	mov ah, 0
	int 10h

	call matrix	; Call the matrix function

matrix:						

	mov ah, 01h	; Check the keystroke in the keyboard BUFFER 
	int 16h
	jnz read	; If there is a keystroke, then read
	call sleep	; If there is none, then it gets some delay and a newline
	call clean
	jmp matrix	; The infinite loop

sleep:			; The delay function

	mov cx, 10h	; In case you wanna see it nice on vm leave it with this configuration
	mov dx, 3968h	; If not change them to a lower value so the qemu displays it nice
	mov ah, 86h
	int 15h		; This function makes a delay with the registers cx and dx

	call scrollup 	; After the delay, you scroll up, this is the animation

	ret

scrollup:		; The scroll function
	
	mov ah, 7	; This is the scroll interupt
	mov al, 1
	mov dx, 184FH	; Dont know what this is
	mov bh, 0	; bh is always the color
	mov cx, 000h							
	
	int 10h		
	
	call randomnumber; This is the random number
	
	call write	; Ah has trash in it, this is the random ascii
	
	ret	
	
clean:			; This function clears all the registers, except for al, because it contains the input
	xor dx, dx
	xor dl, dl
	xor cx, cx
	xor bx, bx
	xor ah, ah
	ret

randomnumber:		; This function generates a random number and store in on dl (The column)
	
	call clean	; We clear everything before doing magic
	
	mov ah, 00h	; This interrupt calls the time on the system 
	int 1ah
	
	mov ax, dx
	xor dx, dx
	mov cx, 39
	div cx
	
	cmp dl, 39	; Right now dl has a "random" number 
	jg randomnumber ; But it must be greate
	
	ret

write:			; This function write on cursor 
	
	mov dh, 0	; Row
	mov bh, 0	; Color
	mov ah, 2	
	int 10h		; Here we set the cursor (DL is the column)

	mov cx, 1
	mov ah, 09h
	mov bh, 0
	mov bl, 0x02	
	int 10h		; Write on cursor

	ret

read:			; This function calls a random number, reads keystroke, then scroll up and finally return to the main loop

	call randomnumber

	mov ah, 00h
	int 16h
	
	call write
	call scrollup
	jmp matrix
	ret

times 510-($-$$) db 0	; 512 bits for the MBR
dw 0xAA55		; Magic memory address that detects it is a boot 

