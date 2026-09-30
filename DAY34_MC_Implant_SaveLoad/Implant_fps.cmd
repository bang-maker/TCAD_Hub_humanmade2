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
math numThreadsMC= 4


#switch-on MonteCarlo Implantation for all the Ion Implant 
pdbSet ImplantData MonteCarlo 1	
pdbSet MCImplant Particles @MCParticles@

# structure modification!!
# deposit Oxide type= isotropic thickness= 1.0<um> 
implant Phosphorus  dose= @dose@  energy= @energy@  tilt= 0  rotation= 0 load.mc file= ./mcdata/Phosphorus_D@dose@_E@energy@_mc

#split anneal

diffuse temperature= 1030<C> time= 1<s> 

 
struct tdr= n@node@ !Gas