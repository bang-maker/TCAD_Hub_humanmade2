line x location= 0.0 spacing= 10<nm>  tag= top
line x location= 0.1 spacing= 10<nm>  
line x location= 2.0 spacing= 10<nm>  tag= bottom

region Silicon xlo= top xhi= bottom  substrate
#init Silicon field= Boron concentration= 1e14 wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 
init Silicon  wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 

#AdvancedCalibration 
AdvancedCalibration 2018.06
pdbSet InfoDefault 1

#split annealing 

select z= 0 name= Boron store

set BC [pdbGet Gas_Silicon Boron BoundaryCondition]
puts "BC Default: $BC"
set Cstar [pdbGet Silicon Boron Cstar ]
puts "Cstar Default: $Cstar"

pdbSet Gas_Silicon Boron BoundaryCondition Dirichlet
pdbSet Silicon Boron Cstar @Cstar@
puts "BC Now: [pdbGet Gas_Silicon Boron BoundaryCondition]"

diffuse temperature= 850<C> time= @Time@<min>

pdbSet Silicon Boron Cstar $Cstar
pdbSet Gas_Silicon Boron BoundaryCondition $BC



struct tdr= n@node@_PostDiffuse  !Gas 