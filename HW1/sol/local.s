        .text
        .globl  main
main:
        sub     $16, %rsp       # we allocate two words in the stack
        movq    $3, 8(%rsp)     # x allocate in sp + 8
        mov     8(%rsp), %rdi
        imul    8(%rsp), %rdi
        call    print_int

        movq    $3, 8(%rsp)     # x allocate in sp+8
        mov     8(%rsp), %rax
        add     %rax, %rax
        mov     %rax, (%rsp)    # y allocate in sp
        imul    8(%rsp), %rax   # x * y in %rax
        mov     %rax, %rdi      # and saved in %rdi

        mov     8(%rsp), %rax
        add     $3, %rax
        mov     %rax, (%rsp)    # z also allocate in sp

        mov     $0, %rdx
        mov     (%rsp), %rax
        idivq   %rax            # divide %rdx::%rax by %rax in %rax
        add     %rax, %rdi
        call    print_int

        add     $16, %rsp
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


## Local Variables:
## compile-command: "gcc local.s && ./a.out"
## End:

