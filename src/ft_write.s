section .text
global ft_write
extern __errno_location

ft_write:
	call [rel __errno_location wrt ..got]
	push rax		; Save errno location
	mov rax, 1		; write syscall in x64 Linux
	syscall			; No need to change register order, it's the same order for the first 3 registers
	pop rdx			; Store errno location into rdx
	cmp rax, -4095	; Funny. https://stackoverflow.com/a/47566663, and https://stackoverflow.com/a/38752895
	jae .error
	ret
.error:
	neg rax			; read syscall returns -ERRNO is case of error, negate it for normal ERRNO
	mov [rdx], eax	; Put ERRNO value at errno pointer
	mov rax, -1		; Return -1 for error
	ret
