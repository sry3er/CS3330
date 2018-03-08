// This is a naive assembly translation of the following C code:
// data_type sum_multiple_accum(long size, data_type * a) {
//    data_type sum1 = 0;
//    data_type sum2 = 0;
//    for (int i = 0; i+1 < size; i+=2) {
//        sum1 += a[i];
//        sum2 += a[i+1];
//    }
//    if (i<size)
//    {
//        sum1 += a[i];
//    }
//    return sum1+sum2;
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
.global sum_multiple_accum1
sum_multiple_accum1:
    // set sum1 (%ax) to 0
    xor %eax, %eax
    // set sum2 (%bx) to 0
    xor %edx, %edx
    // return immediately; special case if size (%rdi) == 0
    test %rdi, %rdi
    je .L_done
    // set i (%rcx) to 0
    xor %rcx, %rcx
// labels starting with '.L' are local to this file
.L_loop:
    addq $1, %rcx
    cmpq %rdi, %rcx
    jge .L_1
    subq $1, %rcx
    addw (%rsi,%rcx,2), %ax
    addw 2(%rsi,%rcx,2), %dx
    addq $2, %rcx
    jmp .L_loop
.L_1:
    //subq $1, %rcx
    cmpq %rdi, %rcx
    jge .L_done
    addw (%rsi,%rcx,2), %ax
.L_done:
    addw %dx, %ax
    retq
