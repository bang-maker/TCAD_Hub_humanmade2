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

#if [string match "*Yes*" @WithCalibration@]
	term name= BoronDiffFactor add Silicon \
	eqn= "@factor@*Boron/1.0e18" store
#endif 
	
diffuse temperature= 1000<C> time= 120<min>

struct tdr= n@node@_PostDiffuse !gas !interfaces