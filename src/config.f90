module config
    use constants

    ! Choose the directory containing geometry data
    character(len=*), parameter :: input_dir = "geom/cylinder/input/"

    ! Choose the directory to write output data
    ! TODO: Make sure the output directory exists, or fortran will crash!
    character(len=*), parameter :: output_dir = "geom/cylinder/output/"

end module config