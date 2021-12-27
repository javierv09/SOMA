module mod_governingeqs
    use config
    use variables
    implicit none
    
    contains
    subroutine refresh_variables()
        ! Many times throughout the code the primary variable are altered, either by boundary condition enforcement or updating
        ! the approximation. This subroutine recalculates all the non-primary or secondary variables to reflect the change.

        ! Total velocity
        var2(V_tot,:) = sqrt( var(u,:)**2 + var(v,:)**2 )

        ! Presure calculation
        var(P,:) = ( var(E_t,:) - 0.5*var(rho,:)*var2(V_tot,:)**2)*(gamma-1)

        ! Temperature calculation
        var(T,:) = gamma*Ma_inf**2*(gamma-1)*( var(E_t,:)/var(rho,:) - 0.5*var2(V_tot,:) )

        ! Viscosity calculation
        var(mu,:) = var(T,:)**1.5 *  (1 + suth)/(var(T,:) + suth)

        ! Speed of sound calculation
        var2(a,:) = sqrt( gamma*var(P,:)/var(rho,:) )

        ! Mach number calculation
        var2(Ma,:) = var2(V_tot,:)/var2(a,:)

        !print *, "Density       : ", var(rho,1), " ", var(rho,1769)
        !print *, "X-velocity    : ", var(u,1), " ", var(u,1769)
        !print *, "Y-velocity    : ", var(v,1), " ", var(v,1769)
        !print *, "Velocity      : ", var2(V_tot,1), " ", var2(V_tot,1769)
        !print *, "Energy        : ", var(E_t,1), " ", var(E_t,1769)
        !print *, "Pressure      : ", var(P,1), " ", var(P,1769)
        !print *, "Temperature   : ", var(T,1), " ", var(T,1769)
        !print *, "Viscosity     : ", var(mu,1), " ", var(mu,1769)
        !print *, "Speed of Sound: ", var2(a,1), " ", var2(a,1769)
        !print *, "Mach number   : ", var2(Ma,1), " ", var2(Ma,1769)
    end subroutine refresh_variables
end module mod_governingeqs