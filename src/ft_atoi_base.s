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
	xor r11, r11	; r11d will hold the length of the base
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
	mov r8d, eax		; Save result in r8d
	mov r9, rdi			; Save string pointer into r9
	mov al, BYTE [rdi]	; Search for current char...
	mov rdi, rsi		; ...Search base string...
	mov rcx, r11		; ...Length of base to check...
	inc rcx				; ...+1 because repnz increases rcx 1 above strlen...
	repnz scasb			; ...Search for current char in string
	test rcx, rcx
	jz .exit_loop		; Character not found, finish parsing
	dec rcx				; Decrease rcx because we increased it earlier...
	sub ecx, r11d		; ...invert it to get the actual index...
	neg ecx
	dec ecx				; ...last decrease, ecx = index of found character
	mov rdi, r9			; Restore string pointer
	mov eax, r8d		; Restore result
	mul r11d		; Multiply result by length of base
	test edx, edx	; If edx != 0, then the multiplication has overflown, which means we should return an error
	jnz .error
	add eax, ecx	; Result += character - '0'
	jc .error
	inc rdi
	jmp .parsing_loop
.exit_loop:
	mov eax, r8d		; Restore result from r8
	add r10, INT32_MAX	; r10 is either INT32_MAX or INT32_MAX + 1 (if sign bit is set)...
	cmp eax, r10d		; ... compare unsigned result to r10...
	ja .error			; If above, overflow -> error
	cmp r10, INT32_MAX	; If r10 is INT32_MAX, then sign bit wasn't set, go to exit...
	je .exit			; ... otherwise sign was there, negate result before exit
	neg eax
	jmp .exit
.error:
	xor eax, eax
.exit:
	ret
