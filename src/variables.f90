module variables
    use constants

    ! Data that is read in from input data files
    integer  :: n_dom, n_body, n_far, n_cloud, n_ghost, n_extrap, n_total
    real(dp) :: Ma, Re, AOA

    real(dp), dimension(:)  , allocatable :: x, y
    real(dp), dimension(:,:), allocatable :: DQ_x, DQ_y, EC, &
                                             Jd, Jb, Jf, &
                                             b_normal, &
                                             f_normal, &
                                             slip

    ! primitive and dependent variables
    real(dp), dimension(:,:), allocatable :: var
        ! var(1,:) = density (rho)
        ! var(2,:) = u
        ! var(3,:) = v
        ! var(4,:) = E_t
        ! var(5,:) = p
        ! var(5,:) = T
        ! var(6,:) = viscosity (mu)
    ! Indexing parameters
    integer, parameter :: rho = 1
    integer, parameter :: u = 2
    integer, parameter :: v = 3
    integer, parameter :: E_t = 4
    integer, parameter :: p = 5
    integer, parameter :: T = 6
    integer, parameter :: mu = 7

    ! variable derivatives
    real(dp), dimension(:,:,:), allocatable :: var_d
        ! var_d(:,1,:) = x-derivative
        ! var_d(:,2,:) = y-derivative
        ! var_d(:,3,:) = xx-derivative
        ! var_d(:,4,:) = xy-derivative
        ! var_d(:,5,:) = yy-derivative
    ! Indexing parameters
    integer, parameter :: dx = 1
    integer, parameter :: dy = 2
    integer, parameter :: dxx = 3
    integer, parameter :: dxy = 4
    integer, parameter :: dyy = 5

    ! shear stresses
    real(dp), dimension(:,:), allocatable :: tau
        ! tau(1,:) = tau_xx
        ! tau(2,:) = tau_xy = tau_yx
        ! tau(3,:) = tau_yy
    ! Indexing parameters
    integer, parameter :: xx = 1
    integer, parameter :: xy = 2, yx = 2
    integer, parameter :: yy = 3
    
end module variables