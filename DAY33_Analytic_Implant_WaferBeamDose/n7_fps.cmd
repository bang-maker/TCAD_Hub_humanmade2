 
fset Tsi 5.0
  
math numThreads= 4
 

line x location= 0.0  		tag= top 		spacing= 0.01
line x location= 0.3  						spacing= 0.1
line x location= $Tsi		tag= bottom		spacing= $Tsi/5.0
 
line y location= 0.0	tag= left		spacing= 0.1
line y location= 10.0  	tag= right		spacing= 0.1
 
region Silicon substrate xlo= top xhi= bottom ylo= left yhi= right
 
init concentration= 5e15 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}  slice.angle= -90

grid 2D

AdvancedCalibration 
pdbSet InfoDefault 2

pdbSet Grid Adaptive 1
pdbSet Diffuse Diffuse.Regrid.Steps 5
pdbSet Grid Refine.Percent 0.1

pdbSet InfoDefault 2

grid set.min.normal.size= 0.01<um> set.normal.growth.ratio.2d= 1.41 \
	 set.min.edge= 2e-4<um>
mgoals accuracy= 1e-5<um>
	 
	 
refinebox Adaptive name= AdpMesh \
 	    refine.fields= { NetActive } def.max.asinhdiff= 1.0 \
        refine.min.edge= " 0.01 0.01 " \
        refine.max.edge= " 1  1  " \
        materials= {Silicon}  
           
grid remesh
 
mask name= OD segments= {5.0 10.0}
photo mask= OD thickness= 3.0

pdbSet ImplantData DoseControl WaferDose


implant Phosphorus dose= 1.0e15<cm-2> energy= 100<keV> tilt= 15 rotation= -90<degree> temperature= 300<K>
  
diffuse  temperature= 1030.0 time= 10<s>

struct tdr= n7 !gas


