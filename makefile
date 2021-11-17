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
$(OBJDIR)/main.o: \
	$(SRCDIR)/main.f90 \
	$(OBJDIR)/constants.o \
	$(OBJDIR)/read_input_data.o\
	$(OBJDIR)/config.o
$(OBJDIR)/read_input_data.o: \
	$(SRCDIR)/read_input_data.f90 \
	$(OBJDIR)/config.o \
	$(OBJDIR)/variables.o
$(OBJDIR)/variables.o: \
	$(SRCDIR)/variables.f90 \
	$(OBJDIR)/constants.o
$(OBJDIR)/config.o: \
	$(SRCDIR)/config.f90 \
	$(OBJDIR)/constants.o

#=========
# CLEAN-UP
#=========
.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(BINDIR)