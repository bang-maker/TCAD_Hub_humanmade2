math coord.ucs 

line x location= 0.0 spacing= 0.001 tag= top
line x location= 15.0 spacing= 0.001 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init resistivity= 4.6 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 
# set the logging info level 
pdbSet InfoDefault 1

# multithreads settings for MonteCarlo
# note: multithreaded MC Implantation does not produce identical results as a single thread
math numThreadsMC= 8


#switch-on MonteCarlo Implantation for all the Ion Implant 
pdbSet ImplantData MonteCarlo 1	
pdbSet MCImplant Particles @MCParticles@

#if [string match "*yes*" "@Smoothing@"]
	pdbSet MCImplant  Smoothing 1
#else 
	pdbSet MCImplant  Smoothing 0
#endif 
 
implant Phosphorus  dose= 4e14<cm-2> energy= 120<keV> tilt= 8 rotation= 0

#split anneal

diffuse temperature= 1030<C> time= 1<s> 

 
struct tdr= n@node@ !Gas