#include <stdlib.h>
#include <stdio.h>

/*
allEvenBits - return 1 if all even-numbered bits in word set to 1
  Examples allEvenBits(0xFFFFFFFE) = 0, allEvenBits(0x55555555) = 1
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 12
  Rating: 2
*/
int allEvenBits(int x) {
    //idea is that 0x55 = 01010101
    //we judge all 8 bytes to and them to satisfy
    return !(((x & 0x55) & ((x>>8) &0x55) & ((x>>16) &0x55) & ((x>>24) &0x55)) ^ 0x55);
}

/*
byteSwap - swaps the nth byte and the mth byte
 Examples: byteSwap(0x12345678, 1, 3) = 0x56341278
           byteSwap(0xDEADBEEF, 0, 2) = 0xDEEFBEAD
 You may assume that 0 <= n <= 3, 0 <= m <= 3
 Legal ops: ! ~ & ^ | + << >>
 Max ops: 25
 Rating: 2
*/
int byteSwap(int x, int n, int m) {
    int a = ((x>>(n<<3)) & 0xff)<<(m<<3);
    //printf("a[%x]\n", a);
    int b = ((x>>(m<<3)) & 0xff)<<(n<<3);
    //printf("b[%x]\n", b);
    
    //put 0's in swapped bytes of x
    int c = x;
    //printf("c[%x]\n", c);
    c = c ^ ((x>>(n<<3)) & 0xff)<<(n<<3);
    //printf("c[%x]\n", c);
    c = c ^ ((x>>(m<<3)) & 0xff)<<(m<<3);
    //printf("c[%x]\n", c);
    //put swapped bytes and a,b together
    
    c = c | a;
    //printf("c[%x]\n", c);
    c = c | b;
    //printf("c[%x]\n", c);
    return c;
    
}

/*
multFiveEighths - multiplies by 5/8 rounding toward 0.
  Should exactly duplicate effect of C expression (x*5/8),
  including overflow behavior.
  Examples: multFiveEighths(77) = 48
            multFiveEighths(-22) = -13
            multFiveEighths(1073741824) = 13421728 (overflow)
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 12
  Rating: 3
*/
int multFiveEighths(int x) {
    
      int multFive = (x << 2) + x;
  
      // if multFive is negative, add 2^3 - 1 = 7 before right shift
      int addNum = 7 & (multFive >> 31);
      int divEight = (multFive + addNum) >> 3;
      
      return divEight;
}

/*
addOK - Determine if can compute x+y without overflow
  Example: addOK(0x80000000,0x80000000) = 0,
           addOK(0x80000000,0x70000000) = 1, 
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 20
  Rating: 3
*/
int addOK(int x, int y) {
    //idea is:
    //if opposite sign, then must be ok
    //If two signs are the same and the sum has different sign, then overflow
    //if one of them is 0, then must be ok
    
    
    int result = 0;
    int a = ((x>>31) ^ (y>>31)) & 1;  //decide if are opposite sign, if opposite, then must be OK
    
   
    int g = !((((x + y) >>31) & 1) ^ ((x>>31) & 1));
    //if x or y is 0, then must be ok
    int f = !(x | 0) | !(y | 0);
    result = a | g | f;
    return result;
}

/*
bitParity - returns 1 if x contains an odd number of 0's
  Examples: bitParity(5) = 0, bitParity(7) = 1
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 20
  Rating: 4
*/
int bitParity(int x) {
    int y = x;
    y ^= y >> 16;
    y ^= y >> 8;
    y ^= y >> 4;
    y ^= y >> 2;
    y ^= y >> 1;
    y &= 1;
    return y;
}

int main()
{
    printf("allEvenBits(0xFFFFFFFE) = %d\n", allEvenBits(0xFFFFFFFE));      // = 0
    printf("allEvenBits(0x55555555) = %d\n", allEvenBits(0x55555555));      // = 1
    
    printf("byteSwap(0x12345678, 1, 3) = %x\n", byteSwap(0x12345678, 1, 3));      // = 0x56341278
    printf("byteSwap(0xDEADBEEF, 0, 2) = %x\n", byteSwap(0xDEADBEEF, 0, 2));      // = 0xDEEFBEAD
    printf("byteSwap(0xfffffffe, 0, 3) = %x\n", byteSwap(0xfffffffe, 0, 3));      // = 0xDEEFBEAD
    
    printf("multFiveEighths(0xfffffffe) = %x\n", multFiveEighths(0xfffffffe));      // -2 *5/8 = -1 0xffffffff
    printf("multFiveEighths(0xffffffff) = %x\n", multFiveEighths(0xffffffff));      // -1 *5/8 = 0 0x0
    printf("multFiveEighths(1073741824) = %x\n", multFiveEighths(1073741824)); 
    
    printf("bitParity(5) = %x\n", bitParity(5));   //bitParity(5) = 0
    printf("bitParity(7) = %x\n", bitParity(7));   //bitParity(7) = 1
    
    return 0;
}