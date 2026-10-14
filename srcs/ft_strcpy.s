bits 64

global ft_strcpy

ft_strcpy:
    xor rax, rax
.loop:
    mov dl, BYTE [rsi + rax] ; dl = cl same use (cf:ft_strcmp)
    mov BYTE [rdi + rax], dl ; rdi[rax] we put the above rsi[rax]
    cmp dl, 0
    je .end
    inc rax
    jmp .loop
.end:
    mov rax, rdi ;return(rdi) 
    ret