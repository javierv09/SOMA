module mod_boundaryconditions
    use constants
    use config
    use variables
    use mod_governingeqs, only: refresh_variables
    implicit none

    contains

    subroutine enforce_bc()
        print *, "Enforcing boundary conditions"

        call body_bc()
        call farfield_bc()

    end subroutine enforce_bc

    subroutine body_bc()
        integer :: i
        integer, dimension(:), allocatable :: body_ind 
        integer, dimension(:,:), allocatable :: oneoff_ind
        integer, dimension(:,:), allocatable :: ghost_ind

        allocate(body_ind(n_body))
        allocate(oneoff_ind(n_body,n_ghost))
        allocate(ghost_ind(n_body,n_ghost))
        
        body_ind   = Jb(:,1) ! Indices of the boundary points on the body
        oneoff_ind = Jb(:,2:n_ghost+1) ! Indices of the one-off points from the respective boundary points
        ghost_ind  = Jb(:,n_ghost+2:2*n_ghost+1) ! Indices of the ghost points, each a reflection of a oneoff-point across boundary.

        if (viscous) then ! No-slip condition for viscous flow
            var(u,body_ind) = 0.0_dp
            var(v,body_ind) = 0.0_dp
        end if

        do i = 1,n_ghost
            ! Reflect values of density and energy to enforce zero normal derivative
            var(rho,ghost_ind(:,i)) = var(rho,oneoff_ind(:,i))
            var(E_t,ghost_ind(:,i)) = var(E_t,oneoff_ind(:,i))

            if (viscous) then
                var(u,ghost_ind(:,i)) = -var(u,oneoff_ind(:,i))
                var(v,ghost_ind(:,i)) = -var(v,oneoff_ind(:,i))
            else
                ! Inviscid slip condition (Explanation will be in documentation) ! TODO: SLIP NOT INCLUDED YET
                var(u,ghost_ind(:,i)) = slip(:,1)*var(u,oneoff_ind(:,i)) &
                                      + slip(:,2)*var(v,oneoff_ind(:,i))
                var(v,ghost_ind(:,i)) = slip(:,3)*var(u,oneoff_ind(:,i)) &
                                      + slip(:,4)*var(v,oneoff_ind(:,i))
            end if
        end do

        ! Once the boundary conditions have been enforced, re-calculate all the dependent variables
        call refresh_variables()

    end subroutine body_bc

    subroutine farfield_bc()
        ! TODO: enforce farfield boundary conditions
        ! The method of enforcing farfield boundary conditions depends on two things:
        ! 1. Whether the flow is sub- or supersonic; and
        ! 2. Whether the flow is into or out of the domain.
        
        ! Create farfield arrays
        integer :: i
        integer, dimension(:), allocatable :: farfield_ind
        integer, dimension(:,:), allocatable :: extrap_ind
        real(dp), dimension(:), allocatable :: rho_far, u_far, v_far, Et_far, Ma_far
        real(dp), dimension(:), allocatable :: flux_angle

        allocate( farfield_ind(n_far) )
        allocate( extrap_ind(n_far,n_extrap) )
        allocate( rho_far(n_far) )
        allocate( u_far(n_far) )
        allocate( v_far(n_far) )
        allocate( Et_far(n_far) )
        allocate( Ma_far(n_far) )
        allocate( flux_angle(n_far) )

        ! farfield indices
        farfield_ind = Jf(:,1)
        extrap_ind   = Jf(:,2:n_extrap+1)

        ! Mach number is already contained in var2
        Ma_far = var2(Ma,farfield_ind)

        ! Flow direction can be calculated by dot product of velocity with farfield normal
        u_far = var(u,farfield_ind)
        v_far = var(v,farfield_ind)

        flux_angle = u_far*f_normal(:,1) + v_far*f_normal(:,2)
        print *, AOA_rad

        ! Apply boundary conditions depending on flow situation
        do i = 1,n_far
            if      ( Ma_far(i) .ge. 1 .and. flux_angle(i) .le. 0 ) then ! Supersonic inlet
                rho_far(i) = rho_init
                u_far(i)   = V_init*cos(AOA_rad)
                v_far(i)   = V_init*sin(AOA_rad)
                Et_far(i)  = Et_init
            else if ( Ma_far(i) .lt. 1 .and. flux_angle(i) .le. 0 ) then ! Subsonic inlet
                rho_far(i) = rho_init
                u_far(i)   = V_init*cos(AOA_rad)
                v_far(i)   = V_init*sin(AOA_rad)
                Et_far(i)  = extrapolate()
            else if ( Ma_far(i) .ge. 1 .and. flux_angle(i) .gt. 0 ) then! Supersonic outlet
                rho_far(i) = extrapolate()
                u_far(i)   = extrapolate()
                v_far(i)   = extrapolate()
                Et_far(i)  = extrapolate()
            else if ( Ma_far(i) .lt. 1 .and. flux_angle(i) .gt. 0 ) then ! Subsonic outlet
                rho_far(i) = extrapolate()
                u_far(i)   = extrapolate()
                v_far(i)   = extrapolate()
                Et_far(i)  = Et_init
            end if
        end do

    end subroutine farfield_bc

    real function extrapolate()
    ! This "extrapolation" function is as it was created in the C++ code: Here's a quick rundown of how it works:
    ! 0. "Extrapolation coefficients" (EC) are created in pre-processing. (Based on Shepard's method interpolation)
    ! 1. The EC's are used with a nearby "cloud" of nodes to basically create an interpolation to the primary node.
    ! 2. The interpolated value is averaged with the old value to create the new value (I guess this adds smoothing)
    ! u_new = 1/2 (u_old + u_extrapolated)
        
        real(dp), intent(out) :: u_new
    end function extrapolate

end module mod_boundaryconditions