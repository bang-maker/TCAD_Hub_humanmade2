math coord.ucs 

line x location= 0.0 spacing= 0.001 tag= top
line x location= 15.0 spacing= 0.001 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init resistivity= 4.6 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 

# set the logging info level 
pdbSet InfoDefault 1


deposit Oxide thickness= 50e-3<um> type= isotropic 

pdbSet ImplantData MonteCarlo 1	
pdbSetDouble Oxide Phosphorus nucl.cor @nucl@
 
implant Phosphorus    dose= 4e14<cm-2> energy= 120<keV> tilt= 8 rotation= 0

#split anneal

diffuse temperature= 1030<C> time= 1<s> 

 
struct tdr= n@node@ !Gas