section .text
global ft_strcmp

ft_strcmp:
	xor eax, eax	; Zero those two registers that I'm gonna use
	xor ecx, ecx
.loop:
	mov al, BYTE [rdi]	; Load the two characters...
	mov cl, BYTE [rsi]
	cmp al, cl			; Compare them and exit loop if they differ
	jnz .exit
	test al, cl			; Exit loop if one of the chars is 0 (NULL terminator)
	jz .exit
	inc rdi				; Increase both pointers and repeat loop
	inc rsi
	jmp .loop
.exit:
	sub eax, ecx		; Result of comparison (aka return *str1 - *str2)
	ret
