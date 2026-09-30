math coord.ucs 

line x location= 0.0 spacing= 0.001 tag= top
line x location= 15.0 spacing= 0.001 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init resistivity= 4.6 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 

# set the logging info level 
pdbSet InfoDefault 1


set case @case@

set Energy @energy@


if { $case == 0} {

	implant Phosphorus    dose= 4e14<cm-2> energy= $Energy<keV> tilt= 8 rotation= 0 sentaurus.mc
	
} 
 
if { $case ==1 }  {
	
	implant Phosphorus    dose= 4e14<cm-2> energy= $Energy<keV> tilt= 8 rotation= 0 sentaurus.mc cascades

}

if { $case ==2 }  {  
	
	implant Phosphorus    dose= 4e14<cm-2> energy= $Energy<keV> tilt= 8 rotation= 0 sentaurus.mc  iBCA

}

#split anneal

diffuse temperature= 1030<C> time= 1<s> 

 
struct tdr= n@node@ !Gas