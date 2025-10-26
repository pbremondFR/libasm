section .text
global ft_strcpy

ft_strcpy:
	mov rcx, rdi	; Save dest string pointer, we'll use low parts of rax with lodsb/stosb
.loop:
	lodsb			; Load byte of [rsi] into al...
	stosb			; ... store byte of al into [rdi]
	test al, al		; Break loop if null-terminator
	jnz .loop
	mov rax, rcx	; Return pointer to dest string
	ret
