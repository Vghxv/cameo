.section .data
	result_msg: .asciz "n = %d\n"

.section .text
.globl main

p1:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp
    movq %rdi, -8(%rbp)
    addq %rdi, %rdi
    movq %rdi, %rax
    movq -8(%rbp), %rdi
    imulq %rdi, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

p2:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax
    xorq %rdx, %rdx
    movq %rdi, %rbx
    divq %rbx

    movq %rbp, %rsp
    popq %rbp
    ret

main:
	pushq %rbp
	movq %rsp, %rbp

	movq $3, %rax
    imulq %rax, %rax
	movq %rax, %rsi
    leaq result_msg(%rip), %rdi
    call printf

    movq $3, %rdi
    call p1

    movq %rax, %rsi

    call p2

    addq %rax, %rsi
    leaq result_msg(%rip), %rdi
    call printf

    xor %rax, %rax
    movq %rbp, %rsp
	popq %rbp
	ret
