#include <stdlib.h>
#include <stdio.h>
/*
thirdBits - return word with every third bit (starting from the LSB) set to 1
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 8
  Rating: 1
*/
int thirdBits() {
    int x = 0x49 | 0x49<<6 | 0x49<<12 | 0x49<<18 | 0x49<<24;
    return x;
}

/*
bang - Compute !x without using !
  Examples: bang(3) = 0, bang(0) = 1
  Legal ops: ~ & ^ | + << >>
  Max ops: 12
  Rating: 4 
*/
int bang(int x) {
    //idea is that 0 is the only number that 0 and -0 has 0 as sign bit
    return ((x>>31)) | ((~x + 1) >>31) + 1; 
}

/*
isEqual - return 1 if x == y, and 0 otherwise 
  Examples: isEqual(5,5) = 1, isEqual(4,5) = 0
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 5
  Rating: 2
*/
int isEqual(int x, int y) {
  //if x - y ==0,then equal
  return !(x+ (~y +1));
}

/*
bitMask - Generate a mask consisting of all 1's 
  between lowbit and highbit, inclusive
  Examples: bitMask(5,3) = 0x38
  Assume 0 <= lowbit <= 31, and 0 <= highbit <= 31
  If lowbit > highbit, then mask should be all 0's
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 16
  Rating: 3
*/
int bitMask(int highbit, int lowbit) {
  //we left shift 0xffffffff to get 0's on the right, we need highbit + 1  0's
  //since highbit can be 31, which will be shifting 32 bits == do nothing. 
  //need to deal with special case when highbit is 31
  //we xor the 0xffff0000 with 0xffffffff to get the bits flipped -> 0x0000ffff
  //in the case highbit = 31, we dont want to flip the bits since it will just be 0xffffffff
  //we add ~0 to !(highbit ^ 31) to do the trick, because ~0 + 1 = 0
  int y = (~0 << (highbit + 1)) ^ (~0 + !(highbit ^ 31));
  //printf("y[%x]\n", y);
  int z = y >> lowbit;
  z = z << lowbit;
  //printf("z[%x]\n", z);
  return z;
}

/*
isLessOrEqual - if x <= y  then return 1, else return 0 
  Example: isLessOrEqual(4,5) = 1.
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 24
  Rating: 3
*/
int isLessOrEqual(int x, int y) {
  //idea is : 
  //if x y diff sign, and x < 0, return 1
  //if same sign and y - x has 1 as sign bit, then return 0, 0 as sign bit, return 1
  int diff_sgn = !(x>>31)^!(y>>31);      //is 1 when signs are different
  int a = diff_sgn & (x>>31);            //diff signs and x is neg, gives 1
  int b = !diff_sgn & !((y+(~x+1))>>31); //same signs and difference is pos or = 0, gives 1
  int f = a | b;
  return f;
}

/*
bitCountShort - returns count of number of 1's in a 16-bit value
  The input is a short (16 bits) sign-extended to be an int-type argument.
  Examples: bitCountShort(5) = 2, bitCountShort(7) = 3, bitCountShort(-1) = 16
  Legal ops: ! ~ & ^ | + << >>
  Max ops: 25
  Rating: 4
*/
int bitCountShort(int x) {
  int count = x & 1;
  count+=(x>>1) &1;
  count+=(x>>2) &1;
  count+=(x>>3) &1;
  count+=(x>>4) &1;
  count+=(x>>5) &1;
  count+=(x>>6) &1;
  count+=(x>>7) &1;
  count+=(x>>8) &1;
  count+=(x>>9) &1;
  count+=(x>>10) &1;
  count+=(x>>11) &1;
  count+=(x>>12) &1;
  count+=(x>>13) &1;
  count+=(x>>14) &1;
  count+=(x>>15) &1;
 
  return count;
}

int main()
{
    printf("thirdBits() = %x\n", thirdBits());      // = 0
    printf("bang(3) = %d\n", bang(3));  //bang(3) = 0
    printf("bang(0) = %d\n", bang(0));  //bang(0) = 1
    printf("!(3) = %d\n", !3);  //bang(0) = 1
    return 0;
}