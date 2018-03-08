#include <stdlib.h>
#include <immintrin.h>  // for future use of SSE

#include "sum.h"
/* sum.h defines unsigned short to be an alias for unsigned short.
 * It also defines function_type.
 */

/* reference implementation in C */
unsigned short sum_C(long size, unsigned short * a) {
    unsigned short sum = 0;
    for (int i = 0; i < size; ++i) {
        sum += a[i];
    }
    return sum;
}


unsigned short sum_accums_C(long size, unsigned short * a) {
    unsigned short sum1 = 0;
    unsigned short sum2 = 0;
    int i = 0;
    for (i = 0; i+7 < size; i+=8) {
        sum1 += a[i];
        sum2 += a[i+1];
        sum1 += a[i+2];
        sum2 += a[i+3];
        sum1 += a[i+4];
        sum2 += a[i+5];
        sum1 += a[i+6];
        sum2 += a[i+7];
    }
    if (i+6<size)
    {
        sum1 += a[i];
        sum2 += a[i+1];
        sum1 += a[i+2];
        sum2 += a[i+3];
        sum1 += a[i+4];
        sum2 += a[i+5];
        sum1 += a[i+6];
    }
    else if (i+5<size)
    {
        sum1 += a[i];
        sum2 += a[i+1];
        sum1 += a[i+2];
        sum2 += a[i+3];
        sum1 += a[i+4];
        sum2 += a[i+5];
    }
    else if (i+4<size)
    {
        sum1 += a[i];
        sum2 += a[i+1];
        sum1 += a[i+2];
        sum2 += a[i+3];
        sum1 += a[i+4];
    }
    else if (i+3<size)
    {
        sum1 += a[i];
        sum2 += a[i+1];
        sum1 += a[i+2];
        sum2 += a[i+3];
    }
    else if (i+2<size)
    {
        sum1 += a[i];
        sum2 += a[i+1];
        sum1 += a[i+2];
    }
    else if (i+1<size)
    {
        sum1 += a[i];
        sum2 += a[i+1];
    }
    else if (i<size)
    {
        sum1 += a[i];
    }
    else {}
    return sum1+sum2;
    }
/* implementations in assembly */
extern unsigned short sum_naive(long, unsigned short *);
extern unsigned short sum_gcc5_O3(long, unsigned short *);
extern unsigned short sum_gcc5_O2(long, unsigned short *);
extern unsigned short sum_clang5_O(long, unsigned short *);
extern unsigned short sum_gcc7_O3(long, unsigned short *);

extern unsigned short sum_unrolled2(long, unsigned short *);
extern unsigned short sum_unrolled4(long, unsigned short *);
extern unsigned short sum_unrolled8(long, unsigned short *);
extern unsigned short sum_multiple_accum(long, unsigned short *);
//extern unsigned short sum_multiple_accum1(long, unsigned short *);
// add prototypes here!

/* This is the list of functions to test */
function_info functions[] = {
    {sum_C, "sum_C: naive C compiled on this machine with settings in Makefile"},
    {sum_naive, "sum_naive: naive ASM"},
    {sum_gcc5_O2, "sum_gcc5_O2: naive C compiled with GCC5 -O2"},
    {sum_gcc5_O3, "sum_gcc5_O3: naive C compiled with GCC5 -O3"},
    {sum_clang5_O, "sum_clang5_O: naive C compiled with clang 5.0 -O -msse4.2"},
    {sum_gcc7_O3, "sum_gcc7_O3: naive C compiled with GCC7 -O3 -msse4.2"}, 
    // add entries here!
    {sum_unrolled2, "sum_unrolled2: loop unroll by 2"},
    {sum_unrolled4, "sum_unrolled4: loop unroll by 4"},
    {sum_unrolled8, "sum_unrolled8: loop unroll by 8"},
    {sum_multiple_accum, "sum_multiple_accum: 2 accumulators"},
    {sum_accums_C, "sum_accums_C: multiple accumulators and loop unroll"},
};
