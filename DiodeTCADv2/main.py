#auther： Lanxiaomu

import logging
from NetwonSolver import *
from device import *
import csv

#config the logging module 日志文件设置
LOG_FORMAT = "%(asctime)s - %(levelname)s - %(message)s"
DATE_FORMAT = "%Y/%m/%d %H:%M:%S %p"
logging.basicConfig(level=logging.INFO, format=LOG_FORMAT, datefmt=DATE_FORMAT)
print_welcome_text()
#-------------------------------------#

DEVICE_FROM_FILE = False  #是否读取device_data.xlsx中的器件


'''step1:device defination'''
if not DEVICE_FROM_FILE:
    # 1D 突变结仿真
    L1 = 1e-3 # 器件的右端点 单位是cm
    L0 = 0    # 器件的左端点 单位是cm
    L_junction = 0.3e-3 #结所在坐标位置
    Dop_P = 5e15    # P型掺杂浓度
    Dop_N = 1e15   # N型掺杂浓度

    mesh_points = np.linspace(L0, L1,100,endpoint=True)
    mesh_data = np.empty(len(mesh_points))
    for (index, point) in enumerate(mesh_points):
        if point < L_junction:
            mesh_data[index] = Dop_N
        else:
            mesh_data[index] = -1 * Dop_P
else:
    # 从文件中读取器件结构
    mesh_points = []
    mesh_data = []
    device_structure_file = "device_data.csv"
    with open(device_structure_file,encoding='UTF-8') as f:
        reader = csv.reader(f)
        for line in reader:
            mesh_points.append(float(line[0]))
            mesh_data.append(float(line[1]))

#组装器件结构（类似senataurus中的tdr文件：器件结构+掺杂数据）
mesh_data = {'mesh_points': mesh_points, 'doping_data': mesh_data}
num_mesh_point = len(mesh_points)
##generate device(生成器件，也就是把网格与数据进行组装）
pn_diode = SEMI_DEVICE(mesh_data)
#pn_diode.draw_structure()  #使用文字打印出器件中的信息
pn_diode.set_material_parameters(material_parameters) #设置物理模型参数
np.set_printoptions(precision=20, suppress=False)   #设置numpy中打印信息的精度
## 仿真中的math control
error_control = {'Iterations':100,'Digits':8,'RhsErr': 1e-8,'ErrRef_electron':1e10,'ErrRef_hole':1e10}

#设置仿真的电压列表
Va_list = [0.0,-0.2,-0.4,-0.6,-0.8,-1.0]
## 开始依次求解仿真结果，对应sdevice中的solve过程
i = 0
plt.figure(figsize = (10,10),dpi=300) #设置绘图的尺寸
for va in Va_list:
    NewtonSolver(pn_diode,[0,va],error_control)
    plot_device(pn_diode,plt,i,r'$V_{A} = %.2f$ V' % va)
    i += 1
# 绘制能带图
plt.show()
plt.figure(figsize = (5,5),dpi=300)
plot_energyband(pn_diode,plt,r'EnergyBand @ $V_{A}$ = %.2f V' % Va_list[-1])
plt.show()

# 求解IV电流曲线
i = 0
plt.figure(figsize = (10,10),dpi=300)
Current_list = []
# 设置IV曲线中的求解的电压
Va_list = np.linspace(-1.0,1.5,100,endpoint=True)
#Va_list = np.linspace(-1.0,0.9,5,endpoint=True)
for va in Va_list:
    NewtonSolver(pn_diode,[0,va],error_control)
    # 计算电流并保存
    Current_list.append(pn_diode.current())
    # 间隔10个数据点，保存一次器件的信息
    if i % 10 == 0:
        plot_device(pn_diode,plt,int(i/20),r'$V_{A} = %.2f$ V' % va)
    i += 1
#绘制曲线
plt.tight_layout()
plt.show()

# 绘制IV曲线
plt.figure(figsize = (5,5),dpi=300)
ax1 = plt.gca()
plt.yscale('log')
plt.plot(Va_list,abs(np.array(Current_list)),'r.-')
ax1.set_xlabel(r'Voltage , $V_a$ ($V$)')
ax1.set_ylabel(r'Current, $J$ ($A/cm^2$)')
plt.show()

# 绘制能带图
plt.figure(figsize = (5,5),dpi=300)
plot_energyband(pn_diode,plt,r'EnergyBand @ $V_{A}$ = %.2f V' % Va_list[-1])
plt.show()