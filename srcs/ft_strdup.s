bits 64

global ft_strdup
extern ft_strcpy
extern ft_strlen
extern __errno_location
extern malloc

ft_strdup:
    xor rax, rax 
    mov rbx, rdi ;other mean to do it push rdi because we need to save the value rdi char *s

    call ft_strlen 
    inc rax ; + 1 in malloc for the \0
    mov rdi, rax ; rdi = strlen(rdi)
    
    call malloc wrt ..plt ; (cf: ft_write)
    test rax, rax
    je .err

    mov rdi ,rax ; rdi get what malloc gave
    mov rsi, rbx ;other mean to do it pop rsi this restore our stack
    call ft_strcpy ; strcpy give in rax what we need
    ret
.err:
    xor rax, rax
    ret

