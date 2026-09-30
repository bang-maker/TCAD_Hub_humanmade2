#header 

# define device parameter 
set Tsi 5.0
set Ymax 7.0
set Ymin 0.0
set Tmetal 0.3
#  DEBUG=1 save tdrs;  DEBUG=0 do not save tdrs;
set DEBUG 0
set CNode @node@

#endheader

fset count 0


fproc WriteTdr { Name } {
	global count
	global CNode	
	if { $count<10 } {
		struct tdr= n${CNode}_0${count}_${Name} 
	} else  {
	    struct tdr= n${CNode}_0${count}_${Name} 
	}
	fset count [expr $count+1]
} 

  
math coord.ucs 
math numThreads= 4



## define simulation region
line x location= 0.0<um> 	spacing= 0.01<um> 		tag= top
line x location= $Tsi<um> 	spacing= $Tsi/5.0<um> 	tag= bottom

line y location= $Ymin<um> 	spacing= 0.1<um> 		tag= left
line y location= $Ymax<um> 	spacing= 0.1<um> 		tag= right

region Silicon substrate xlo= top xhi= bottom ylo= left yhi= right 
                                            # Zw                     # -Yw
init concentration= 5e15<cm-3> field= Boron wafer.orient= { 0 0 1 } \
flat.orient= { 1 1 0 } slice.angle= -90<degree> !DelayFullD

#calibration
AdvancedCalibration

# Global Mesh 
# --------------------------------------------------------------------

pdbSet Grid Adaptive 1
pdbSet Diffuse Diffuse.Regrid.Steps 5

grid set.min.normal.size= 0.01<um> set.normal.growth.ratio.2d= 1.4 \
	 set.min.edge= 2e-4<um>
mgoals accuracy= 1e-5<um> resolution= 1.0/4.0

#adaptive mesh
refinebox Adaptive name= AdpMesh \
 	    refine.fields= { NetActive } def.max.asinhdiff= 0.8 \
        refine.min.edge= " 0.03 0.03 " \
        refine.max.edge= " 1  1  " \
        materials= {Silicon}  
           
grid remesh

#split ACTIVE
############
mask name= ACTIVE segments= {  1.0 2.0 3.5 6.0  } negative
photo mask= ACTIVE thickness= 1.0<um> 
if { $DEBUG } { WriteTdr photo_active }


etch material= { Silicon } type= trapezoidal rate= 0.35<um/min> time= 1.0<min> \
angle= 80<degree>
if { $DEBUG } { WriteTdr etch_Si }

strip Resist

if { $DEBUG } { WriteTdr strip_PR }
 
deposit material= Oxide type= fill coord= 0.0

if { $DEBUG } { WriteTdr fill_oxide }

#split WELL
#implant 
mask name= NWELL segments= { 2.75 6.5 }
photo mask= NWELL thickness= 1.0<um> 
if { $DEBUG } { WriteTdr photo_NWELL }


 
implant Phosphorus dose= 5.2e12<cm-2> energy= 150<keV> tilt= 0
implant Arsenic    dose= 1.4e13<cm-2> energy= 150<keV> tilt= 0
strip Resist

mask name= PWELL segments= { 2.75 6.5 } negative
photo mask= PWELL thickness= 1.0<um>   
if { $DEBUG } { WriteTdr photo_PWELL }

implant Boron 	dose= 1.1e13 energy= 150 tilt= 0.0
implant Boron 	dose= 5.3e12 energy= 26 tilt= 0.0
implant Indium	dose= 7.2e12 energy= 140 tilt= 0.0
strip Resist
if { $DEBUG } { WriteTdr strip_PR }


#split ANNEAL
diffuse temperature= 1030<C> time= @time@<min>
if { $DEBUG } { WriteTdr anneal }
# extract the Xj of NWELL/PSUB
select z= "NetActive"
# layers y= 5.0
set Xj [interpolate Silicon y= 5.0 value= 0.0]
puts "DOE: Xj [format %.3f $Xj]"

#split SD
mask name= Pplus  segments= { 1.0  2.0 }   
photo mask= Pplus thickness= 1.0 
if { $DEBUG } { WriteTdr photo_pplus }
implant Boron dose= 3.0e13<cm-2> energy= 15<keV> tilt= 0 rotation= 0
strip Resist
if { $DEBUG } { WriteTdr strip_PR }

mask name= Nplus  segments= { 3.5  6.0}   
photo mask= Nplus thickness= 1.0    
if { $DEBUG } { WriteTdr photo_nplus }
implant Arsenic    dose= 5.3e15<cm-2> energy= 60<keV> tilt= 0 rotation= 0

strip Resist
if { $DEBUG } { WriteTdr strip_PR }

SetPlxList { NetActive }
WritePlx n@node@_pn.plx y= 5.0


#split ANNEAL_SD
diffuse temperature= 1030 time= 1.0<min>


#split METAL
deposit material= Oxide thickness= 0.2<um> type= isotropic

mask name= CNT segments= { 1.1 1.9  4.2 5.2}
photo mask= CNT thickness= 1.0
#struct tdr= n@node@_photo_CNT
etch material= Oxide thickness= 0.21<um> type= anisotropic
strip Resist

deposit material= Aluminum thickness= $Tmetal<um> type= isotropic
# struct tdr= n@node@_Al_dep

mask  name= METAL1 segments= { 2.5  3.5 } negative
etch mask= METAL1 material= Aluminum thickness= $Tmetal*2.0<um> type= anisotropic

contact name= N point x= -0.35<um> y= $Ymax<um> replace
contact name= P point x= -0.35<um> y= $Ymin<um> replace

#split REMESH


line clear 
refinebox clear 

pdbSet Grid SnMesh DelaunayType boxmethod
pdbSet Grid sMesh 1
pdbSet Grid SnMesh DelaunayTolerance 0.0

refinebox Adaptive name= Remesh \
 	    refine.fields= { NetActive } def.max.asinhdiff= 0.8 \
        refine.min.edge= " 0.03 0.03 " \
        refine.max.edge= " 0.4  0.4  " \
        materials= {Silicon} 

refinebox interface.mat.pairs= {Silicon Oxide} \
 min.normal.size= 0.01 normal.growth.ratio= 1.5

grid remesh
 
struct tdr= n@node@ !Gas !interfaces

