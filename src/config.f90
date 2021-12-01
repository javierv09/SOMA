module config
    use constants

    ! choose geometry directory
    character(len=*), parameter :: geometry = "cylinder"

    ! input directory
    character(len=*), parameter :: input_dir  = "geom/"//geometry//"/input/"
    ! output directory
    character(len=*), parameter :: output_dir = "geom/"//geometry//"/output/"

    ! Fluid constants
    real(dp), parameter :: gamma = 1.4
    real(dp), parameter :: Pr = 0.71
    real(dp), parameter :: suth = 0.4

end module config