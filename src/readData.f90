! module containing all the subroutines necessary to read in data files.
module readData

contains
    function addone(x)result(y)
        real, intent(in), dimension(:) :: x
        real, dimension(size(x)) :: y
        y = x + 1
    end function addone

end module readData