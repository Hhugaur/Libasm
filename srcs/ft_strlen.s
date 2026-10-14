bits 64

global ft_strlen

ft_strlen:
    xor rax, rax ; equivalent of mov rax, 0 but in an optimization way
.loop:
    cmp BYTE [rdi + rax], 0 ; we compare rdi[rax] to 0 
    je .end ; if precedent operation equal 0 we jump to .end
    inc rax ; rax++
    jmp .loop ; fake loop we break the loop with je .end
.end:
    ret ; end function
