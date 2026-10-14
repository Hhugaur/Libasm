bits 64

global ft_strcmp

ft_strcmp:
    xor rax, rax
.loop:
    mov cl, BYTE [rdi + rax] ;we gonna use cl(cl -> cx cl = 8-bits)
    cmp cl, BYTE [rsi + rax] ;cmp and other don't work with two BYTE[] this why we put rdi in cl
    jne .end ;not zero or not equal
    cmp cl, 0
    je .end
    inc rax
    jmp .loop
.end:
    sub cl, BYTE[rsi + rax] ;substrate cl and rsi[rax] to have the value
    movsx rax, cl; we use movsx because he kept the negative and must importantly we do 8-bits to 64-bits
    ret

;movzx can be used with 8-bits memory to clear the above 16,32,64 with \0
;movsx do the same but kept the negative