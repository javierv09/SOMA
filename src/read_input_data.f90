! module containing all the subroutines necessary to read in data files.
module read_input_data
    use constants

    character(len=*), parameter :: geom_dir = "geom/cylinder/input/"

    ! Declare parameter variables
    integer :: n_dom, n_body, n_far, n_cloud, n_ghost, n_extrap, n_total
    real(dp) :: Ma, Re, AOA

    ! Declare geometry variables
    real(dp), dimension(:), allocatable :: x, y

contains
    subroutine read_param_data()
    ! Reads parameter data files: array sizes and flow parameter
        integer :: u ! placeholder for unit number

        open(newunit=u, file=geom_dir//"Sizes.txt", action="read", status="old")
        read(u, *) n_dom, n_body, n_far, n_cloud, n_ghost, n_extrap, n_total
        close(u)

        open(newunit=u, file=geom_dir//"SimulationValues.txt", action="read", status="old")
        read(u, *) Ma, AOA, Re
        close(u)

    end subroutine read_param_data

    subroutine read_geom_data()
    ! Reads geometry based data, using parameter data to allocate array sizes
    ! List of .txt files:
    !   x, y                ! Evaluation node coordinates
    !   DX, DY, EC          ! DQ coefficients + extrapolation coefficients
    !   Jd, Jb, Jf          ! indices of nodes + corresponding cloud/extrapolation nodes in domain, body, farfield
    !   nxb, nyb            ! normal unit vectors at body nodes
    !   nxf, nyf            ! normal unit vectors at farfield nodes
    !   s11, s12, s21, s22  ! Matrices that enforce flow tangency conditions (by reversing value at ghost point)
                            ! TODO: Add documentation for s## matrices
        integer :: u ! placeholder for unit number

        open(newunit=u, file=geom_dir//"x.txt", action="read", status="old")
        close(u)

    end subroutine read_geom_data
end module read_input_data