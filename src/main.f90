program soma
    use constants
    use read_input_data
    implicit none

    call read_data()

    print *, ubound(b_normal,1)
    print *, ubound(b_normal,2)
    print *, "Hello World!"
end program soma