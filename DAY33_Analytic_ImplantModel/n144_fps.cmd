line x location= 0.0 spacing= 0.001 tag= top
line x location= 15.0 spacing= 0.001 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init resistivity= 4.6 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 
 
pdbSet InfoDefault 2

implant species= Phosphorus  tables= TSuprem4
 
implant species= Phosphorus Silicon dualpearson
implant Phosphorus    dose= 4e14<cm-2> energy= 120<keV> tilt= 8 rotation= 0

 
 
struct tdr= n144 !Gas

