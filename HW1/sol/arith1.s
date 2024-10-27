## We calculate in %rsi since it's the second argument for printf 

	.text
        .globl  main
main:
        mov     $4, %rdi        # 4 + 6
	add     $6, %rdi
        call    print_int

        mov     $21, %rdi       # 21 * 2
        imul    $2, %rdi
        call    print_int

        mov     $21, %rdi       # or with a shift
        sal     $1, %rdi
        call    print_int

        mov     $0, %rdx        # 4 + 7 / 2
        mov     $7, %rax
        mov     $2, %rbx
        idivq   %rbx            # divide %rdx::%rax by %rbx, in %rax
        mov     $4, %rdi
        add     %rax, %rdi
        call    print_int

        mov     $7, %rdi        # or with a shft
        sar     $1, %rdi
        add     $4, %rdi
        call    print_int

        mov     $0, %rdx        # 3 - 6 * (10 / 5)
        mov     $10, %rax
        mov     $5, %rbx
        idivq   %rbx            # divide %rdx::%rax by %rbx in %rax
        imul    $6, %rax
        mov     $3, %rdi
        sub     %rax, %rdi
        call    print_int

	mov     $0, %rax        # terminate with code 0
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
