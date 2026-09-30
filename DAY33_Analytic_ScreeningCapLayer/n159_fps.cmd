line x location= 0.0 spacing= 0.001 tag= top
line x location= 15.0 spacing= 0.001 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init resistivity= 4.6 field= Arsenic  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 
pdbSet InfoDefault 2

deposit Oxide thickness= 0.1<um> type= anisotropic
 

implant species= Boron Oxide eff.caplayer.thick= 1.0
 
implant species= Boron Silicon dualpearson
implant Boron    dose= 4e14<cm-2> energy= 120<keV> tilt= 7 rotation= 0
strip Oxide
 
 
struct tdr= n159 !Gas

