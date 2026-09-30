from models import *
import numpy as np
import time
# simulation setups


def gen_jacobian_matrix(device):
    # paramters
    cell_array = device.cell_array
    N = len(cell_array)
    # update Jm Jn and their diffs(Jn  Jn_phi_k  Jn_phi_kp1 Jn_n_k Jn_n_kp1)
    for cell0 in cell_array:
        cell0.comput_diffs()
    jacobian_matrix = np.zeros((3 * (N - 1), 3 * (N - 1)))
    Fk = np.zeros((3 * (N - 1),))
    # Xs = np.zeros((3 * (N - 1), 1))
    for k in range(N - 1):
        # get two cells
        cell0 = cell_array[k]
        cell1 = cell_array[k + 1]
        # assert BC
        par_dict = {
            'phi_km1': cell0.phi0,
            'phi_k'  : cell1.phi0,
            'phi_kp1': cell1.phi1,

            'dop_k': cell1.dop0,

            'h_mm1': cell0.hm,
            'h_m': cell1.hm,

            'n_km1': cell0.n0,
            'n_k': cell1.n0,
            'n_kp1': cell1.n1,

            'p_km1': cell0.p0,
            'p_k': cell1.p0,
            'p_kp1': cell1.p1,

            'mu_n': cell0.mu_n,
            'mu_p': cell0.mu_p,
            'tau_n': cell0.tau_n,
            'tau_p': cell0.tau_p
        }
        hmk = (cell0.hm+cell1.hm)/2.0
        #print(par_dict)
        # possion
        # k= 0 ---> N-2
        if k != 0:
            jacobian_matrix[3*k, 3*(k - 1)] = poisson_phi_km1(**par_dict)
        if k != N-2:
            jacobian_matrix[3*k, 3*(k + 1)] = poisson_phi_kp1(**par_dict)
        jacobian_matrix[3 * k, 3*k] = poisson_phi_k(**par_dict)
        jacobian_matrix[3*k, 3*k+1] = poisson_n_k(**par_dict)
        jacobian_matrix[3*k, 3*k+2] = poisson_p_k(**par_dict)
        # electron equations
        ## (Jn(K+1,K) - Jn(K,K-1)) - R(K,K)
        if k != 0:
            jacobian_matrix[3*k + 1, 3*(k - 1)] = (-1*cell0.Jn_phi_k)/hmk  #phi k-1
            jacobian_matrix[3*k + 1, 3*(k - 1)+1] = (-1*cell0.Jn_n_k)/hmk  #n k-1
        jacobian_matrix[3*k + 1, 3*k] = -1*(cell1.Jn_phi_k - cell0.Jn_phi_kp1)/hmk #phi k
        if k != N - 2:
            jacobian_matrix[3*k + 1, 3*(k + 1)]     = cell1.Jn_phi_kp1/hmk # phi K+1
            jacobian_matrix[3*k + 1, 3*(k + 1) + 1] = cell1.Jn_n_kp1/hmk   # n K+1
        jacobian_matrix[3*k + 1, 3*k + 1]   = (cell1.Jn_n_k - cell0.Jn_n_kp1)/hmk - cell1.R_n_k #n K
        jacobian_matrix[3*k + 1, 3*k + 2]   =  cell1.R_p_k
        # hole equations
        if k != 0:
            jacobian_matrix[3*k + 2, 3*(k - 1)] = (-1*cell0.Jp_phi_k)/hmk
            jacobian_matrix[3*k + 2, 3*(k - 1) + 2] = (-1*cell0.Jp_p_k)/hmk
        jacobian_matrix[3*k + 2,3*k] = -1*(cell1.Jp_phi_k - cell0.Jp_phi_kp1)/hmk #phi k
        if k != N - 2:
            jacobian_matrix[3*k + 2, 3*(k+1)] = cell1.Jp_phi_kp1/hmk
            jacobian_matrix[3*k + 2, 3*(k+1)+2] = cell1.Jp_p_kp1/hmk
        jacobian_matrix[3*k + 2, 3*k + 2] = (cell1.Jp_p_k - cell0.Jp_p_kp1)/hmk + cell1.R_p_k #n K
        jacobian_matrix[3*k + 2, 3*k + 1] = cell1.R_n_k

        # F values
        Fk[3*k] = -1 * F_poisson_equation(**par_dict)
        Fk[3*k+1] = -1 * F_poisson_equation(**par_dict)
        Fk[3*k+2] = -1 * F_poisson_equation(**par_dict)
    # 替换异常值
    jacobian_matrix[np.isnan(jacobian_matrix)] = 1
    Fk[np.isnan(Fk)] = 1

    return (jacobian_matrix, Fk)


# def gen_jacobian_matrix(device):
#     #paramters
#     cell_array = device.cell_array
#     N = len(cell_array)
#     jacobian_matrix = np.zeros((3*(N-1),3*(N-1)))
#     Fk  = np.zeros((3*(N-1),1))
#     # Xs = np.zeros((3 * (N - 1), 1))
#     for k in range(N-1):
#         #get two cells
#         cell0 = cell_array[k]
#         cell1 = cell_array[k+1]
#         #assert BC
#         n0 = 0
#         p0 = 0
#         phi0 = 0
#         n1 = 0
#         p1 = 0
#         phi1= 0
#         if k == 0:
#             va = cell0.va
#             (n0,p0,phi0) = BC_Neumann(cell0.dop_k,va)
#             print("0点处的边界条件")
#             print(n0,p0,phi0)
#         if k == N-2:
#             va = cell1.va
#             (n1, p1, phi1) = BC_Neumann(cell1.dop_kp1,va)
#             print("L点处的边界条件")
#             print(n1,p1,phi1)
#         par_dict = {
#                 'phi_km1': cell0.phi_k,
#                 'phi_k'  : cell1.phi_k,
#                 'phi_kp1': cell1.phi_kp1,
#
#                 'dop_k'  : cell1.dop_k,
#
#                 'h_mm1'   : cell0.hm,
#                 'h_m'     : cell1.hm,
#
#                 'n_km1'  : cell0.n_k,
#                 'n_k'    : cell1.n_k,
#                 'n_kp1'  : cell1.n_kp1,
#
#                 'p_km1'  : cell0.p_k,
#                 'p_k'    : cell1.p_k,
#                 'p_kp1'  : cell1.p_kp1,
#
#                 'mu_n'   : cell0.mu_n,
#                 'mu_p'   : cell0.mu_p,
#                 'tau_n'  : cell0.tau_n,
#                 'tau_p'  : cell0.tau_p
#         }
#         print(par_dict)
#         print(par_dict)
#         #possion
#         if k != 0:
#             jacobian_matrix[k, k - 1] = poisson_phi_km1(**par_dict)
#         else:
#             par_dict['phi_km1'] = phi0
#             par_dict['p_k']     = p0
#             par_dict['n_k']     = n0
#         jacobian_matrix[k, k] = poisson_phi_k(**par_dict)
#         if k != N-1:
#             jacobian_matrix[k, k + 1] = poisson_phi_kp1(**par_dict)
#         else:
#             par_dict['phi_kp1'] = phi1
#             par_dict['p_kp1']     = p1
#             par_dict['n_kp1']     = n1
#         jacobian_matrix[ k , k + (N - 1) ] = poisson_n_k(**par_dict)
#         jacobian_matrix[ k , k + 2 * (N - 1) ] = poisson_p_k(**par_dict)
#         #electron equations
#         if k != 0:
#             jacobian_matrix[k + (N - 1), k - 1] = electron_phi_km1(**par_dict)
#             jacobian_matrix[k + (N - 1), k + N - 1 - 1] = electron_n_km1(**par_dict)
#         jacobian_matrix[k + (N - 1), k] = electron_phi_k(**par_dict)
#         if k != N - 1:
#             jacobian_matrix[k + (N - 1), k + 1] = electron_phi_kp1(**par_dict)
#             jacobian_matrix[k + (N - 1), k + (N -1) + 1] = electron_n_kp1(**par_dict)
#         jacobian_matrix[k + (N - 1), k + N - 1 ] = electron_n_k(**par_dict)
#         jacobian_matrix[k + (N - 1), k + 2*(N - 1)] = electron_p_k(**par_dict)
#         #hole equations
#         if k != 0:
#             jacobian_matrix[k + 2*(N - 1), k - 1] = hole_phi_km1(**par_dict)
#             jacobian_matrix[k + 2*(N - 1), k + (N - 1) - 1] = hole_p_km1(**par_dict)
#         jacobian_matrix[k + 2*(N - 1), k] = hole_phi_k(**par_dict)
#         if k != N - 1:
#             jacobian_matrix[k + 2*(N - 1), k + 1] = hole_phi_kp1(**par_dict)
#             jacobian_matrix[k + 2*(N - 1), k + (N - 1) + 1] = hole_p_kp1(**par_dict)
#
#         jacobian_matrix[k + 2*(N - 1), k + (N - 1)] = hole_p_k(**par_dict)
#         jacobian_matrix[k + 2*(N - 1), k + 2 * (N - 1)] = hole_n_k(**par_dict)
#
#         #F values
#         Fk[k] = -1*F_poisson_equation(**par_dict)
#         Fk[k+N-1] = -1*F_poisson_equation(**par_dict)
#         Fk[k+2*(N-1)] = -1*F_poisson_equation(**par_dict)
#     #替换异常值
#     jacobian_matrix[np.isnan(jacobian_matrix)] = 1
#     Fk[np.isnan(Fk)] = 1
#
#     return (jacobian_matrix,Fk)