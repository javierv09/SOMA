# Variables
FC = gfortran
FFLAGS = -c -g -Og -Wall

# Linking
soma: soma.o
	$(FC) soma.o -o soma.exe

# Compiling
soma.o: soma.f90
	$(FC) $(FFLAGS) soma.f90

# Cleanup
clean:
	rm *.o soma.exe

# Run
run:
	make
	./soma.exe
