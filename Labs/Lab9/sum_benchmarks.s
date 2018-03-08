	.file	"sum_benchmarks.c"
	.text
	.p2align 4,,15
	.globl	sum_C
	.type	sum_C, @function
sum_C:
.LFB638:
	.cfi_startproc
	testq	%rdi, %rdi
	jle	.L4
	leaq	(%rsi,%rdi,2), %rdx
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L3:
	addw	(%rsi), %ax
	addq	$2, %rsi
	cmpq	%rdx, %rsi
	jne	.L3
	rep ret
.L4:
	xorl	%eax, %eax
	ret
	.cfi_endproc
.LFE638:
	.size	sum_C, .-sum_C
	.p2align 4,,15
	.globl	sum_accums_C
	.type	sum_accums_C, @function
sum_accums_C:
.LFB639:
	.cfi_startproc
	cmpq	$7, %rdi
	jle	.L17
	leaq	-8(%rdi), %r10
	movq	%rsi, %rdx
	xorl	%r8d, %r8d
	shrq	$3, %r10
	movq	%r10, %rax
	salq	$4, %rax
	leaq	16(%rsi,%rax), %r9
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L9:
	movzwl	4(%rdx), %ecx
	addq	$16, %rdx
	addw	-16(%rdx), %cx
	addw	-8(%rdx), %cx
	addw	-4(%rdx), %cx
	addl	%ecx, %eax
	movzwl	-10(%rdx), %ecx
	addw	-14(%rdx), %cx
	addw	-6(%rdx), %cx
	addw	-2(%rdx), %cx
	addl	%ecx, %r8d
	cmpq	%r9, %rdx
	jne	.L9
	leal	8(,%r10,8), %edx
	leal	6(%rdx), %ecx
	movslq	%ecx, %rcx
.L7:
	cmpq	%rcx, %rdi
	jg	.L18
	leal	5(%rdx), %ecx
	movslq	%ecx, %rcx
	cmpq	%rcx, %rdi
	jg	.L19
	leal	4(%rdx), %ecx
	movslq	%ecx, %rcx
	cmpq	%rcx, %rdi
	jg	.L20
	leal	3(%rdx), %ecx
	movslq	%ecx, %rcx
	cmpq	%rcx, %rdi
	jg	.L21
	leal	2(%rdx), %ecx
	movslq	%ecx, %rcx
	cmpq	%rcx, %rdi
	jg	.L22
	leal	1(%rdx), %ecx
	movslq	%edx, %rdx
	movslq	%ecx, %rcx
	cmpq	%rcx, %rdi
	jg	.L23
	cmpq	%rdx, %rdi
	jle	.L11
	addw	(%rsi,%rdx,2), %ax
	jmp	.L11
	.p2align 4,,10
	.p2align 3
.L19:
	movslq	%edx, %rdx
	leaq	(%rdx,%rdx), %rcx
	addw	(%rsi,%rdx,2), %ax
	addw	2(%rsi,%rcx), %r8w
	addw	4(%rsi,%rcx), %ax
	addw	6(%rsi,%rcx), %r8w
	addw	8(%rsi,%rcx), %ax
	addw	10(%rsi,%rcx), %r8w
.L11:
	addl	%r8d, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L18:
	movslq	%edx, %rdx
	leaq	(%rdx,%rdx), %rcx
	addw	(%rsi,%rdx,2), %ax
	addw	4(%rsi,%rcx), %ax
	addw	2(%rsi,%rcx), %r8w
	addw	6(%rsi,%rcx), %r8w
	addw	8(%rsi,%rcx), %ax
	addw	10(%rsi,%rcx), %r8w
	addw	12(%rsi,%rcx), %ax
	addl	%r8d, %eax
	ret
.L21:
	movslq	%edx, %rdx
	leaq	(%rdx,%rdx), %rcx
	addw	(%rsi,%rdx,2), %ax
	addw	2(%rsi,%rcx), %r8w
	addw	4(%rsi,%rcx), %ax
	addw	6(%rsi,%rcx), %r8w
	jmp	.L11
	.p2align 4,,10
	.p2align 3
.L20:
	movslq	%edx, %rdx
	leaq	(%rdx,%rdx), %rcx
	addw	(%rsi,%rdx,2), %ax
	addw	4(%rsi,%rcx), %ax
	addw	2(%rsi,%rcx), %r8w
	addw	6(%rsi,%rcx), %r8w
	addw	8(%rsi,%rcx), %ax
	addl	%r8d, %eax
	ret
.L17:
	movl	$6, %ecx
	xorl	%edx, %edx
	xorl	%r8d, %r8d
	xorl	%eax, %eax
	jmp	.L7
.L22:
	movslq	%edx, %rdx
	leaq	(%rdx,%rdx), %rcx
	addw	(%rsi,%rdx,2), %ax
	addw	2(%rsi,%rcx), %r8w
	addw	4(%rsi,%rcx), %ax
	jmp	.L11
.L23:
	addw	(%rsi,%rdx,2), %ax
	addw	2(%rsi,%rdx,2), %r8w
	jmp	.L11
	.cfi_endproc
.LFE639:
	.size	sum_accums_C, .-sum_accums_C
	.globl	functions
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"sum_C: naive C compiled on this machine with settings in Makefile"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"sum_naive: naive ASM"
	.section	.rodata.str1.8
	.align 8
.LC2:
	.string	"sum_gcc5_O2: naive C compiled with GCC5 -O2"
	.align 8
.LC3:
	.string	"sum_gcc5_O3: naive C compiled with GCC5 -O3"
	.align 8
.LC4:
	.string	"sum_clang5_O: naive C compiled with clang 5.0 -O -msse4.2"
	.align 8
.LC5:
	.string	"sum_gcc7_O3: naive C compiled with GCC7 -O3 -msse4.2"
	.align 8
.LC6:
	.string	"sum_unrolled2: loop unroll by 2"
	.align 8
.LC7:
	.string	"sum_unrolled4: loop unroll by 4"
	.align 8
.LC8:
	.string	"sum_unrolled8: loop unroll by 8"
	.align 8
.LC9:
	.string	"sum_multiple_accum: 2 accumulators"
	.align 8
.LC10:
	.string	"sum_accums_C: multiple accumulators and loop unroll"
	.data
	.align 32
	.type	functions, @object
	.size	functions, 176
functions:
	.quad	sum_C
	.quad	.LC0
	.quad	sum_naive
	.quad	.LC1
	.quad	sum_gcc5_O2
	.quad	.LC2
	.quad	sum_gcc5_O3
	.quad	.LC3
	.quad	sum_clang5_O
	.quad	.LC4
	.quad	sum_gcc7_O3
	.quad	.LC5
	.quad	sum_unrolled2
	.quad	.LC6
	.quad	sum_unrolled4
	.quad	.LC7
	.quad	sum_unrolled8
	.quad	.LC8
	.quad	sum_multiple_accum
	.quad	.LC9
	.quad	sum_accums_C
	.quad	.LC10
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
