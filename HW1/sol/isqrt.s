	.text
	.globl	main

## int isqrt(int n) {
##   int c = 0, s = 1;
##   while (s <= n) {
##      c++;
##      s += 2*c + 1;
##   }
##   return c;
## }

isqrt:
	xorq	%rax, %rax	# c in %rax because return c in the end
	movq	$1, %rcx	# s in %rcx caller-save
	jmp	T1
L1:
	incq	%rax
	leaq	1(%rcx, %rax, 2), %rax
T1:
	cmpq	%rdi, %rcx	# s <= n ?
	jle	L1
	ret

## int main () {
##   int n;
##   for (n = 0; n <= 20; n++)
##     printf("sqrt(%2d) = %2d\n", n, isqrt(n));
##   return 0;
## }

main:
	pushq	%rbx		# save %rbx and align the stack
	movq	$0, %rbx	# n in %rbx (callee-save)
L2:
	movq	%rbx, %rdi
	call	isqrt
	movq	$format, %rdi	# first argument (format)
	movq	%rbx, %rsi	# second argument (n)
	movq	%rax, %rdx	# third argument (isqrt(n))
	xorq	%rax, %rax	# %rax = 0 = no register vectors
	call	printf
	incq	%rbx		# n++
	cmpq	$20, %rbx	# n <= 20 ?
	jle	L2
	xorq	%rax, %rax	# exit with code 0
	popq	%rbx
	ret

	.data
format:
	.string	"sqrt(%2d) = %2d\n"
	
