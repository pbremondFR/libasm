## Caller-saved registers (free to use!)
List: `rax`, `rcx`, `rdx`, `rdi`, `rsi`, (`rsp`), [`r8`-`r11`]

### Decomposed as
Parameter registers: `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`
Other registers: `r10`, `r11`

## Callee-saved registers (save them before use!)
`rbx`, `rbp`, [`r12`-`r15`]

## Special registers
`rax`: return value of function
`rsp`: stack pointer

## Those funny string instructions
Disassembling and reverse-engineering the binaries of the "rainfall" and "override" projects taught me about the string family of operations in assembly. This is why the `ft_strlen` implementation looks a little different from others: when you see a `repne scasb` in assembly, chances are you're looking at a `strlen` or `memchr` call.

## Valgrind not working
Valgrind won't work with this project, because I'm using `repnz movsb`, which it doesn't seem to like. It looks like the combination of `repnz` (0xf2) and `movsb` (0xa4) is just not handled by Valgrind, which is why it outputs the following: `vex amd64->IR: unhandled instruction bytes: 0xF2 0xA4 0xC3 0xFF 0x15 0x7A 0x2A 0x0 0x0 0xC7`. You can clearly see the two first instruction bytes are `repnz` and `movsb`.

## Calling libc functions
tl;dr: Use the GOT. https://stackoverflow.com/a/52131094
