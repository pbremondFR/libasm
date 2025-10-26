section .text
global ft_write
extern __errno_location

ft_write:
	call __errno_location
	mov r11, rax	; Save location of errno in register that's caller-saved & not used by syscall args
	mov rax, 1		; write syscall in x64 Linux
	syscall			; No need to change register order, it's the same order for the first 3 registers
	neg rax
	mov [r11], rax
	ret
