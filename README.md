# SOMA (Sequentially Optimized Meshfree Algorithm)
Project to port C++ SOMA code to Fortran. Not operational.

# Compilation and Running
> [!NOTE]
> This project is being developed using GNU Make 4.2.1 for the makefile and GNU Fortran 9.4.0 for compilation.

> [!WARNING]
> The code relies on executing a `sh` command (`mkdir`) to create the output folder, so the code will fail unpredictably on non-UNIX systems (i.e. Windows). It is unsure whether it will run properly on macOS.

In order for the code to work, the directory tree should be as follows:

> ```
>SOMA/
>|-doc/
>|-geom/
>| |-[geometry folder]/
>|   |-create
>|   |-input
>|-src/
>|-makefile
>```

The `[geometry folder]` that the code will look to for geometry data is defined in `src/config.f90` as the variable `geometry`. The current default geometry folder is `cylinder`. Geometry data itself is not stored in this repository, so the relevant folder must be moved into `geom/` manually.

Before compiling the code, make sure that the current directory is the top-level folder, `SOMA`. This can be done by executing the command `cd ~/[PATH]/SOMA` in the terminal. Then execute the `make` command to compile.

Running `make` compiles the source code in `src/` and creates two new folders, `obj` and `bin`. The `obj` folder holds the Fortran object and module files, and the `bin` folder hold the executable. The directory tree should now look as in the following example:

> ```
>SOMA/
>|-bin/
>| |-[executable]
>|-doc/
>|-geom/
>| |-[geometry folder]/
>|   |-create
>|   |-input
>|-obj/
>|-src/
>|-makefile
>```

The name of the executable file is defined in `makefile` as the variable `EXE`. By default, the executable is named `soma`.

To run the program, execute the command `bin/soma`.

> [!TIP]
> The project can be reset to its "clean" state (deleting the object and executable folders) by executing `make clean` from the terminal. This may be necessary sometimes if the code is edited and dependencies change. This allows for a fresh recompilation.