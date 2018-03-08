// This is a naive assembly translation of the following C code:
// data_type sum_unrolled4(long size, data_type * a) {
//    data_type sum = 0;
//    for (int i = 0; i+3 < size; i+=4) {
//        sum += a[i];
//        sum += a[i+1];
//        sum += a[i+2];
//        sum += a[i+3];
//    }
//    if (i+2<size)
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
.global sum_unrolled4
sum_unrolled4:
    // set sum (%ax) to 0
    xor %eax, %eax
    // return immediately; special case if size (%rdi) == 0
    test %rdi, %rdi
    je .L_done
    // set i (%rcx) to 0
    xor %rcx, %rcx
// labels starting with '.L' are local to this file
.L_loop:
    addq $3, %rcx
    cmpq %rdi, %rcx
    jge .L_1
    subq $3, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    addw 4(%rsi,%rcx,2), %ax
    addw 6(%rsi,%rcx,2), %ax
    addq $4, %rcx
    jmp .L_loop
.L_1:
    subq $3, %rcx
    addq $2, %rcx
    cmpq %rdi, %rcx
    jge .L_2
    subq $2, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    addw 4(%rsi,%rcx,2), %ax
    jmp .L_2_1
.L_2:
    subq $2, %rcx
.L_2_1:
    addq $1, %rcx
    cmpq %rdi, %rcx
    jge .L_3
    subq $1, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %ax
    jmp .L_3_1
.L_3:
    subq $1, %rcx
.L_3_1:
    cmpq %rdi, %rcx
    jge .L_done
    addw (%rsi,%rcx,2), %ax
.L_done:
    retq
