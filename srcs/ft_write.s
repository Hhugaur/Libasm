bits 64

global ft_write
extern __errno_location

ft_write: ;all value is where we want
    mov rax, 1 ; just need to call sys_write
    syscall
    cmp rax, 0 ;if the above got an error set rax in negative value 
    jl .err; check previous operation if value is less than 0 go to
    ret
.err:
    neg rax ;errno need an absolute value
    mov rdi, rax ; we kept the errno value we get from syscall et put it in rdi for after the call
    call __errno_location wrt ..plt ; need wrt ..plt for linkage
    mov [rax], rdi; errno_location retur rax who is the pointer to errno and we deference it to put our errno value 
    mov rax, -1 ; value que va renvoyer ft_write
    ret

; wrt->with respect to | plt->Procedure Linkage Table
; wrt help precise we need plt
; plt is compatible with PIE in helping found some function
; we don't have fix address because of PIE
; in detail gcc use Position Independent Executable (PIE)
; is a security feature: ASLR (Address Space Layout Randomization)
