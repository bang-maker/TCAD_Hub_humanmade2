## 2D 
## tcl tools command language

fset W 1.5
# save the variables into the tdr file
fset Wmetal 0.4   
# initial boundary

line x location= 0.0  		tag= top 		spacing= 0.01
line x location= 0.3  						spacing= 0.01
line x location= 1.0  		tag= bottom		spacing= 0.1
 
line y location= -$W/2.0 	tag= left		spacing= 0.1
line y location=  $W/2.0  	tag= right		spacing= 0.1

region Silicon substrate xlo= top xhi= bottom ylo= left yhi= right
if {"@type@"=="ntype"} {
	set sub_doping Boron
} else {
	set sub_doping Arsenic
}

init concentration= 5e15 field= $sub_doping 
grid 2D

AdvancedCalibration 

pdbSet Grid Adaptive 1
pdbSet Diffuse Diffuse.Regrid.Steps 5
#pdbSet Diffuse Growth.Regrid.Steps 20
#pdbSet Diffuse Epi.Regrid.Steps 30
pdbSet Grid Refine.Percent 0.1
#pdbSet Grid Unrefine.Percent 75 ###?????
  
#refinebox name= SiTop min= {0.0 -0.2 }  max= { 0.3  0.2 }  \
#           xrefine= {0.05} yrefine= {0.05}  all add

#interface Silicon/SiO2 ...XXXX/YYYY
grid set.min.normal.size= 0.01<um> set.normal.growth.ratio.2d= 1.41 \
	 set.min.edge= 2e-4<um>
####
mgoals accuracy= 1e-5<um>
	 
	 
#adaptive mesh
refinebox Adaptive name= AdpMesh \
 	    refine.fields= { NetActive } def.max.asinhdiff= 1.0 \
        refine.min.edge= " 0.001 0.001 " \
        refine.max.edge= " 0.05  0.05  " \
        materials= {Silicon}  
           
grid remesh



# define mask
mask name= N_IMP segments= {-0.2 0.2}  
mask name= VIA1  segments= {-0.1 0.1}
# Resist exists outside the mask [negative]
#split NIMP
photo mask= N_IMP thickness= 1.0
if {"@type@"=="ntype"} {
	implant Arsenic dose= 1.0e14 energy= @Energy@ tilt= 0 rotation= 0
} else {
	implant Boron   dose= 1.0e14 energy= @Energy@ tilt= 0 rotation= 0
}


                    
strip Resist
#annealing !!!!!!!!!!!!!!!!!!!!!!
diffuse temperature= 1030 time= 1.0<min>

struct tdr= pre_oxide_n@node@
#split OXIDATION
#oxidation !!!!!!!!!!!!!!!!!!!!!!
diffuse O2 temperature= 950 time=10<min>
 
# select z=1 
# set layersinfo [layers y=0 ]
# set TopOxide [lindex [lindex $layersinfo 1] 0]
# set BottomOxide [lindex [lindex $layersinfo 1] 1]
# set thickOfOxide [format "%.2f" [expr ($BottomOxide - $TopOxide)*1e3 ]]
# puts "DOE: tox $thickOfOxide"

struct tdr= post_oxide_n@node@


#split METAL

###Layer thickness; sheet resistance 
set Tox [format %.2f [expr [interface Oxide thickness y=0.0]*1e3 ]]
puts "DOE: Tox_nm $Tox"

deposit material= Nitride type= isotropic \
  rate= 0.4<um/min> time= 1.0<min>
photo mask= VIA1 thickness= 1.0
etch material= {Nitride Oxide} thickness= 0.8 type= anisotropic
strip Resist

struct tdr= etch_Nidtride_oxide_n@node@
##metal
set Tmetal 0.2
mask name= Metal1 segments= {-0.3 0.3} negative
deposit material= {Aluminum} thickness= $Tmetal type= isotropic
photo mask= Metal1 thickness= 1.0
etch material= {Aluminum} thickness= $Tmetal*1.5 type= anisotropic
strip Resist

###contact

contact name= N  x= -0.5*$Tmetal y= 0 replace point
	
contact bottom name= P Silicon

### remesh for sdevice 





# save the structure as n@node@_fps.tdr
struct tdr= n@node@ !gas

