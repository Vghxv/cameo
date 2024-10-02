.text
.globl	main
f:
	pushq %rbp
	movq %rsp, %rbp
	subq $80, %rsp

	// store i and c to stack
	movq %rdi, 8(%rsp)
	movq %rsi, 16(%rsp)

	// if (i == N) return 0;
	movq N(%rip), %rax
	cmpq %rax, %rdi
	je return_0

	// Compute key = (c << L) | i
	movq 16(%rsp), %rdx
	movq $4, %rcx
	shlq %cl, %rdx
	orq 8(%rsp), %rdx
	movq %rdx, 24(%rsp)

	// Load memo[key] into %rax
	movq 24(%rsp), %rcx
	movl memo(,%rcx,4), %eax
	movl %eax, 32(%rsp)
	testl %eax, %eax 
	jne return_memo

	// int s = 0; int j = 0;
	movl $0, 40(%rsp)
	movl $0, 48(%rsp)

loop_j:
	cmpq $15, 48(%rsp)
	jge end_loop_j

	movq $1, %rax
	movb 48(%rsp), %cl
	shlq %cl, %rax
	movq %rax, 56(%rsp)

	movq 16(%rsp), %r8
	andq 56(%rsp), %r8
	testq %r8, %r8
	jz continue_j

	// x = m[i][j] + f(i + 1, c - col)
	// m[i][j]
	movq 8(%rsp), %r9
	imulq $15, %r9
	addq 48(%rsp), %r9
	leaq m(,%r9,4), %r9
	movq %r9, 64(%rsp)
	
	// i + 1
	movl 8(%rsp), %edi
	incl %eax

	// c - col
	movq 16(%rsp), %rsi
	subq 56(%rsp), %rsi

	call f

	movl 64(%rsp), %edx
	addl %eax, %edx
	cmpq 40(%rsp), %rax
	jle continue_j
	movq %rax, 40(%rsp)

continue_j:
	incq 48(%rsp)
	jmp loop_j

end_loop_j:

	movl 40(%rsp), %eax
	movq 24(%rsp), %rcx
	movl %eax, memo(, %rcx, 4)
	addq $64, %rsp
	movq %rsp, %rsp
    popq %rsp
	ret

return_0:
	movq 8(%rsp), %rdi
	movq 16(%rsp), %rsi
	xorq %rax, %rax
	addq $64, %rsp
	movq %rsp, %rsp
	popq %rsp
	ret

return_memo:
	movq 24(%rsp), %rcx
	movl memo(,%rcx,4), %eax
	addq $64, %rsp
	movq %rbp, %rsp
	popq %rbp
	ret

main:
	pushq %rbp
	movq %rsp, %rbp

	xorq %rdi, %rdi
	movq $1, %rsi
	movq N(%rip), %rcx
	shlq %cl, %rsi
	decq %rsi

	call f

	movq %rax, %rsi
	leaq result_msg(%rip), %rdi
	
	call printf
	
	xorq %rax, %rax
	movq %rbp, %rsp
	popq %rbp
	ret

.data
result_msg: .asciz "solution: %d\n"
N: .long 15
L: .long 4
m:
	.long	7
	.long	53
	.long	183
	.long	439
	.long	863
	.long	497
	.long	383
	.long	563
	.long	79
	.long	973
	.long	287
	.long	63
	.long	343
	.long	169
	.long	583
	.long	627
	.long	343
	.long	773
	.long	959
	.long	943
	.long	767
	.long	473
	.long	103
	.long	699
	.long	303
	.long	957
	.long	703
	.long	583
	.long	639
	.long	913
	.long	447
	.long	283
	.long	463
	.long	29
	.long	23
	.long	487
	.long	463
	.long	993
	.long	119
	.long	883
	.long	327
	.long	493
	.long	423
	.long	159
	.long	743
	.long	217
	.long	623
	.long	3
	.long	399
	.long	853
	.long	407
	.long	103
	.long	983
	.long	89
	.long	463
	.long	290
	.long	516
	.long	212
	.long	462
	.long	350
	.long	960
	.long	376
	.long	682
	.long	962
	.long	300
	.long	780
	.long	486
	.long	502
	.long	912
	.long	800
	.long	250
	.long	346
	.long	172
	.long	812
	.long	350
	.long	870
	.long	456
	.long	192
	.long	162
	.long	593
	.long	473
	.long	915
	.long	45
	.long	989
	.long	873
	.long	823
	.long	965
	.long	425
	.long	329
	.long	803
	.long	973
	.long	965
	.long	905
	.long	919
	.long	133
	.long	673
	.long	665
	.long	235
	.long	509
	.long	613
	.long	673
	.long	815
	.long	165
	.long	992
	.long	326
	.long	322
	.long	148
	.long	972
	.long	962
	.long	286
	.long	255
	.long	941
	.long	541
	.long	265
	.long	323
	.long	925
	.long	281
	.long	601
	.long	95
	.long	973
	.long	445
	.long	721
	.long	11
	.long	525
	.long	473
	.long	65
	.long	511
	.long	164
	.long	138
	.long	672
	.long	18
	.long	428
	.long	154
	.long	448
	.long	848
	.long	414
	.long	456
	.long	310
	.long	312
	.long	798
	.long	104
	.long	566
	.long	520
	.long	302
	.long	248
	.long	694
	.long	976
	.long	430
	.long	392
	.long	198
	.long	184
	.long	829
	.long	373
	.long	181
	.long	631
	.long	101
	.long	969
	.long	613
	.long	840
	.long	740
	.long	778
	.long	458
	.long	284
	.long	760
	.long	390
	.long	821
	.long	461
	.long	843
	.long	513
	.long	17
	.long	901
	.long	711
	.long	993
	.long	293
	.long	157
	.long	274
	.long	94
	.long	192
	.long	156
	.long	574
	.long	34
	.long	124
	.long	4
	.long	878
	.long	450
	.long	476
	.long	712
	.long	914
	.long	838
	.long	669
	.long	875
	.long	299
	.long	823
	.long	329
	.long	699
	.long	815
	.long	559
	.long	813
	.long	459
	.long	522
	.long	788
	.long	168
	.long	586
	.long	966
	.long	232
	.long	308
	.long	833
	.long	251
	.long	631
	.long	107
	.long	813
	.long	883
	.long	451
	.long	509
	.long	615
	.long	77
	.long	281
	.long	613
	.long	459
	.long	205
	.long	380
	.long	274
	.long	302
	.long	35
	.long	805
        .bss
memo:
        .space	2097152

## Local Variables:
## compile-command: "gcc matrix.s && ./a.out"
## End:
