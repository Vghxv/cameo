	.text
	.globl	main
main:
	subq	$8, %rsp	# alignment
	movq	$format, %rdi	# first argument (format)
	movq	$42, %rsi	# second argument (n)
	xorq	%rax, %rax	# %rax = 0 = no register vector
	call	printf
	xorq	%rax, %rax	# exit with the code 0
	addq	$8, %rsp
	ret

	.data
format:
	.string	"n = %d\n" 
