.section .data
    result_msg: .asciz "n = %d\n"

.section .text
    .globl main

main:
    pushq %rbp
    movq %rsp, %rbp

	# 4 + 6     movq $4, %rsi
    movq $6, %rdx

    movq %rsi, %rax]
    addq %rdx, %rax

    movq %rax, %rsi
    leaq result_msg(%rip), %rdi

    call printf

	# 21 * 2
    movq $21, %rsi
    movq $2, %rdx

    movq %rsi, %rax
    imulq %rdx, %rax

    movq %rax, %rsi
    leaq result_msg(%rip), %rdi

    call printf

	# 7 / 2 + 4
    movq $7, %rax
    cqo
    movq $2, %rbx
    idivq %rbx

    addq $4, %rax

    movq %rax, %rsi
    leaq result_msg(%rip), %rdi

    call printf

	# 3 - 6 * (10 / 5)

	movq $10, %rax
	cqo
	movq $5, %rbx
	idivq %rbx

	movq $6, %rdx
	imulq %rax, %rdx

	movq $3, %rax
	subq %rdx, %rax

	movq %rax, %rsi
	leaq result_msg(%rip), %rdi

	call printf

    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
