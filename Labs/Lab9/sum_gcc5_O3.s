	.file	"sum.c"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB0:
	.text
.LHOTB0:
	.p2align 4,,15
	.globl	sum_gcc5_O3
	.type	sum_gcc5_O3, @function
sum_gcc5_O3:
.LFB0:
	.cfi_startproc
	testq	%rdi, %rdi
	jle	.L13
	movq	%rsi, %rdx
	andl	$15, %edx
	shrq	%rdx
	negq	%rdx
	andl	$7, %edx
	cmpq	%rdi, %rdx
	cmova	%rdi, %rdx
	cmpq	$13, %rdi
	jg	.L32
	movq	%rdi, %rdx
.L3:
	cmpq	$1, %rdx
	movzwl	(%rsi), %eax
	je	.L16
	addw	2(%rsi), %ax
	cmpq	$2, %rdx
	je	.L17
	addw	4(%rsi), %ax
	cmpq	$3, %rdx
	je	.L18
	addw	6(%rsi), %ax
	cmpq	$4, %rdx
	je	.L19
	addw	8(%rsi), %ax
	cmpq	$5, %rdx
	je	.L20
	addw	10(%rsi), %ax
	cmpq	$6, %rdx
	je	.L21
	addw	12(%rsi), %ax
	cmpq	$7, %rdx
	je	.L22
	addw	14(%rsi), %ax
	cmpq	$8, %rdx
	je	.L23
	addw	16(%rsi), %ax
	cmpq	$9, %rdx
	je	.L24
	addw	18(%rsi), %ax
	cmpq	$10, %rdx
	je	.L25
	addw	20(%rsi), %ax
	cmpq	$11, %rdx
	je	.L26
	addw	22(%rsi), %ax
	cmpq	$13, %rdx
	jne	.L27
	addw	24(%rsi), %ax
	movl	$13, %ecx
.L5:
	cmpq	%rdx, %rdi
	je	.L33
.L4:
	movq	%rdi, %r10
	leaq	-1(%rdi), %r9
	subq	%rdx, %r10
	leaq	-8(%r10), %r8
	subq	%rdx, %r9
	shrq	$3, %r8
	addq	$1, %r8
	cmpq	$6, %r9
	leaq	0(,%r8,8), %r11
	jbe	.L7
	pxor	%xmm0, %xmm0
	leaq	(%rsi,%rdx,2), %r9
	xorl	%edx, %edx
.L8:
	addq	$1, %rdx
	paddw	(%r9), %xmm0
	addq	$16, %r9
	cmpq	%rdx, %r8
	ja	.L8
	movdqa	%xmm0, %xmm1
	addl	%r11d, %ecx
	psrldq	$8, %xmm1
	paddw	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$4, %xmm1
	paddw	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$2, %xmm1
	paddw	%xmm1, %xmm0
	pextrw	$0, %xmm0, %edx
	addl	%edx, %eax
	cmpq	%r11, %r10
	je	.L2
.L7:
	movslq	%ecx, %rdx
	addw	(%rsi,%rdx,2), %ax
	leal	1(%rcx), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rdi
	jle	.L2
	addw	(%rsi,%rdx,2), %ax
	leal	2(%rcx), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rdi
	jle	.L2
	addw	(%rsi,%rdx,2), %ax
	leal	3(%rcx), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rdi
	jle	.L2
	addw	(%rsi,%rdx,2), %ax
	leal	4(%rcx), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rdi
	jle	.L2
	addw	(%rsi,%rdx,2), %ax
	leal	5(%rcx), %edx
	movslq	%edx, %rdx
	cmpq	%rdx, %rdi
	jle	.L2
	addl	$6, %ecx
	addw	(%rsi,%rdx,2), %ax
	movslq	%ecx, %rcx
	cmpq	%rcx, %rdi
	jle	.L34
	addw	(%rsi,%rcx,2), %ax
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	xorl	%eax, %eax
.L2:
	rep ret
	.p2align 4,,10
	.p2align 3
.L33:
	rep ret
	.p2align 4,,10
	.p2align 3
.L32:
	testq	%rdx, %rdx
	jne	.L3
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L34:
	rep ret
	.p2align 4,,10
	.p2align 3
.L22:
	movl	$7, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L23:
	movl	$8, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L24:
	movl	$9, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L25:
	movl	$10, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L21:
	movl	$6, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L20:
	movl	$5, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L18:
	movl	$3, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L19:
	movl	$4, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L26:
	movl	$11, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L27:
	movl	$12, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L16:
	movl	$1, %ecx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L17:
	movl	$2, %ecx
	jmp	.L5
	.cfi_endproc
.LFE0:
	.size	sum_gcc5_O3, .-sum_gcc5_O3
	.section	.text.unlikely
.LCOLDE0:
	.text
.LHOTE0:
	.ident	"GCC: (Ubuntu 5.4.1-2ubuntu1~16.04) 5.4.1 20160904"
	.section	.note.GNU-stack,"",@progbits
