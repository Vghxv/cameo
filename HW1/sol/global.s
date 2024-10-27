        .text
        .globl  main
main:
        movq    $2, x
        mov     x, %rcx
        imul    %rcx, %rcx
        mov     %rcx, y
        mov     x, %rdi
        add     y, %rdi
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
x:
        .quad   0
y:
        .quad   0

## Local Variables:
## compile-command: "gcc -no-pie global.s && ./a.out"
## End:

