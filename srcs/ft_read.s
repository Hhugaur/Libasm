bits 64

global ft_read
extern __errno_location

ft_read:
    xor rax, rax
    syscall
    cmp rax, 0
    jl .err
    ret
.err:
    neg rax
    mov rdi, rax
    call __errno_location wrt ..plt
    mov [rax], rdi
    mov rax, -1
    ret