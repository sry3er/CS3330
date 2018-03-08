YAS=./tools/yas
HCLRS=./tools/hclrs
UNAME_S=$(shell uname -s)
UNAME_M=$(shell uname -m)
HCLRS_TAR=./tools/hclrs-current-$(UNAME_S)-$(UNAME_M).tar.gz
HCLRS_DIST_ROOT=https://www.cs.virginia.edu/~cr4bd
DC=dmd
DFLAGS=-O
DOT=dot

all: hclrs
	(cd tools; make all)

$(HCLRS): $(HCLRS_TAR)
	cd tools && tar xf `basename $(HCLRS_TAR)`

hclrs: $(HCLRS)
	rm -f ./hclrs
	ln -s $(HCLRS) ./hclrs

.SUFFIXES: .ys .yo
.ys.yo:
	$(YAS) $*.ys

.SUFFIXES: .dot .png
.dot.png: 
	$(DOT) -Tpng $*.dot > $*.png

update-hclrs:
	cd tools && curl -O $(HCLRS_DIST_ROOT)/`basename $(HCLRS_TAR)`
	cd tools && tar xvf `basename $(HCLRS_TAR)`

compile-hclrs:
	mkdir -p hclrs-src
	@cargo --version || (echo "Install Rust first; see https://rustup.rs/"; false)
	cd hclrs-src && [ -e .git ] || git clone https://github.com/woggle/hclrs -b cs3330-current .
	cd hclrs-src && git pull
	cd hclrs-src && cargo build --release
	cp $(HCLRS) $(HCLRS).backup`date +%Y%m%d%H%M%S` || true
	cp hclrs-src/target/release/hclrs $(HCLRS)

clean:
	(cd tools; make clean)
	rm -f *.exe *.o *.obj *~ core.* *_hcl.d *_hcl.dot *_hcl.png

test-pc:
	python3 testing_tool.py test pc.hcl testdata/pc-tests.txt testdata/pc-reference

test-irrr:
	python3 testing_tool.py test --compare-trace irrr.hcl testdata/irrr-tests.txt testdata/seq-traces

test-seqlab:
	python3 testing_tool.py test --compare-trace seqlab.hcl testdata/seqlab-tests.txt testdata/seq-traces

test-seqhw:
	python3 testing_tool.py test --compare-trace seqhw.hcl testdata/seqhw-tests.txt testdata/seq-traces

test-pipelab1:
	python3 testing_tool.py test pipelab1.hcl testdata/pipelab1-tests.txt testdata/pipelab1-reference

test-pipelab2:
	python3 testing_tool.py test pipelab2.hcl testdata/pipelab2-tests.txt testdata/pipe-reference

test-pipehw1:
	python3 testing_tool.py test pipehw1.hcl testdata/pipehw1-tests.txt testdata/pipe-reference

test-pipehw2:
	python3 testing_tool.py test pipehw2.hcl testdata/pipehw2-tests.txt testdata/pipe-reference

references:
	python3 testing_tool.py create-reference sln8_pipehw2.hcl testdata/pipe-reference
	python3 testing_tool.py create-reference --include-trace sln8_pipehw2.hcl testdata/pipe-traces
	python3 testing_tool.py create-reference sln4_seqhw.hcl testdata/seq-reference
	python3 testing_tool.py create-reference --include-trace sln4_seqhw.hcl testdata/seq-traces
	python3 testing_tool.py create-reference sln5_pipelab1.hcl testdata/pipelab1-reference
	python3 testing_tool.py create-reference sln1_pc.hcl testdata/pc-reference

all-yos:
	for y in y86/*.ys; do \
	    $(MAKE) -q y86/`basename $$y .ys`.yo || $(MAKE) --no-print-directory y86/`basename $$y .ys`.yo; \
	done

archive:
	cd tools && curl -O $(HCLRS_DIST_ROOT)/hclrs-current-Darwin-i386.tar.gz
	cd tools && curl -O $(HCLRS_DIST_ROOT)/hclrs-current-Darwin-x86_64.tar.gz
	cd tools && curl -O $(HCLRS_DIST_ROOT)/hclrs-current-Linux-x86_64.tar.gz
	cd tools && curl -O $(HCLRS_DIST_ROOT)/hclrs-current-Linux-i686.tar.gz
	cd tools && curl -O $(HCLRS_DIST_ROOT)/hclrs-current-windows-x86_64.zip
	cd tools && curl -O $(HCLRS_DIST_ROOT)/hclrs-current-windows-i686.zip
	tar -cvf hclrs.tar --xform 's!^.!hclrs!' \
             --exclude=*.o --exclude=yis --exclude=yas --exclude-vcs --exclude=hclrs \
             --exclude=pc.hcl --exclude='ir*'.hcl --exclude=seqlab.hcl --exclude='pipelab*.hcl' --exclude='pipehw*.hcl' \
             --exclude=seqhw.hcl --exclude='sln*.hcl' --exclude='*_hcl.d' --exclude='*_hcl.dot' --exclude='*.exe' \
             --exclude=tests --exclude hcl.tar --exclude hclrs.tar .

.PHONY: all clean archive references \
    test-pc test-ir test-seqlab test-seqhw test-pipelab1 test-pipelab2 test-pipehw1 test-pipehw2 \
    all-yos
