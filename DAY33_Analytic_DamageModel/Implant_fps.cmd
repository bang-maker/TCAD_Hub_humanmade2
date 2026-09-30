line x location= 0.0 spacing= 0.001 tag= top
line x location= 15.0 spacing= 0.001 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init resistivity= 4.6 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 


# Type0 : Gaussian 
# Type1 : For light ion species
# Type2 : For heavier ions 

# Boron  	 	0keV--- Type0 ----  20keV ----Type1
# Phosphorus	0keV--- Type0 ----  55keV ----Type1
# Arsenic 		0keV--- Type2 ---- 170keV ----Type0


implant species= @species@ Silicon damage
 
implant @species@    dose= 4e14<cm-2> energy= @energy@<keV> tilt= 7 rotation= 0
 
 
struct tdr= n@node@ !Gas