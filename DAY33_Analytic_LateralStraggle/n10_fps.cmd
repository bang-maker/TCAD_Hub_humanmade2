 
math numThreads= 1
 

line x location= 0.0  		tag= top 		spacing= 0.01
line x location= 0.3  						spacing= 0.1
line x location= 5.0		tag= bottom		spacing= 1.0
 
line y location= 0.0	tag= left		spacing= 0.1
line y location= 10.0  	tag= right		spacing= 0.1
 
region Silicon substrate xlo= top xhi= bottom ylo= left yhi= right
 
init concentration= 5e15 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}  slice.angle= -90
grid 2D

AdvancedCalibration 
pdbSet InfoDefault 2

grid set.min.normal.size= 0.01<um> set.normal.growth.ratio.2d= 1.41 \
	 set.min.edge= 2e-4<um>
 
mgoals accuracy= 1e-5<um> 
	 
 
refinebox xrefine= 0.1<um> yrefine= 0.1<um>
grid remesh
 
mask name= OD segments= {5.0 10.0}
photo mask= OD thickness= 3.0


	implant species= Phosphorus Silicon !depth.dependent
		implant species= Phosphorus Silicon lat.stdev= 0.2 lat.stdev2= 0.2

	



implant Phosphorus dose= 1.0e15<cm-2> energy= 200<keV> tilt= 0<degree> rotation= 90
diffuse temperature= 1030<C> time= 10<s>

struct tdr= n10 !gas


