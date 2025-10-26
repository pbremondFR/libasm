## Caller-saved registers (free to use!)
List: `rax`, `rcx`, `rdx`, `rdi`, `rsi`, (`rsp`), [`r8`-`r11`]

### Decomposed as:
Parameter registers: `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`
Other registers: `r10`, `r11`

## Callee-saved registers (save them before use!)
`rbx`, `rbp`, [`r12`-`r15`]

## Special registers:
`rax`: return value of function
`rsp`: stack pointer

## Valgrind not working:
Valgrind won't work with this project, because I'm using `repnz movsb`, which it doesn't seem to like. Try it out yourself if you want.
