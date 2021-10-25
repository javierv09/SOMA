! module containing all the subroutines necessary to read in data files.
module read_input_data
    use constants

    character(len=*), parameter :: geom_dir = "geom/cylinder/input/"

    ! Declare parameter variables
    integer :: n_dom, n_body, n_far, n_cloud, n_ghost, n_extrap, n_total
    real(dp) :: Ma, Re, AOA

    ! Declare geometry variables
    real(dp), dimension(:), allocatable :: x, y
    real(dp), dimension(:,:), allocatable :: DX, DY, EC, &
                                             Jd, Jb, Jf, &
                                             b_normal, &
                                             f_normal

    private read_param_data, read_geom_data

contains
    subroutine read_data()
        call read_param_data()
        call read_geom_data()
    end subroutine read_data

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
        allocate( x(n_total) )
        allocate( y(n_total) )
        allocate( DX(n_dom,n_cloud) )
        allocate( DY(n_dom,n_cloud) )
        allocate( EC(n_far,n_extrap) )
        allocate( Jd(n_dom,n_cloud) )
        allocate( Jb(n_body,n_cloud) )
        allocate( Jf(n_far,n_extrap+1) )
        allocate( b_normal(n_body,2) )
        allocate( f_normal(n_far,2) )

        open(newunit=u, file=geom_dir//"x.txt", action="read", status="old")
        read(u, *) x
        close(u)
        open(newunit=u, file=geom_dir//"y.txt", action="read", status="old")
        read(u, *) y
        close(u)

        open(newunit=u, file=geom_dir//"DX.txt", action="read", status="old")
        read(u, *) ((DX(i,j), j=1,n_cloud), i=1,n_dom)
        close(u)
        open(newunit=u, file=geom_dir//"DY.txt", action="read", status="old")
        read(u, *) ((DY(i,j), j=1,n_cloud), i=1,n_dom)
        close(u)
        open(newunit=u, file=geom_dir//"EC.txt", action="read", status="old")
        read(u, *) ((DY(i,j), j=1,n_extrap), i=1,n_far)
        close(u)

        open(newunit=u, file=geom_dir//"Jd.txt", action="read", status="old")
        read(u, *) ((Jd(i,j), j=1,n_cloud), i=1,n_dom)
        close(u)
        open(newunit=u, file=geom_dir//"Jb.txt", action="read", status="old")
        read(u, *) ((Jb(i,j), j=1,n_cloud), i=1,n_body)
        close(u)
        open(newunit=u, file=geom_dir//"Jf.txt", action="read", status="old")
        read(u, *) ((Jf(i,j), j=1,n_extrap+1), i=1,n_far)
        close(u)

        open(newunit=u, file=geom_dir//"nxb.txt", action="read", status="old")
        read(u, *) (b_normal(i,1), i=1,n_bod)
        close(u)
        open(newunit=u, file=geom_dir//"nyb.txt", action="read", status="old")
        read(u, *) (b_normal(i,2), i=1,n_bod)
        close(u)

        open(newunit=u, file=geom_dir//"nxf.txt", action="read", status="old")
        read(u, *) (f_normal(i,1), i=1,n_far)
        close(u)
        open(newunit=u, file=geom_dir//"nyf.txt", action="read", status="old")
        read(u, *) (f_normal(i,2), i=1,n_far)
        close(u)

    end subroutine read_geom_data
end module read_input_data