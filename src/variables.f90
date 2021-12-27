module variables
    use constants
    implicit none

    ! Data that is read in from input data files
    integer  :: n_dom, n_body, n_far, n_cloud, n_ghost, n_extrap, n_total
    real(dp) :: Ma_inf, Re, AOA
    real(dp) :: AOA_rad, Et_init

    real(dp), dimension(:)  , allocatable :: x, y
    real(dp), dimension(:,:), allocatable :: DQ_x, DQ_y, EC, &
                                             b_normal, &
                                             f_normal, &
                                             slip
    integer, dimension(:,:), allocatable :: Jd, Jb, Jf
    
    logical :: viscous

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

    integer, parameter :: n_var = 7 ! Number of variables in the var array (used for allocation)

    ! Secondary variables that may be of interest
    real(dp), dimension(:,:), allocatable :: var2
        ! var2(3,:) = total velocity (V_tot)
        ! var2(2,:) = speed of sound (a)
        ! var2(3,:) = local Mach number (Ma)
    integer, parameter :: V_tot = 1
    integer, parameter :: a = 2
    integer, parameter :: Ma = 3

    integer, parameter :: n_var2 = 3 ! Number of secondary variables

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