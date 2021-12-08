module config
    use constants

    ! choose geometry directory
    character(len=*), parameter :: geometry = "cylinder"
    ! name output folder. This directory will exist inside the directory [geometry]
    character(len=*), parameter :: output_name = "output"    
    
    ! Fluid constants
    real(dp), parameter :: gamma = 1.4 ! Specific heat ratio
    real(dp), parameter :: Pr = 0.71   ! Prandtl number
    real(dp), parameter :: suth = 0.4  ! Constant used for Sutherland's Law for viscosity

    ! Initialization Options
    ! reload determined whether the simulation is initialized from a previous run, or from scratch
    logical, parameter :: reload = .false. ! Resuming from previous output is not yet supported

    ! Initial conditions
    ! Note: these parameters are ignored if reload == true
    real(dp), parameter :: rho_init = 1.0
    real(dp), parameter :: V_init = 1.0 ! Total velocity is initialized, because the angle of attack is dictated by
                                        ! SimulationValues.txt, so component velocities can be derived.
    real(dp), parameter :: T_init = 1.0
    ! Initial pressure and total energy values are derived from the preceding

end module config