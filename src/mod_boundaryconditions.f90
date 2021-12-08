module mod_boundaryconditions
    use variables
    contains

    subroutine enforce_bc()
        print *, "Enforcing boundary conditions"
    end subroutine enforce_bc
end module mod_boundaryconditions