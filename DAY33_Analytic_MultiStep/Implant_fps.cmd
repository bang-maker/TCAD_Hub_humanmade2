line x location= 0.0 spacing= 0.001 tag= top
line x location= 15.0 spacing= 0.001 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init resistivity= 4.6 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 
pdbSet InfoDefault 2

#if "@model@"=="PAI"
	pdbSet ImplantData DamageControl PAI
	pdbSet Silicon PAIThreshold @Nth@
#else
	pdbSet ImplantData DamageControl CoImplant
#endif
 
	implant Arsenic dose= 2.0e12<cm-2>   energy= 1500<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 2.0e12<cm-2>   energy= 1000<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=  600<keV> tilt= 15 mult.rot= 4
	implant Arsenic dose= 5.0e12<cm-2>   energy=  250<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=  100<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=   70<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=   40<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=   20<keV> tilt= 0 rotation= 0 
 
struct tdr= n@node@ !Gas