line x location= 0.0 spacing= 10<nm>  tag= top
line x location= 0.1 spacing= 10<nm>  
line x location= 2.0 spacing= 10<nm>  tag= bottom

region Silicon xlo= top xhi= bottom  substrate
init Silicon  wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 


#AdvancedCalibration 
AdvancedCalibration 2018.06
pdbSet InfoDefault 0

#split annealing 

set Dose @Dose@
implant Boron energy= 120<keV> dose= $Dose<cm-2> tilt= 0 rotation= 0 

pdbSet Silicon Boron ActiveModel @ActiveModel@

diffuse temperature= 900<C> time= 30<min>

struct tdr= n@node@_PostDiffuse !gas !interfaces