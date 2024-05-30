module mod_derivatives
    use variables
    implicit none
    contains

    subroutine calc_derivatives()
        real(dp), dimension(n_dom,n_cloud) :: temp_var, tempu, tempudq
        real(dp), dimension(n_dom) :: tempdudx
        integer :: i,j, test
        print *, "Calculating derivatives"

        call domain_derivatives()

        ! pseudo code for how this function should work. calc_derivatives acts a central hub for all differentiation tasks
        ! - All the derivative calculations (and manipulations) are managed here
        ! -- The first major subroutine call calculates DQ derivatives for domain and body boundary points
        ! -- The second major subroutine call sets the values of derivatives at body ghost points
        ! -- The third major subroutine call sets or extrapolates derivatives at farfield points
        !
        ! - The domain/body derivative subroutine passes the variable to differentiate using DQ
        !   One variable per line.
        !
        ! - The body ghost subroutine sets derivative values manually (needs a closer look re: theory)
        !
        ! - The farfield derivative subroutine does not use DQ, but rather directly enforces or extrapolates derivative values.
        !
        ! - A small core differential quadrature (DQ) subroutine that takes a variable and outputs the derivatives of it.

        do i=1,n_cloud
            tempu(:,i) = var(test,Jd(:,i))
        end do

        tempudq = tempu*DQ_x
        tempdudx = sum(tempudq,2)

        ! Domain derivatives.
        ! May need to be separated out into a new subroutine.

        ! How to calculate derivatives:
        ! NOTE: This can only calculate first order x- and y- derivatives
        ! 1. Loop over each variable
        do i=1,n_var
            ! 3. Create matrix of flow variables with clouds
            do j=1,n_cloud
                temp_var(:,j) = var(i,Jd(:,j))
            end do

            ! 4. Multiply by DQ coefficients and multiply
            var_d(i,dx,:) = sum( temp_var*DQ_x, 2 )
            var_d(i,dy,:) = sum( temp_var*DQ_y, 2 )
        end do

        ! The following commented out code existed solely to check that
        ! the code was running properly.

        !print *, "Size of Jd matrix:"
        !print *, size(Jd,1), "x", size(Jd,2)
!
        !print *, "Size of DQ_x matrix:"
        !print *, size(DQ_x,1), "x", size(DQ_x,2)
!
!
        !print *, "n_total:", n_total
        !print *, "n_dom:", n_dom
        !print *, "n_cloud:", n_cloud
!
        !print *, "Jd:"
        !print *, Jd(1,:)
        !print *, Jd(2,:)
        !print *, Jd(3,:)
        !print *, Jd(4,:)
        !print *, Jd(5,:)
        !print *, Jd(6,:)
!
        !print *, "tempu:"
        !print *, tempu(1,:)
        !print *, tempu(2,:)
        !print *, tempu(3,:)
        !print *, tempu(4,:)
        !print *, tempu(5,:)
        !print *, tempu(6,:)
!
        !print *, "DQ_x:"
        !print *, DQ_x(1,:)
        !print *, DQ_x(2,:)
        !print *, DQ_x(3,:)
        !print *, DQ_x(4,:)
        !print *, DQ_x(5,:)
        !print *, DQ_x(6,:)
!
        !print *, "tempudq:"
        !print *, tempudq(1,:)
        !print *, tempudq(2,:)
        !print *, tempudq(3,:)
        !print *, tempudq(4,:)
        !print *, tempudq(5,:)
        !print *, tempudq(6,:)
!
        !print *, "tempdudx:"
        !print *, tempdudx(1)
        !print *, tempdudx(2)
        !print *, tempdudx(3)
        !print *, tempdudx(4)
        !print *, tempdudx(5)
        !print *, tempdudx(6)
        !! Compare these two ^ v
        !print *, "var_d(rho,dx):"
        !print *, var_d(test,dx,1)
        !print *, var_d(test,dx,2)
        !print *, var_d(test,dx,3)
        !print *, var_d(test,dx,4)
        !print *, var_d(test,dx,5)
        !print *, var_d(test,dx,6)
    end subroutine calc_derivatives

    subroutine domain_derivatives()
        ! This subroutine calculates the derivatives at nodes included in the Jd index array.
        ! It should be noted that this includes derivative calculation at body boundary points.
        integer :: test
        test = deriv(1,1)

    end subroutine domain_derivatives

    function deriv(variable,wrt)
        integer, intent(in) :: variable !
        integer, intent(in) :: wrt !

        integer :: deriv  !

        print *, "HERE" !
        print *, rho !
        print *, "THERE" !
        deriv = variable + wrt !

    end function deriv
    
end module mod_derivatives