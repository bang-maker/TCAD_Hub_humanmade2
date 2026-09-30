 
math numThreads= 4
 

line x location= 0.0  		tag= top 		spacing= 0.03
line x location= 0.3  						spacing= 0.5
line x location= 2.0		tag= bottom		spacing= 0.8
 
line y location= 0.0	tag= left		spacing= 0.3
line y location= 5.0  	tag= right		spacing= 0.3

line z location= 0.0	tag= back		spacing= 0.3
line z location= 5.0  	tag= front		spacing= 0.3
 
region Silicon substrate xlo= top xhi= bottom ylo= left yhi= right
 
init concentration= 5e15 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0} slice.angle= 45<degree> !DelayFullD



AdvancedCalibration 

 
pdbSet InfoDefault 2

grid set.min.normal.size= 0.05<um> set.normal.growth.ratio.2d= 1.41 \
	 set.min.edge= 2e-4<um>
mgoals accuracy= 1e-5<um>
 

point name= p1 coord= {1.5 1.5}
point name= p2 coord= {1.5 3.5}
point name= p3 coord= {3.5 3.5}
point name= p4 coord= {3.5 1.5}

polygon name= RECT_MASK  points= { p1 p2 p3 p4 } 
mask 	name= IMP_MASK   polygons= { RECT_MASK } negative
deposit Nitride mask= IMP_MASK   thickness= 0.5<um>

refinebox  mask= IMP_MASK mask.edge.refine.extent= 0.5<um> mask.edge.mns= 50e-3<um> mask.edge.ngr= 1.5<um>   


grid remesh
struct tdr= n83_post_mesh

implant Phosphorus dose= 1.0e15<cm-2> energy= 100<keV> tilt= 0<degree> rotation= 180<degree>  
  
diffuse  temperature= 1030.0 time= 10<s>



struct tdr= n83 !gas


