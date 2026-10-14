bits 64

; if1
; include LIBFT.LIB
; endif

section .text
        extern main
main:
        ; mov     rbx, 4
        ; loop    jump

jump:
        mov     rax, 1 ; write
        mov     rdi, 1 ; stdout
        mov     rsi, msg
        mov     rdx, msg.len
        syscall

        ; dec     rbx
        ; jnz    jump


        mov     rax, 60 ; exit
        mov     rdi, 0
        syscall

section .data
msg   db      42h, 111, 'nj'
db 'our, mo'

db 'nde !', 10
.len:   equ     $ - msg
