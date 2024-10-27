## we calculate with a stack 

	.text
        .globl  main
main:
        pushq   $4              # 4 + 6
	pushq   $6
        popq    %rdi
        popq    %rbx
        add     %rbx, %rdi
        call    print_int

        pushq   $21             # 21 * 2
        pushq   $2
        popq    %rdi
        popq    %rbx
        imul    %rbx, %rdi
        call    print_int

        pushq   $4              # 4 + 7 / 2
        pushq   $7
        pushq   $2
        popq    %rbx
        mov     $0, %rdx
        popq    %rax
        idivq   %rbx            # divide %rdx::%rax by %rbx
        pushq   %rax            # the quotient in %rax
        popq    %rbx
        popq    %rdi
        add     %rbx, %rdi
        call    print_int

        pushq   $3              # 3 - 6 * (10 / 5)
        pushq   $6
        pushq   $10
        pushq   $5
        popq    %rbx
        mov     $0, %rdx
        popq    %rax
        idivq   %rbx            # divide %rdx::%rax by %rbx in %rax
        pushq   %rax
        popq    %rbx
        popq    %rax
        imul    %rbx, %rax
        pushq   %rax
        popq    %rbx
        popq    %rdi
        sub     %rbx, %rdi
        call    print_int

	mov     $0, %rax        # exit with code 0
        ret

        ## a routine for print an integer (%rdi) with printf
print_int:
        mov     %rdi, %rsi
        mov     $message, %rdi  # arguments for printf
        mov     $0, %rax
        call    printf
        ret

	.data
message:
	.string "%d\n"
