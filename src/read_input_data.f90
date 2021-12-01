! module containing all the subroutines necessary to read in data files.
module read_input_data
    use config
    use variables

    integer :: unit_num ! placeholder for unit number
    private read_param_data, read_geom_data, unit_num

contains
    subroutine read_data()
        call read_param_data()
        call read_geom_data()

        ! Once the data has been read from input directory, make sure output directory exists to be safe.
        call execute_command_line("mkdir -p "//output_dir)
    end subroutine read_data

    subroutine read_param_data()
    ! Reads parameter data files: array sizes and flow parameter

        open(newunit=unit_num, file=input_dir//"Sizes.txt", action="read", status="old")
        read(unit_num, *) n_dom, n_body, n_far, n_cloud, n_ghost, n_extrap, n_total
        close(unit_num)

        open(newunit=unit_num, file=input_dir//"SimulationValues.txt", action="read", status="old")
        read(unit_num, *) Ma, AOA, Re
        close(unit_num)

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
        allocate( x(n_total) )
        allocate( y(n_total) )
        allocate( DQ_x(n_dom,n_cloud) )
        allocate( DQ_y(n_dom,n_cloud) )
        allocate( EC(n_far,n_extrap) )
        allocate( Jd(n_dom,n_cloud) )
        allocate( Jb(n_body,n_cloud) )
        allocate( Jf(n_far,n_extrap+1) )
        allocate( b_normal(n_body,2) )
        allocate( f_normal(n_far,2) )
        allocate( slip(n_body,4) )

        ! Read domain evaluation node coordinates
        open(newunit=unit_num, file=input_dir//"x.txt", action="read", status="old")
        read(unit_num, *) x
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"y.txt", action="read", status="old")
        read(unit_num, *) y
        close(unit_num)

        ! Read DQ coefficients and Extrapolation coefficients
        open(newunit=unit_num, file=input_dir//"DX.txt", action="read", status="old")
        read(unit_num, *) ((DQ_x(i,j), j=1,n_cloud), i=1,n_dom)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"DY.txt", action="read", status="old")
        read(unit_num, *) ((DQ_y(i,j), j=1,n_cloud), i=1,n_dom)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"EC.txt", action="read", status="old")
        read(unit_num, *) ((EC(i,j), j=1,n_extrap), i=1,n_far)
        close(unit_num)

        ! Read index "directories"
        open(newunit=unit_num, file=input_dir//"Jd.txt", action="read", status="old")
        read(unit_num, *) ((Jd(i,j), j=1,n_cloud), i=1,n_dom)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"Jb.txt", action="read", status="old")
        read(unit_num, *) ((Jb(i,j), j=1,n_cloud), i=1,n_body)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"Jf.txt", action="read", status="old")
        read(unit_num, *) ((Jf(i,j), j=1,n_extrap+1), i=1,n_far)
        close(unit_num)

        ! Read normal vectors on boundary
        open(newunit=unit_num, file=input_dir//"nxb.txt", action="read", status="old")
        read(unit_num, *) (b_normal(i,1), i=1,n_bod)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"nyb.txt", action="read", status="old")
        read(unit_num, *) (b_normal(i,2), i=1,n_bod)
        close(unit_num)

        ! Read normal vectors on farfield
        open(newunit=unit_num, file=input_dir//"nxf.txt", action="read", status="old")
        read(unit_num, *) (f_normal(i,1), i=1,n_far)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"nyf.txt", action="read", status="old")
        read(unit_num, *) (f_normal(i,2), i=1,n_far)
        close(unit_num)

        ! Read slip matrix
        open(newunit=unit_num, file=input_dir//"s11.txt", action="read", status="old")
        read(unit_num, *) (slip(i,1), i=1,n_body)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"s12.txt", action="read", status="old")
        read(unit_num, *) (slip(i,2), i=1,n_body)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"s21.txt", action="read", status="old")
        read(unit_num, *) (slip(i,3), i=1,n_body)
        close(unit_num)
        open(newunit=unit_num, file=input_dir//"s22.txt", action="read", status="old")
        read(unit_num, *) (slip(i,4), i=1,n_body)
        close(unit_num)

    end subroutine read_geom_data
end module read_input_data