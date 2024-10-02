.section .data
	result_msg: .asciz "sqrt(%2d) = %2d\n"

.section .text
.globl main

isqrt:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rcx
    movq $1, %rdi # s
    xorq %rsi, %rsi # c, counter

while:
    cmpq %rcx, %rdi
    jg end_while
    incq %rsi
    leaq 1(%rdi, %rsi, 2), %rdi
    jmp while

end_while:
    movq %rsi, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

main:
	pushq %rbp
	movq %rsp, %rbp
    subq $16, %rsp
    movq $0, -4(%rbp)

loop:
    cmpq $20, -4(%rbp)
    jg end_loop

    movq -4(%rbp), %rdi
    call isqrt

    movq -4(%rbp), %rsi
    movq %rax, %rdx
    leaq result_msg(%rip), %rdi
    xorq %rax, %rax
    call printf
    incq -4(%rbp)
    jmp loop

end_loop:
    movq $0, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
