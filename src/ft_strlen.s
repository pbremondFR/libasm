section .text
global ft_strlen

ft_strlen:
	; XORing the 32bit registers is the best way to zero them out: https://stackoverflow.com/a/33668295
	mov rdx, rdi	; Save string pointer
	xor al, al		; zero al to compare every byte to 0
	mov rcx, -1		; Set rcx to the max value possible (it's the limit for repnz)
	; No need for cld, the direction flag can be assumed to be zero: https://stackoverflow.com/a/41708474
	repnz scasb		; Thanks rainfall and override for teaching me this trick
	sub rdi, rdx	; Substract string start to current string ptr
	dec rdi			; Decrease to remove null terminator
	mov rax, rdi	; Move result to rax
	ret
