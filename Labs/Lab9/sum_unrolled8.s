// This is a naive assembly translation of the following C code:
// data_type sum_unrolled8(long size, data_type * a) {
//    data_type sum = 0;
//    for (int i = 0; i+7 < size; i+=8) {
//        sum += a[i];
//        sum += a[i+1];
//        sum += a[i+2];
//        sum += a[i+3];
//        sum += a[i+4];
//        sum += a[i+5];
//        sum += a[i+6];
//        sum += a[i+7];
//    }
//    if (i+6<size)
//    {
//        sum += a[i];
//        sum += a[i+1];
//        sum += a[i+2];
//        sum += a[i+3];
//        sum += a[i+4];
//        sum += a[i+5];
//        sum += a[i+6];
//    }
//    else if (i+5<size)
//    {
//        sum += a[i];
//        sum += a[i+1];
//        sum += a[i+2];
//        sum += a[i+3];
//        sum += a[i+4];
//        sum += a[i+5];
//    }
//    else if (i+4<size)
//    {
//        sum += a[i];
//        sum += a[i+1];
//        sum += a[i+2];
//        sum += a[i+3];
//        sum += a[i+4];
//    }
//    else if (i+3<size)
//    {
//        sum += a[i];
//        sum += a[i+1];
//        sum += a[i+2];
//        sum += a[i+3];
//    }
//    else if (i+2<size)
//    {
//        sum += a[i];
//        sum += a[i+1];
//        sum += a[i+2];
//    }
//    else if (i+1<size)
//    {
//        sum += a[i];
//        sum += a[i+1];
//    }
//    else if (i<size)
//    {
//        sum += a[i];
//    }
//    else {}
//    return sum;
// }
// where data_type is a unsigned short (or short).

// This implementation follows the Linux x86-64 calling convention:
//    %rdi contains the size
//    %rsi contains the pointer a
// and
//    %ax needs to contain the result when the function returns
// in addition, this code uses %rcx to store i

// the '.global' directive indicates to the assembler to make this symbol 
// available to other files.
.global sum_unrolled8
sum_unrolled8:
    // set sum (%ax) to 0
    xor %eax, %eax
    // return immediately; special case if size (%rdi) == 0
    test %rdi, %rdi
    je .L_done
    // set i (%rcx) to 0
    xor %rcx, %rcx
// labels starting with '.L' are local to this file
.L_loop:
    addq $7, %rcx
    cmpq %rdi, %rcx
    jge .L_1
    subq $7, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    addw 4(%rsi,%rcx,2), %ax
    addw 6(%rsi,%rcx,2), %ax
    addw 8(%rsi,%rcx,2), %ax
    addw 10(%rsi,%rcx,2), %ax
    addw 12(%rsi,%rcx,2), %ax
    addw 14(%rsi,%rcx,2), %ax
    addq $8, %rcx
    jmp .L_loop
.L_1:
    subq $7, %rcx
    addq $6, %rcx
    cmpq %rdi, %rcx
    jge .L_2
    subq $6, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    addw 4(%rsi,%rcx,2), %ax
    addw 6(%rsi,%rcx,2), %ax
    addw 8(%rsi,%rcx,2), %ax
    addw 10(%rsi,%rcx,2), %ax
    addw 12(%rsi,%rcx,2), %ax
    jmp .L_2_1
.L_2:
    subq $6, %rcx
.L_2_1:
    addq $5, %rcx
    cmpq %rdi, %rcx
    jge .L_3
    subq $5, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    addw 4(%rsi,%rcx,2), %ax
    addw 6(%rsi,%rcx,2), %ax
    addw 8(%rsi,%rcx,2), %ax
    addw 10(%rsi,%rcx,2), %ax
    jmp .L_3_1
.L_3:
    subq $5, %rcx
.L_3_1:
    addq $4, %rcx
    cmpq %rdi, %rcx
    jge .L_4
    subq $4, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    addw 4(%rsi,%rcx,2), %ax
    addw 6(%rsi,%rcx,2), %ax
    addw 8(%rsi,%rcx,2), %ax
    jmp .L_4_1
.L_4:
    subq $4, %rcx
.L_4_1:
    addq $3, %rcx
    cmpq %rdi, %rcx
    jge .L_5
    subq $3, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    addw 4(%rsi,%rcx,2), %ax
    addw 6(%rsi,%rcx,2), %ax
    jmp .L_5_1
.L_5:
    subq $3, %rcx
.L_5_1:
    addq $2, %rcx
    cmpq %rdi, %rcx
    jge .L_6
    subq $2, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    addw 4(%rsi,%rcx,2), %ax
    jmp .L_6_1
.L_6:
    subq $2, %rcx
.L_6_1:
    addq $1, %rcx
    cmpq %rdi, %rcx
    jge .L_7
    subq $1, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    jmp .L_7_1
.L_7:
    subq $1, %rcx
.L_7_1:
    cmpq %rdi, %rcx
    jge .L_done
    addw (%rsi,%rcx,2), %ax
.L_done:
    retq
