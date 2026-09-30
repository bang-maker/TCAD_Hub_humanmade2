line x location= 0.0 spacing= 10<nm>  tag= top
line x location= 0.1 spacing= 10<nm>  
line x location= 2.0 spacing= 10<nm>  tag= bottom

region Silicon xlo= top xhi= bottom  substrate
init Silicon  wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 


#Advanced calibration 
#AdvancedCalibration
AdvancedCalibration 2018.06
#>> Mode select 
#	SiGe_and_Stress_Effect  ;#the impact of Ge and Stress on Diffusion and Activation
#   AdvancedPowerDeviceMode ;# for power device  
#   AdvancedMLAModel		  ;# for Laser Annealing
#   AdvancedNitrogenModel   ;# switches on equations for the diffusion and clustering of nitrogen in silicon. 
#   AdvancedFluorineModel   ;# the impact of fluorine on transient-enhanced diffusion and on boron dose loss. 
#   AdvancedModels		    ;# switch on complex physical models for various clustering phenomena in silicon
#   AdvancedSPERModel		  ;# switches on the solid phase epitaxial regrowth (SPER) model and parameter


source ./my_advcal.fps

pdbSet InfoDefault 0

implant Boron energy= 120<keV> dose= 1e14<cm-2> tilt= 0 rotation= 0 
 				
diffuse temperature= 900<C> time= 30<min>

struct tdr= n@node@_PostDiffuse !Gas !interfaces