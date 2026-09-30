import numpy as np
from gen_jacobian_matrix import  *
from gen_solve_matrix import *

def NewtonSolver(device,Va,error_control):
    #迭代初始值
    num_of_cell = len(device.cell_array)
    device.set_electrode_voltage(Va)
    #device.traversal_cells()
    #start interactions
    itr_count = 0
    Digits = error_control['Digits']
    RhsErr    = error_control['RhsErr']
    ErrRef_electron  = error_control['ErrRef_electron']
    ErrRef_hole  = error_control['ErrRef_hole']
    ref_error = 10**(-1*Digits)
    print('')
    print('Computing boundary condtion Va = (%.2f,%.2f) V ' % (Va[0],Va[1]))
    print('Computing Coupled( 1 poisson-equation(s) , 1 electron-equation(s) , 1 hole-equation(s) ) ')
    print('using newton solver.')
    print('Interation\t |Rhs|\t |Rhs_poisson| |Rhs_elec|  |Rhs_hole|  err_poisson err_electron err_hole    time')
    print('---------------------------------------------------------------------------------------------------------------------')
    N =  num_of_cell + 1
    dT = np.zeros((3,N),np.float64)
    try:
        while itr_count<error_control['Iterations']:
            tic = time.time()
            (P, Q, W, H, T0, Jn, Jp) = gen_solve_matrix(device)
            dT = solve_the_matrix(P, Q, W, H, dT)
            T0 = T0 + dT
            poisson_rhs_error = np.linalg.norm(H[2,:],ord=2)/len(H[1,:])
            electron_rhs_error = np.linalg.norm(H[0,:],ord=2)/len(H[1,:])
            hole_rhs_error = np.linalg.norm(H[1,:],ord=2)/len(H[1,:])
            rhs_error = hole_rhs_error+electron_rhs_error+poisson_rhs_error
            ref_error_electron = np.linalg.norm(dT[2,:],ord=2)/(np.linalg.norm(H[2,:])+ErrRef_electron)/ref_error
            ref_error_hole = np.linalg.norm(dT[0,:],ord=2)/(np.linalg.norm(H[0,:])+ErrRef_hole)/ref_error
            ref_error_poisson = np.linalg.norm(dT[1,:],ord=2)/(np.linalg.norm(H[1,:]) + 1)/ref_error
            device.update(T0,normalize_operation= False)
            #device.traversal_cells()
            toc = time.time()
            print('%3d:\t\t%.2e\t%.2e\t%.2e\t%.2e\t%.2e\t%.3e\t%.2e\t%.2f' % (
            itr_count, rhs_error, poisson_rhs_error, electron_rhs_error, hole_rhs_error, ref_error_poisson,ref_error_electron,ref_error_hole,toc-tic))
            if  (abs(dT/T0)< ref_error).all() or  rhs_error < RhsErr:
                print('Finished because....')
                print('Error smaller than 1(%.2f)' % max([ref_error_hole,ref_error_electron,ref_error_poisson]))
                print('')
                print('Contact\t\t Voltage\t  electron current\thole current\ttotal current')
                print(' left\t\t%.3e\t\t %.3e\t\t %.3e\t\t%.3e\t\t' %(device.cell_array[0].Va,device.cell_array[0].electron_current_density
                                                                    ,device.cell_array[0].hole_current_density,
                                                                    device.cell_array[0].current_density))
                print(' right\t\t%.3e\t\t %.3e\t\t%.3e\t\t%.3e\t\t' % (
                                                                    device.cell_array[-1].Va, device.cell_array[-1].electron_current_density
                                                                    , device.cell_array[-1].hole_current_density,
                                                                    device.cell_array[-1].current_density))

                return True
            itr_count += 1

        if itr_count >= error_control['Iterations']:
            print('Finished because....')
            print('Reaching the maximum interactions. ' % max([ref_error_hole, ref_error_electron, ref_error_poisson]))
            return False
    except Exception as e:
        print('Error Occured: %s' % e)
        return False