section .text
global ft_atoi_base

INT32_MAX equ 2147483647

isspace:
	cmp dl, 32	; Is space character
	je .true
	sub dl, 9	; c >= 9 && c <= 13
	cmp dl, 13
	add dl, 9
	ja .false
.true:
	mov eax, 1
	ret
.false:
	xor eax, eax
	ret

; Checks base for errors. Sets eax to 0 for errors, 1 otherwise.
; Also sets r11d to hold the length of the base string.
check_base:
	xor eax, eax	; Check for NULL-terminator (set al to 0)
	mov rcx, -1
	repnz scasb
	lea rdi, [rdi + rcx + 1]	; Reset rdi to the beginning of the string
	neg rcx
	sub rcx, 4		; rcx is strlen + 2, substract 4 to check range right after
	cmp rcx, 64		; Check if base length must be in range [2;64]
	ja .error
	add rcx, 2		; Reset rcx to its correct state: strlen of the base string
	mov r11d, ecx	; Now length of base is stored in r11d
.loop:
	cmp rcx, 0		; Exit loop if at end of string
	je .exit
	mov dl, BYTE [rdi]	; Store character in dl
	call isspace
	cmp eax, 1		; Error if character is a space
	je .error
	cmp dl, '+'		; Error if character is a +
	je .error
	cmp dl, '-'		; Error if character is a -
	je .error

	mov r8, rcx		; Save rcx before repnz loop check
	mov al, dl		; Check for this character in the string for duplicate
	inc rdi			; Look after this character
	dec rcx
	repnz scasb
	test rcx, rcx
	jnz .error		; Duplicate character if we haven't reached the last character
	mov rcx, r8		; Restore rcx after repnz instruction
	dec rcx			; Decrease character count...
	sub rdi, rcx	; ... and restore pointer to next character
	jmp .loop
.exit:
	mov eax, 1
	ret
.error:
	xor eax, eax
	ret

; int ft_atoi_base(char *str, char *base)
ft_atoi_base:
	push rdi		; Save str pointer
	mov rdi, rsi	; Pass base as arg to check_base
	call check_base
	pop rdi			; Restore str pointer
	test eax, eax	; Error if base is wrong
	jz .error
	xor eax, eax	; Result in eax
	xor r10, r10	; Negative sign flag set to 0 by default
.skip_spaces_loop:
	mov dl, BYTE [rdi]	; Load character to check inside dl
	call isspace
	test eax, eax	; Quit loop if not space character
	jz .check_for_sign
	inc rdi			; Increase index & continue loop
	jmp .skip_spaces_loop
.check_for_sign:
	xor eax, eax	; Reset eax because it's going to be our result variable
	mov dl, BYTE [rdi]
	cmp dl, '+'
	je .parse_sign	; Is a +, parse it
	cmp dl, '-'
	je .parse_sign	; is a -, parse it
	jmp .parsing_loop
.parse_sign:
	inc rdi				; Increase index because we had a sign character
	cmp dl, '-'
	sete r10b		; Set r10 to 1 if sign is negative, 0 otherwise
.parsing_loop:
	movzx ecx, BYTE [rdi]	; Store current character in ecx
	sub cl, '0'
	cmp cl, 9
	ja .exit_loop	; Stop parsing loop if not a digit
	mul r11d		; Multiply result by length of base
	test edx, edx	; If edx != 0, then the multiplication has overflown, which means we should return an error
	jnz .error
	add eax, ecx	; Result += character - '0'
	jc .error
	inc rdi
	jmp .parsing_loop
.exit_loop:
	add r10, INT32_MAX
	cmp eax, r10d
	ja .error
	cmp r10, INT32_MAX
	je .exit
	neg eax
	jmp .exit
.error:
	xor eax, eax
.exit:
	ret
