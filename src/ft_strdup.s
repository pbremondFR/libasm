extern ft_strlen
extern __errno_location
extern malloc

section .text
global ft_strdup

ft_strdup:
	; mov rdx, rdi	; Save string pointer
	push rdi		; Save string pointer
	call ft_strlen
	inc rax			; Space for NULL-terminator
	mov rdi, rax	; Call malloc for this
	mov rbx, rax	; Save length of string
	call [rel malloc wrt ..got]
	test rax, rax
	jz .error
	mov rdi, rax	; dest ptr in rdi
	pop rsi			; src ptr in rsi
	mov rcx, rbx	; Length of copy
	repnz movsb		; Copy string including NULL-terminator
	ret
.error:
	call [rel __errno_location wrt ..got]
	mov DWORD [rax], 12 ; ENOMEM
	xor eax, eax
	ret
