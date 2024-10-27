        .text
        .globl  main
main:
        ## true && false
        mov     $1, %rdi
        test    %rdi, %rdi
        jz      .T0             # the operator && is lazy
        mov     $0, %rdi
.T0:
        call    print_bool

        ## if 3 <> 4 then 10 * 2 else 14
        mov     $3, %rdi
        cmp     $4, %rdi
        je      .T1false
        mov     $10, %rdi
        imul    $2, %rdi
        jmp     .T1
.T1false:
        mov     $14, %rdi
.T1:
        call    print_int

        ## 2 = 3 || 4 <= 2*3
        mov     $2, %rdi
        cmp     $3, %rdi
        sete    %dil
        movzbq  %dil, %rdi      # movzbq = mov with zero extension
        test    %rdi, %rdi
        jnz     .T2             # the operator || is lazy
        mov     $4, %rbx
        mov     $2, %rcx
        imul    $3, %rcx
        cmp     %rcx, %rbx      # beware the meaning !
        setle   %bl
        movzbq  %bl, %rdi
.T2:
        call    print_bool

	mov     $0, %rax        # exit with code 0
        ret

        ## a routine for print an integer (%rdi) with printf
print_int:
        mov     %rdi, %rsi
        mov     $message, %rdi  # arguments for printf
        mov     $0, %rax
        call    printf
        ret

        ## a routine for print a boolean (%rdi) with printf
print_bool:
        cmp     $0, %rdi
        je      .Lfalse
        mov     $true, %rdi
        jmp     .Lprint
.Lfalse:
        mov     $false, %rdi
.Lprint:
        mov     $0, %rax
        call    printf
        ret

        .data
message:
        .string "%d\n"
true:
        .string "true\n"
false:
        .string "false\n"



