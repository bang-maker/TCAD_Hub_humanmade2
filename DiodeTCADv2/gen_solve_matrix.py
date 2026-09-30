from models import *
import numpy as np
from device import *
from parameters import *
import time
# simulation setups

# 使用追赶法求解线性方程组
def gen_solve_matrix(device):
    # paramters
    cell_array = device.cell_array
    # 差分单元的数量
    Ncell = len(cell_array)
    # 网格点的数量
    Npoint = Ncell+1
    P = np.zeros((3,3,Npoint),np.float64)
    Q = np.zeros((3,3,Npoint),np.float64)
    W = np.zeros((3,3,Npoint),np.float64)
    H = np.zeros((3,Npoint),np.float64)

    for cell0 in cell_array:
        #计算差分值
        cell0.comput_diffs()

    #计算 P矩阵
    for i in range(2,Npoint-1):
        cell0 = cell_array[i-1]
        cell1 = cell_array[i]
        hmk0 = (cell1.hm + cell0.hm)/2.0
        P[0,0,i] = -1*cell0.Jn_n_k/hmk0
        P[1,1,i] = -1*cell0.Jp_p_k/hmk0  #
        P[0,2,i] = -1*cell0.Jn_phi_k/hmk0
        P[1,2,i] = -1*cell0.Jp_phi_k/hmk0  #
        P[2,2,i] = 1/(hmk0*cell0.hm) #

    #计算Q矩阵
    for i in range(1,Npoint-1):
        cell0 = cell_array[i-1]
        cell1 = cell_array[i]
        hmk0 = (cell1.hm + cell0.hm)/2.0
        Q[0,0,i] = (cell1.Jn_n_k-cell0.Jn_n_kp1)/hmk0 - cell1.R_n_k #Jn n_k
        Q[1,0,i] = cell1.R_n_k # Jp n_K
        Q[2,0,i] = -1          # poisson nk
        Q[0,1,i] = -1*cell1.R_p_k
        Q[1,1,i] = (cell1.Jp_p_k- cell0.Jp_p_kp1)/hmk0 + cell1.R_p_k #Jp p_k
        Q[2,1,i] = 1           # poisson pk
        Q[0,2,i] = (cell1.Jn_phi_k-cell0.Jn_phi_kp1)/hmk0 #Jn phi_k
        Q[1,2,i] = (cell1.Jp_phi_k-cell0.Jp_phi_kp1)/hmk0 #Jp phi_k
        Q[2,2,i] = -1/hmk0*(1/cell0.hm+1/cell1.hm) #poisson phi_k !

    #计算 W矩阵
        W[0,0,i] = cell1.Jn_n_kp1/hmk0      #Jn n_k+1
        W[1,1,i] = cell1.Jp_p_kp1/hmk0      #Jp p_k+1
        W[0,2,i] = cell1.Jn_phi_kp1/hmk0    #Jn phi_k+1
        W[1,2,i] = cell1.Jp_phi_kp1/hmk0    #Jp phi_k+1
        W[2,2,i] = 1/(hmk0*cell1.hm)        # possion phi_k+1

    #计算H矩阵
        H[0,i]= (-1*cell1.Jn + cell0.Jn )/hmk0 + cell1.R
        H[1,i]= (-1*cell1.Jp + cell0.Jp )/hmk0 - cell1.R
        H[2,i]= -1/hmk0*((cell1.phi1-cell1.phi0)/cell1.hm-(cell1.phi0-cell0.phi0)/cell0.hm)-(cell1.p0-cell1.n0+cell1.dop0)


    Jn = np.zeros((1,Npoint),np.float64)
    Jp = np.zeros((1,Npoint),np.float64)
    T = np.zeros((3, Npoint),np.float64)
    for (index,cell0) in enumerate(cell_array):
        Jn[0,index] = cell0.Jn
        Jp[0,index] = cell0.Jp
        T[0,index] = cell0.n0
        T[1,index] = cell0.p0
        T[2,index] = cell0.phi0
    Jn[0,-1]=cell_array[-1].Jn
    Jp[0,-1]=cell_array[-1].Jp
    T[0, -1] = cell_array[-1].n1
    T[1, -1] = cell_array[-1].p1
    T[2, -1] = cell_array[-1].phi1

    return ( P, Q, W, H, T, Jn, Jp )


def solve_the_matrix(P,Q,W,H,dT):
    N = len(P[1, 1, :])
    U1 = np.zeros((3,3,N),np.float32)
    U2 = np.zeros((3,3,N),np.float32)
    H2 = np.zeros((3,N),np.float32)
    U1[:,:,1] = Q[:,:,1]
    U2[:,:,1] = W[:,:,1]
    H2[:,1] = H[:,1]#.copy()
    for i in range(2,N-1):
        U1[:,:,i]= Q[:,:,i] -  P[:,:,i] @ np.linalg.pinv(U1[:,:,i-1]) @ U2[:,:,i-1]
        U2[:,:,i] = W[:,:,i]#.copy()
        H2[:,i] = H[:,i] -  P[:,:,i]  @  np.linalg.pinv(U1[:,:,i-1])  @  H2[:,i-1]

    for t in range(N-2,0,-1):
        dT[:,t] = np.linalg.pinv(U1[:,:,t]) @ H2[:,t] - np.linalg.pinv(U1[:,:,t])@U2[:,:,t]@dT[:,t+1]
    return dT

#产生雅克比矩阵
def gen_Jacobin_matrix(device):
    # paramters
    cell_array = device.cell_array
    # 差分单元的数量
    Ncell = len(cell_array)
    # 网格点的数量
    Npoint = Ncell+1
    # 更新差分值
    for cell0 in cell_array:
        #计算差分值
        cell0.comput_diffs()
    #初始化雅克比矩阵
    JacobinMatrix = np.zeros((3*(Ncell-1),3*(Ncell-1)),np.float64)
    for i in range(Ncell-1):
        cell0 = cell_array[i]
        cell1 = cell_array[i+1]
        hmk0 = (cell1.hm+cell0.hm)/2.0
        if i != 0 :
            #poisson
            JacobinMatrix[i,i-1] = 1.0/hmk0/cell0.hm #poisson phi_k-1
        JacobinMatrix[i,i]  =   -1.0/hmk0*(1.0/cell1.hm+1.0/cell0.hm) #poisson phi_k
        if i != Ncell-2:
            JacobinMatrix[i,i+1] = 1.0/hmk0/cell1.hm #poisson phi_k+1
        JacobinMatrix[i,i + Ncell-1] = -1.0 #poisson n_k
        JacobinMatrix[i,i + 2*Ncell -2] = 1.0 # poisson p_k

        #electron
        if i !=0:
            JacobinMatrix[i + Ncell-1,i - 1] = -cell0.Jn_phi_k/hmk0           #electron phi_k-1
            JacobinMatrix[i + Ncell-1,i - 1 + Ncell-1] = -cell0.Jn_n_k/hmk0           #electron n_k-1
        JacobinMatrix[i+Ncell-1,i] = (cell1.Jn_phi_k-cell0.Jn_phi_kp1)/hmk0   #electron phi_k
        if i != Ncell - 2:
            JacobinMatrix[i + Ncell-1, i + 1] = cell1.Jn_phi_kp1/hmk0         #electron phi_kp1
            JacobinMatrix[i + Ncell-1, i + Ncell-1 + 1] = cell1.Jn_n_kp1/ hmk0  #electron n_kp1
        JacobinMatrix[i + Ncell-1, i + Ncell-1] = (cell1.Jn_n_k - cell0.Jn_n_kp1) / hmk0 - cell1.R_n_k  #electron n_k
        JacobinMatrix[i + Ncell-1, i + 2*Ncell-2] = - cell1.R_p_k  # electron p_k

        #hole
        if i != 0:
            JacobinMatrix[i + 2*Ncell-2, i - 1] = -cell0.Jp_phi_k/hmk0 #hole phi_k-1
            JacobinMatrix[i + 2*Ncell-2, i - 1 + 2*Ncell-2] = -cell0.Jp_p_k/hmk0 #hole p_k-1
        JacobinMatrix[i + 2*Ncell-2, i ] = (cell1.Jp_phi_k - cell0.Jp_phi_kp1)/hmk0
        if i != Ncell - 2:
            JacobinMatrix[i + 2*Ncell-2,i + 1] = cell1.Jp_phi_kp1/hmk0 #hole phi_k+1
            JacobinMatrix[i + 2*Ncell-2,i + 1 + 2*Ncell-2] = cell1.Jp_p_kp1/hmk0 #hole p_k+1
        JacobinMatrix[i+2*Ncell-2,i+2*Ncell-2] = (cell1.Jp_p_k-cell0.Jp_phi_kp1)/hmk0 + cell1.R_p_k #hole p_k
        JacobinMatrix[i+2*Ncell-2,i+Ncell-1] = cell1.R_n_k
    # generate values
    T_solve = np.zeros(((Ncell-1)*3,), np.float64)
    T_all = np.zeros(((Ncell+1)*3,), np.float64)
    for i in range(Ncell-1):
        cell0 = cell_array[i]
        T_solve[i] = cell0.phi1
        T_solve[i+Ncell-1] = cell0.n1
        T_solve[i+Ncell*2 -2] = cell0.p1

    cell_last= None
    for i in range(Ncell):
        cell0 = cell_array[i]
        T_all[i] = cell0.phi0
        T_all[i+Ncell+1] = cell0.n0
        T_all[i+Ncell*2 + 2] = cell0.p0
        cell_last = cell0
    T_all[Ncell] = cell_last.phi1
    T_all[2*Ncell+1] = cell_last.phi1
    T_all[3*Ncell+2] = cell_last.phi1

    B = np.zeros(((Ncell-1)*3,),np.float64)
    for i in range(Ncell-1):
        cell0 = cell_array[i]
        cell1 = cell_array[i+1]
        hmk0 = (cell1.hm + cell0.hm)/2.0
        B[i] = -1 / hmk0 * ((cell1.phi1 - cell1.phi0) / cell1.hm - (cell1.phi0 - cell0.phi0) / cell0.hm) - (
                cell1.p0 - cell1.n0 + cell1.dop0)
        B[i+ Ncell -1] = (-1 * cell1.Jn + cell0.Jn) / hmk0 + cell1.R
        B[i+ 2*Ncell -2] =(-1 * cell1.Jp + cell0.Jp) / hmk0 - cell1.R
    return (JacobinMatrix,B,T_solve,T_all)

def LinearSolver(A,B):
    return np.linalg.inv(A)@B


if __name__ == "__main__":
    ## 以下是本文件的测试代码，请忽略
    ##device data
    L1 = 1e-4  # cm
    L0 = 0
    L_junction = 0.5e-4
    Dop_P = 1e17
    Dop_N = 1e17
    mesh_points = np.linspace(L0, L1, 100, endpoint=True)
    mesh_data = np.empty(len(mesh_points))
    for (index, point) in enumerate(mesh_points):
        if point > L_junction:
            mesh_data[index] = Dop_N
        else:
            mesh_data[index] = -1 * Dop_P
    mesh_data = {'mesh_points': mesh_points, 'doping_data': mesh_data}
    num_mesh_point = len(mesh_points)
    # generate device
    pn_diode = SEMI_DEVICE(mesh_data)
    pn_diode.set_material_parameters(material_parameters)
    np.set_printoptions(precision=1, suppress=False)
    dT = np.zeros((3,len(mesh_points)),np.float64)
    (P, Q, W, H, T, Jn, Jp) = gen_solve_matrix(pn_diode)
    print(solve_the_matrix(P,Q,W,H,dT))
    # pn_diode.traversal_cells()


