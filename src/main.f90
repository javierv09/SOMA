program soma
    use readData
    implicit none
    
    character(len=*), parameter :: geom_dir = "./geom/cylinder/input/"
    integer, dimension(7) :: sizes
    real, dimension(3) :: sim_values

    open(unit=10, file=geom_dir//"Sizes.txt", action="read", status="old")
    open(unit=11, file=geom_dir//"SimulationValues.txt", action="read", status="old")
    read(10, *) sizes
    read(11, *) sim_values

    print *, "Hello World!"
    print *, sizes
    print *, sim_values
    print *, addone(sim_values)
end program soma