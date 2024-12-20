.text
.globl	main

// 🎉
.set N, 15

f:
	// not necessary to push %rbp❌
	// pushq %rbp
	// movq %rsp, %rbp
	// pushq %rbx #?

	xorq %rax, %rax # s = 0

	cmpq $N, %rdi # i == N ?
	je exit

	// int key = (c << 4) | i;
	movq %rsi, %rdx
	salq $4, %rdx
	orq %rdi, %rdx

	// if (r != 0) return r;✅
	movl    memo(,%rdx,4), %eax
	// why not load to rax❓bcz memo is 4 bytes long(maybe)

	testq %rax, %rax
	jnz exit
	xorq %rcx, %rcx # j = 0

	jmp test

.Lloop_j:
	movq $1, %r8
	salq %cl, %r8

	testq %rsi, %r8 # c & col == 0 ?
	jz .Lcontinue_j

	// going to call f(i + 1, c - col), saving s, i, c, key, j
	pushq %rax # s, bcz f only return if and only if r != 0. So, here rax must be the same as s, which is 0
	pushq %rdi # i
	pushq %rsi # c
	pushq %rdx # key
	pushq %rcx # j

	incq %rdi
	subq %r8, %rsi

	call f
	
	// restauration
	movq %rax, %r8 # return value to r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
	popq %rax
	movq %rdi, %r9 # do i * 15
	imulq $N, %r9
	addq %rcx, %r9 # do i * 15 + j
	movl m(,%r9,4), %r9d
	addq %r9, %r8 # x = m[i][j] + f(...)
	cmpq %rax, %r8 # x > s ?
	cmovg %r8, %rax # do mov is comparison is greater

.Lcontinue_j:
	incq %rcx

test:
	cmpq $N, %rcx
	jl .Lloop_j
	movl %eax, memo(,%rdx,4)

exit:
	ret
main:
	// main function does not require stack frame
	// pushq %rbp
	// movq %rsp, %rbp

	subq $8, %rsp # alignement ⭐
	movq $0, %rdi
	movq $1, %rsi
	salq $N, %rsi
	decq %rsi
	call f
	movq $fmt, %rdi # does not support PIC
	// leaq fmt(%rip), %rdi supports PIC	
	movq %rax, %rsi
	xorq %rax, %rax
	call printf
	xorq %rax, %rax
	addq $8, %rsp # alignement ⭐
	ret


	.data
fmt:
	.string "solution = %d\n"
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
