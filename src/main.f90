program soma
    use constants
    use variables
    use config
    use mod_initialize, only: initialize
    implicit none

    call initialize()
    !print *, viscous

end program soma