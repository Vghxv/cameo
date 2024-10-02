    .section .data
x: .long 2
y: .long 0
result_msg: .asciz "n = %d\n"

    .section .text
    .globl main

main:

    pushq %rbp
    movq %rsp, %rbp

    movl x(%rip), %eax
    imull %eax, %eax
    addl x(%rip), %eax

    movl %eax, %esi
    movl $result_msg, %edi
    call printf

    movq %rbp, %rsp
    popq %rbp
    xor %rax, %rax
    ret
