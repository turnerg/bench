CC = cc
FF = ftn

CFLAGS = -O2 
FFLAGS = -O2

#PGI
CFLAGS += -mp
FFLAGS += -mp

#GNU
#CFLAGS += -fopenmp
#FFLAGS += -fopenmp 

#INTEL
#CFLAGS += -openmp
#FFLAGS += -openmp


all: stream_f.exe stream_c.exe

stream_f.exe: stream.f mysecond.o
	$(CC) $(CFLAGS) -c mysecond.c
	$(FF) $(FFLAGS) -c stream.f
	$(FF) $(FFLAGS) stream.o mysecond.o -o stream_f.exe 

stream_c.exe: stream.c
	$(CC) $(CFLAGS) stream.c -o stream_c.exe

clean:
	rm -f stream_f.exe stream_c.exe *.o

