.global sum_gcc7_O3
sum_gcc7_O3:
  testq %rdi, %rdi
  jle .L9
  movq %rsi, %rdx
  leaq -1(%rdi), %rcx
  movl $12, %r8d
  shrq %rdx
  negq %rdx
  andl $7, %edx
  leaq 7(%rdx), %rax
  cmpq $12, %rax
  cmovb %r8, %rax
  cmpq %rax, %rcx
  jb .L10
  testq %rdx, %rdx
  je .L11
  cmpq $1, %rdx
  movzwl (%rsi), %r8d
  je .L12
  addw 2(%rsi), %r8w
  cmpq $2, %rdx
  je .L13
  addw 4(%rsi), %r8w
  cmpq $3, %rdx
  je .L14
  addw 6(%rsi), %r8w
  cmpq $4, %rdx
  je .L15
  addw 8(%rsi), %r8w
  cmpq $5, %rdx
  je .L16
  addw 10(%rsi), %r8w
  cmpq $7, %rdx
  jne .L17
  addw 12(%rsi), %r8w
  movl $7, %r10d
.L4:
  movq %rdi, %r9
  pxor %xmm0, %xmm0
  subq %rdx, %r9
  leaq (%rsi,%rdx,2), %rcx
  xorl %edx, %edx
  movq %r9, %rax
  shrq $3, %rax
.L6:
  addq $1, %rdx
  paddw (%rcx), %xmm0
  addq $16, %rcx
  cmpq %rax, %rdx
  jb .L6
  movdqa %xmm0, %xmm1
  movq %r9, %rcx
  andq $-8, %rcx
  psrldq $8, %xmm1
  paddw %xmm1, %xmm0
  movdqa %xmm0, %xmm1
  leal (%r10,%rcx), %edx
  psrldq $4, %xmm1
  paddw %xmm1, %xmm0
  movdqa %xmm0, %xmm1
  psrldq $2, %xmm1
  paddw %xmm1, %xmm0
  pextrw $0, %xmm0, %eax
  addl %r8d, %eax
  cmpq %rcx, %r9
  je .L20
.L3:
  movslq %edx, %rcx
  addw (%rsi,%rcx,2), %ax
  leal 1(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 2(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 3(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 4(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 5(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 6(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 7(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 8(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 9(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 10(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 11(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addw (%rsi,%rcx,2), %ax
  leal 12(%rdx), %ecx
  movslq %ecx, %rcx
  cmpq %rcx, %rdi
  jle .L1
  addl $13, %edx
  addw (%rsi,%rcx,2), %ax
  movslq %edx, %rdx
  cmpq %rdx, %rdi
  jle .L1
  addw (%rsi,%rdx,2), %ax
  ret
.L9:
  xorl %eax, %eax
.L1:
  rep ret
.L13:
  movl $2, %r10d
  jmp .L4
.L12:
  movl $1, %r10d
  jmp .L4
.L11:
  xorl %r10d, %r10d
  xorl %r8d, %r8d
  jmp .L4
.L20:
  rep ret
.L10:
  xorl %edx, %edx
  xorl %eax, %eax
  jmp .L3
.L14:
  movl $3, %r10d
  jmp .L4
.L15:
  movl $4, %r10d
  jmp .L4
.L16:
  movl $5, %r10d
  jmp .L4
.L17:
  movl $6, %r10d
  jmp .L4
