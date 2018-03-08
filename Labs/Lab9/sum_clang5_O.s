.global sum_clang5_O
sum_clang5_O:
  testq %rdi, %rdi
  jle .LBB0_1
  cmpq $15, %rdi
  ja .LBB0_6
  xorl %r8d, %r8d
  xorl %eax, %eax
  jmp .LBB0_4
.LBB0_1:
  xorl %eax, %eax
  retq
.LBB0_6:
  movq %rdi, %r8
  andq $-16, %r8
  leaq -16(%r8), %rcx
  movq %rcx, %rdx
  shrq $4, %rdx
  leal 1(%rdx), %eax
  andl $3, %eax
  cmpq $48, %rcx
  jae .LBB0_8
  pxor %xmm0, %xmm0
  xorl %edx, %edx
  pxor %xmm1, %xmm1
  testq %rax, %rax
  jne .LBB0_11
  jmp .LBB0_13
.LBB0_8:
  leaq -1(%rax), %rcx
  subq %rdx, %rcx
  pxor %xmm0, %xmm0
  xorl %edx, %edx
  pxor %xmm1, %xmm1
.LBB0_9: # =>This Inner Loop Header: Depth=1
  movdqu (%rsi,%rdx,2), %xmm2
  paddw %xmm0, %xmm2
  movdqu 16(%rsi,%rdx,2), %xmm0
  paddw %xmm1, %xmm0
  movdqu 32(%rsi,%rdx,2), %xmm1
  movdqu 48(%rsi,%rdx,2), %xmm3
  movdqu 64(%rsi,%rdx,2), %xmm4
  paddw %xmm1, %xmm4
  paddw %xmm2, %xmm4
  movdqu 80(%rsi,%rdx,2), %xmm2
  paddw %xmm3, %xmm2
  paddw %xmm0, %xmm2
  movdqu 96(%rsi,%rdx,2), %xmm0
  paddw %xmm4, %xmm0
  movdqu 112(%rsi,%rdx,2), %xmm1
  paddw %xmm2, %xmm1
  addq $64, %rdx
  addq $4, %rcx
  jne .LBB0_9
  testq %rax, %rax
  je .LBB0_13
.LBB0_11:
  leaq 16(%rsi,%rdx,2), %rcx
  negq %rax
.LBB0_12: # =>This Inner Loop Header: Depth=1
  movdqu -16(%rcx), %xmm2
  paddw %xmm2, %xmm0
  movdqu (%rcx), %xmm2
  paddw %xmm2, %xmm1
  addq $32, %rcx
  incq %rax
  jne .LBB0_12
.LBB0_13:
  paddw %xmm1, %xmm0
  pshufd $78, %xmm0, %xmm1 # xmm1 = xmm0[2,3,0,1]
  paddw %xmm0, %xmm1
  pshufd $229, %xmm1, %xmm0 # xmm0 = xmm1[1,1,2,3]
  paddw %xmm1, %xmm0
  phaddw %xmm0, %xmm0
  movd %xmm0, %eax
  cmpq %rdi, %r8
  je .LBB0_14
.LBB0_4:
  leaq (%rsi,%r8,2), %rcx
  subq %r8, %rdi
.LBB0_5: # =>This Inner Loop Header: Depth=1
  addw (%rcx), %ax
  addq $2, %rcx
  decq %rdi
  jne .LBB0_5
.LBB0_14:
  retq
