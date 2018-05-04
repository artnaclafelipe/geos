AS = exec as86
LD = exec ld86
BCC = exec bcc

TARGET = ../../libbios.a

OBJS = video.o \
	   disk.o 
	   
all build: $(TARGET)

$(TARGET): libbios.o
	ar rcs $@ *.o

video.s.o: video.s
	$(AS) -o video.s.o  video.s

video.c.o: video.c
	$(BCC) -ansi -c video.c

video.o: video.s.o video.c.o
	$(BCC) -c video.s.o video.c.o

disk.s.o: disk.s
	$(AS) -o disk.s.o  disk.s

disk.c.o: disk.c
	$(BCC) -ansi -c disk.c

disk.o: disk.s.o disk.c.o
	$(BCC) -c disk.s.o disk.c.o

libbios.o: video.o disk.o 
	$(BCC) -c video.o disk.o 

clean:
	rm -rvf *.o $(TARGET)
