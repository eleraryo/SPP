CC=gcc
CXX=g++
CFLAGS=-O2 -fopenmp -std=c99
CXXFLAGS=-O2 -fopenmp
EXECS= hello-openmp dotproduct matMul heated-plate-parallel

all: $(EXECS)

hello-openmp: hello-openmp.c
	$(CC) -o $@ $<  $(CFLAGS)

dotproduct: dotproduct.c  
	$(CC) -o $@ $< $(CFLAGS) -lm

matMul: matMul.c  
	$(CC) -o $@ $< $(CFLAGS) -lm

heated-plate-parallel: heated-plate-parallel.cpp  
	$(CXX) -o $@ $< $(CXXFLAGS)

clean:
	rm -f $(EXECS) *.o
