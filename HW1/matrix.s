.text
.globl	main

main:
	pushq %rbp
	movq %rsp, %rbp
	movl $0, %edi
	movl $0x7fff, %esi

	call f

	movl %eax, %esi
	leaq fmt(%rip), %rdi
	xorq %rax, %rax
	call printf

	xorq %rax, %rax
	popq %rbp
	ret

f:
	pushq %rbp
	movq %rsp, %rbp
	pushq %rbx #?
	subq $0x38, %rsp
	movl %edi, -0x34(%rbp) # i
	movl %esi, -0x38(%rbp) # c
	cmpl $15, -0x34(%rbp)

	jne .Lnot_end
	movl $0, %eax
	jmp .Lret

.Lnot_end:
	// int key = (c << 4) | i;
	movl -0x38(%rbp), %eax
	shll $4, %eax
	orl -0x34(%rbp), %eax
	movl %eax, -0x20(%rbp) # key
	movl -0x20(%rbp), %eax
	movslq
	// int r = memo[key];🐛

	// 😭
	// lea 0(,%rax,4), %rdx
	// leaq memo(%rip), %rax
	// movl (%rdx,%rax), %eax

	// ❓2
	leaq memo(%rip), %rdx
	movq (%rdx,%rax,4), %rax
	
	// ❓1
	// lea memo(%rip), %rdx
	// movl (%rdx,%rax,4), %eax
	// cmpl $0, %eax

	// 😭
	movl %eax, -0x1c(%rbp)
	cmpl $0, -0x1c(%rbp)
	
	je .Lmemo_not_found

	// 😭 I type additional 'c'
	movl -0x1c(%rbp), %eax
	jmp .Lret

.Lmemo_not_found:
	movl $0, -0x24(%rbp) # j
	movl $0, -0x28(%rbp) # s
	jmp .Lif_j

.Lloop_j:
	movl -0x24(%rbp), %eax
	movl $1, %edx
	movl %eax, %ecx
	shll %cl, %edx
	movl %edx, %eax
	movl %eax, -0x18(%rbp) # col
	movl -0x38(%rbp), %eax
	andl -0x18(%rbp), %eax
	testl %eax, %eax
	je .Lcontinue_j

	movl -0x24(%rbp), %eax
	movslq %eax, %rcx # j
	movl -0x34(%rbp), %eax
	movslq %eax, %rdx # i
	
	// 😭
	movq %rdx, %rax
	shlq $4, %rax
	subq %rdx, %rax # i * 15?
	addq %rcx, %rax
	leaq 0(,%rax,4), %rdx
	leaq m(%rip), %rax
	movl (%rdx,%rax), %ebx
	movl -0x38(%rbp), %eax
	subl -0x18(%rbp), %eax
	movl -0x34(%rbp), %edx
	addl $1, %edx
	movl %eax, %esi
	movl %edx, %edi

	// ❓
	// shlq $4, %rdx
	// subq %rdx, %rdx
	// movl -0x24(%rbp), %eax
	// addq %rax, %rdx
	// leaq m(%rip), %rcx
	// movl (%rcx,%rdx,4), %ebx

	call f

	addl %ebx, %eax
	movl %eax, -0x14(%rbp)
	movl -0x14(%rbp), %eax

	cmpl -0x28(%rbp), %eax
	jle .Lcontinue_j
	movl -0x14(%rbp), %eax
	movl %eax, -0x28(%rbp)
	jmp .Lcontinue_j

.Lcontinue_j:
	addl $1, -0x24(%rbp)
.Lif_j:
	cmpl $15, -0x24(%rbp)
	jle .Lloop_j
	movl -20(%rbp), %eax # key
	cdqe
	lea memo(,%rax,4), %rcx
	leaq   memo(%rip), %rdx
	movl   -0x28(%rbp), %eax
	movl   %eax, (%rcx,%rdx)
	movl   -0x28(%rbp), %eax
	movq   -0x8(%rbp), %rbx
	leave
	ret
.Lret:
	mov -0x8(%rbp), %rbx
    leave
    ret

	.data
fmt: .asciz "solution = %d\n"

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
