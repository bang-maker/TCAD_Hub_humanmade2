line x location= 0.0 spacing= 0.002 tag= top
line x location= 15.0 spacing= 0.002 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init resistivity= 4.6 field= Arsenic  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 
pdbSet InfoDefault 2
 
implant species= Boron Silicon pearson
implant species= Boron Silicon rp= @rp@ stdev= @stdev@ gamma= @gamma@ beta= @beta@

implant Boron dose= 1e14<cm-2> energy= @energy@<keV> tilt= 7 rotation= 0

struct tdr= n@node@ !Gas