line x location= 0.0 spacing= 10<nm>  tag= top
line x location= 0.1 spacing= 10<nm>  
line x location= 2.0 spacing= 10<nm>  tag= bottom

region Silicon xlo= top xhi= bottom  substrate
init Silicon concentration= 1e15<cm-3> field= @Dopant@ wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 


#AdvancedCalibration 
AdvancedCalibration 2018.06
pdbSet InfoDefault 0
 
#split annealing 
 
pdbSet Oxide_Silicon  @Dopant@ BoundaryCondition Segregation ;#switch the BC to Segregation
puts "Default Segregation Parameter K_s: [pdbGet Oxide_Silicon  @Dopant@  Segregation]" 

#if [string match "default" "@K_s@"]
	# pdbSet Oxide_Silicon  @Dopant@  Segregation @K_s@
#else
	pdbSet Oxide_Silicon  @Dopant@  Segregation @K_s@
#endif 
	
diffuse temperature= 1000<C> time= 40<min> H2O

struct tdr= n@node@_PostDiffuse !gas !interfaces