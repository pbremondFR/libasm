extern ft_strlen
extern __errno_location
extern malloc

section .text
global ft_strdup

ft_strdup:
	push rdi		; Save string pointer
	call ft_strlen
	inc rax			; Add space for NULL-terminator
	mov rdi, rax	; Pass that size as an arg to malloc
	push rax		; Save length of string to copy
	call [rel malloc wrt ..got]
	mov rdi, rax	; dest ptr in rdi
	pop rcx			; Length of copy
	pop rsi			; src ptr in rsi
					; Pop those last two here to avoid fucking up the stack when branching into the error
	test rax, rax	; Only NOW, check if malloc returned NULL, if so, goto error
	jz .error
	repnz movsb		; Copy string including NULL-terminator
	ret
.error:
	call [rel __errno_location wrt ..got]
	mov DWORD [rax], 12 ; ENOMEM
	xor eax, eax		; Return NULL
	ret
