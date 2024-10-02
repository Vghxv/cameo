.section .data
	result_msg: .asciz "n = %d\n"

.section .text
.globl main

main:
	pushq %rbp
	movq %rsp, %rbp
	movq $42, %rsi
	leaq result_msg(%rip), %rdi
	call printf
	movq $0, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
