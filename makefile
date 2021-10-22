#=================
# COMPILER OPTIONS
#=================
FC = gfortran
FFLAGS = -g -Og -Wall -std=f2018

BINDIR=bin
SRCDIR=src
OBJDIR=obj

EXE = soma
SRC := $(wildcard $(SRCDIR)/*.f90)
OBJ := $(SRC:$(SRCDIR)/%.f90=$(OBJDIR)/%.o)

#========
# LINKING
#========
$(BINDIR)/$(EXE): $(OBJ) | $(BINDIR)
	$(FC) $^ -o $@

#=================
# COMPILATION RULE
#=================
$(OBJDIR)/%.o: $(SRCDIR)/%.f90 | $(OBJDIR)
	$(FC) $(FFLAGS) -c $< -o $@ -J $(OBJDIR)

#===================
# BINARY DIRECTORIES
#===================
$(OBJDIR) $(BINDIR):
	mkdir -p $@

#=============
# DEPENDENCIES
#=============
$(OBJDIR)/main.o: $(OBJDIR)/constants.o $(OBJDIR)/read_input_data.o
$(OBJDIR)/read_input_data.o: $(OBJDIR)/constants.o

#=========
# CLEAN-UP
#=========
.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(BINDIR)