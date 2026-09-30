line x location= 0.0 spacing= 10<nm>  tag= top
line x location= 0.1 spacing= 10<nm>  
line x location= 2.0 spacing= 10<nm>  tag= bottom

region Silicon xlo= top xhi= bottom  substrate
init Silicon  wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 


#AdvancedCalibration 
AdvancedCalibration 2018.06
pdbSet InfoDefault 0

implant Boron energy= 120<keV> dose= 1e14<cm-2> tilt= 0 rotation= 0 

#split annealing 
 

#pdbSet Silicon Boron Int D {				
#							    0 {[Arr  0.009 3.57]}
#							    1 {[Arr  0.054 3.57]}
#					}

pdbSet Silicon Boron Int D {				
							    0 {[expr @f_BI0@*[Arr  0.009 @E@]]}
							    1 {[expr @f_BI1@*[Arr  0.054 @E@]]}
					}
puts "[pdbGet Silicon Boron Int D]"

  					
diffuse temperature= 900<C> time= 30<min>

struct tdr= n@node@_PostDiffuse !gas !interfaces