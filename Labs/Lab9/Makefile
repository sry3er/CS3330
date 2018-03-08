# This Makefile requires GNU make

CC = gcc
CFLAGS = -g -O2 -std=c99 -msse4.2 -Wall
ASFLAGS = -g

ASSEMBLY_O_FILES = $(patsubst %.s,%.o,$(wildcard sum_*.s))

DIST_FILES = \
    sum.h sum_benchmarks.c sum_main.c timing.c timing.h Makefile \
    sum_naive.s \
    sum_clang5_O.s sum_gcc5_O2.s sum_gcc5_O3.s \
    sum_gcc7_O3.s

all: sum sum_benchmarks.s

sum_benchmarks.s: sum_benchmarks.c
	$(CC) $(CFLAGS) -g0 -S -o $@ $^

sum: timing.o sum_main.o sum_benchmarks.o $(ASSEMBLY_O_FILES)
	$(CC) $(CFLAGS) -o $@ $^

looplab-submit.tar:
	rm -f looplab-submit.tar
	tar cvf looplab-submit.tar *.s *.c

clean:
	rm -f *.o sum_benchmarks.s

.PHONY: clean

# make targets for internal use only
looplab.tar: $(DIST_FILES)
	rm -f looplab.tar
	tar cvf looplab.tar $(DIST_FILES)
