module mod_initialize
    use config
    use variables
    use mod_readdata, only: read_data
    use mod_boundaryconditions, only: enforce_bc
    use mod_differentiate, only: differentiate
    implicit none

    contains

    subroutine initialize()
        call read_data()
        call allocate_variables()

        if( reload ) then
            print *, "Error: Resuming from previous output is not yet supported." ! TODO
            stop
        else
            call initial_conditions()
        end if
        
        call enforce_bc()
        call differentiate()

    end subroutine initialize

    subroutine allocate_variables()
        allocate( var(n_var,n_total) )
        allocate( var_d(n_var, 5, n_total) )
        allocate( tau(3,n_total) )
        allocate( var2(n_var2,n_total) )

        var = 0
        var_d = 0
        tau = 0
        var2 = 0
    end subroutine allocate_variables

    subroutine initial_conditions()
        ! The angle of attack is given in degrees, but the trigonometric functions expect radians, so AOA must be converted
        !real(dp) :: Et_init
        
        AOA_rad = pi*AOA/180.0

        ! Initial density
        var(rho,:) = rho_init 
        ! Initial velocity components
        var(u,:) = V_init * cos(AOA_rad)
        var(v,:) = V_init * sin(AOA_rad)
        ! Initial temperature
        var(T,:) = T_init
         
        ! Initial energy is calculated
        ! E_t = pT/(yM^2(y-1)) + 1/2 pV^2 (p = rho, y = gamma)
        Et_init = rho_init * ( T_init/(gamma* Ma_inf**2 * (gamma-1)) + 0.5*V_init**2 )
        var(E_t,:) = Et_init

        ! Initial pressure is calculated using the equation of state for clorically perfect gas
        ! P = (E_t - 1/2 pV^2)(y-1) (P = pressure, p = rho)
        var(P,:) = (Et_init - 0.5*rho_init*V_init**2)*(gamma-1)

        ! Initial viscosity is calculated using Sutherland's law
        ! u = T^(3/2) * (1 + S)/(T + S) (u = mu, S = Sutherland constant for air)
        var(mu,:) = T_init**1.5 *  (1 + suth)/(T_init + suth)

        ! Initial total velocity as given
        var2(V_tot,:) = V_init

        ! Initial Mach number as given
        var2(Ma,:) = Ma_inf

        ! Initial speed of sound
        var2(a,:) = V_init/Ma_inf

        ! Assign logical variable viscous depending on Reynolds number
        viscous = Re .gt. 0
    end subroutine initial_conditions
end module mod_initialize