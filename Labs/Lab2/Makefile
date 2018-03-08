CFLAGS = -std=c99 -Wall -g -O

# flags to pass to the compiler to use AddressSanitizer
# -fno-omit-frame-pointer is probably not needed, but might increase
# the quality of stack traces.
CFLAGS_SANITIZE = $(CFLAGS) -fsanitize=address -fno-omit-frame-pointer

SOURCES = Makefile ll.c ll.h ll-test.c

# AddressSanitizer needs a `symbolizer' program to produce good
# stack traces. On our lab machines this program is
# /usr/bin/asan-symbolizer-3.9 and it is not automatically detected
# by AddressSanitizer. We tell AddressSanitizer about it by setting
# the ASAN_SYMBOLIZER_PATH environment variable.
WHICH_SYMBOLIZER=`which llvm-symbolizer`

ifeq ($(WHICH_SYMBOLIZER),)
WHICH_SYMBOLIZER=`which asan-symbolizer`
endif

ifeq ($(WHICH_SYMBOLIZER),)
WHICH_SYMBOLIZER=`which asan-symbolizer-3.9`
endif

export ASAN_SYMBOLIZER_PATH=$(WHICH_SYMBOLIZER)


all: ll-test ll-test-sanitize

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%-sanitize.o: %.c
	$(CC) $(CFLAGS_SANITIZE) -c -o $@ $<

ll-test: ll.o ll-test.o

ll-test-sanitize: ll-sanitize.o ll-test-sanitize.o
	$(CC) $(CFLAGS_SANITIZE) -o $@ ll-sanitize.o ll-test-sanitize.o

test: ll-test-sanitize
	./ll-test-sanitize

clean:
	rm -f ll-test ll-test-sanitize *.o

archive:
	tar --transform 's,^,asanlab/,' -cvf asanlab.tar  $(SOURCES)

.PHONY: clean all test archive

