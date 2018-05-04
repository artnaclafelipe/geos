AS = exec as86
LD = exec ld86
BCC = exec bcc

INCLUDEDIR = ../include/realmode
LIBDIR =  ../lib

all build: stage_zero stage_one

stage_zero: stage_zero.s
	$(AS) -o stage_zero.o stage_zero.s
	$(LD) -d -o stage_zero stage_zero.o
	rm -fvr stage_zero.o

stage_one: stage_one.s
	$(AS) -o stage_one.o stage_one.s
	$(LD) -d -o stage_one stage_one.o $(LIBDIR)/libbios.a $(LIBDIR)/libidiv_imodu.a
	rm -fvr stage_one.o

clean:
	rm -fvr stage_zero stage_one