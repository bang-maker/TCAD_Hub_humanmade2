#add gas region immediately
pdbSet Grid AddGasMesh 1

#math settings
math coord.ucs

#line defination
line x location= 0.0  tag= top
line x location= 5.0  tag= bottom

line y location= 0.0    tag= right
line y location= 3.0   tag= left

region Silicon substrate xlo= top xhi= bottom ylo= right yhi= left
init concentration= 5e15 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 

mgoals accuracy= 1e-7 resolution= 1.0/4.0 repair.angle= 5
grid set.min.normal.size= 1<um>  set.normal.growth.ratio.2d= 1.8  

mask name= trench_mask segments= { 1.25 1.75 } 

photo mask= trench_mask thickness= 1<um>

etch Silicon type= trapezoidal angle= 86<degree> thickness= 1.5<um>

etch Silicon type= isotropic thickness= 0.2<um>

strip Resist 

beam name= oxide_beam direction= { 1 0 0 }
deposit Oxide type= fourier sources= {oxide_beam} coeffs= { 1.0 1.0 0.8 } time= 0.1<min>

deposit PolySilicon type= isotropic thickness= 1.0<um>

etch type= cmp coord= 0.0<um>

#split trench
#############mesh commands############
refinebox clear
line clear

# Interface mesh 
## Axis-Aliged Mesh 
#----------------------sytax----------------------------------#
#    refinebox min.normal.size=<n> normal.growth.ratio=<n> \
#	 normal.growth.depth=<n>  max.lateral.size=<n> \
#	 [interface.materials= <list> | interface.mat.pairs= <list>]
#----------------------sytax----------------------------------#
# all interfaces in touch with Silicon and Oxide
#if [string match "1" @case@] && [string match "*interface_AAM*" @mesh_type@]
	refinebox interface.materials= {Silicon Oxide} min.normal.size= 5e-3<um> \
	normal.growth.ratio= 1.8 normal.growth.depth= 0.3<um> max.lateral.size= 1.0<um>
#endif

# only Silicon/Oxide interfaces
#if [string match "2" @case@] && [string match "*interface_AAM*" @mesh_type@]
	refinebox interface.mat.pairs= {Silicon Oxide} min.normal.size= 5e-3<um> \
	normal.growth.ratio= 1.8 normal.growth.depth= 0.3<um> max.lateral.size= 1.0<um>
#endif

# only Silicon/Oxide Silicon/Gas interfaces
#if [string match "3" @case@] && [string match "*interface_AAM*" @mesh_type@]
	refinebox interface.mat.pairs= {Silicon Oxide Silicon Gas} min.normal.size= 5e-3<um> \
	normal.growth.ratio= 1.8 normal.growth.depth= 0.3<um> max.lateral.size= 1.0<um>
#endif
 
# only Silicon/Oxide Silicon/Gas PolySilicon/Oxide interfaces
#if [string match "4" @case@] && [string match "*interface_AAM*" @mesh_type@]
	refinebox interface.mat.pairs= {Silicon Oxide Silicon Gas PolySilicon Oxide} min.normal.size= 5e-3<um> \
	normal.growth.ratio= 1.8 normal.growth.depth= 0.3<um> max.lateral.size= 1.0<um>
#endif

# only Silicon/Oxide Silicon/Gas PolySilicon/Oxide interfaces
#if [string match "5" @case@] && [string match "*interface_AAM*" @mesh_type@]
	#global setting
	pdbSet Grid SnMesh min.normal.size 10e-3
	pdbSet Grid SnMesh normal.growth.ratio.2d 1.8
	pdbSet Grid SnMesh normal.growth.ratio.3d 3.0
	#using Grid command
	#grid set.min.normal.size= 10e-3<um> set.normal.growth.ratio.2d= 1.8 set.normal.growth.ratio.3d= 3.0
	# refinebox assign materials
	refinebox interface.materials= {PolySilicon Silicon} 
#endif

# location limited refinement
#if [string match "6" @case@] && [string match "*interface_AAM*" @mesh_type@]
	refinebox  name= HappyNewYear min= {1.0 1.0 } max= {2.0 2.0} \
	interface.mat.pairs= {Silicon Oxide} min.normal.size= 5e-3<um> \
	normal.growth.ratio= 1.8 normal.growth.depth= 0.3<um> max.lateral.size= 1.0<um>
#endif

# mask basde refinemment
#if [string match "7" @case@] && [string match "*interface_AAM*" @mesh_type@]
	refinebox  mask= trench_mask extrusion.min= 1.0<um> extrusion.max= 2.0<um> \
	interface.mat.pairs= {Silicon Oxide Silicon Gas PolySilicon Oxide} min.normal.size= 5e-3<um> \
	normal.growth.ratio= 1.8 normal.growth.depth= 0.3<um> max.lateral.size= 1.0<um>
#endif

# mask basde refinemment(with extend)
#if [string match "8" @case@] && [string match "*interface_AAM*" @mesh_type@]
	refinebox  mask= trench_mask extrusion.min= 1.0<um> extrusion.max= 2.0<um>  extend= 0.5<um> \
	interface.mat.pairs= {Silicon Oxide Silicon Gas PolySilicon Oxide} min.normal.size= 5e-3<um> \
	normal.growth.ratio= 1.8 normal.growth.depth= 0.3<um> max.lateral.size= 1.0<um>
#endif

# mask basde refinemment(with extend)
#if [string match "9" @case@] && [string match "*interface_AAM*" @mesh_type@]
	refinebox  max= {5.0 3.0} min= {0.0 1.5} \
	mask= trench_mask extrusion.min= 1.0<um> extrusion.max= 2.0<um>  extend= 0.5<um> \
	interface.mat.pairs= {Silicon Oxide Silicon Gas PolySilicon Oxide} min.normal.size= 5e-3<um> \
	normal.growth.ratio= 1.8 normal.growth.depth= 0.3<um> max.lateral.size= 1.0<um>
#endif


#####################  offsetting  mesh ##############################
#----------------------sytax----------------------------------#
#	refinebox offsetting min.normal.size=<n> normal.growth.ratio=<n>
# 	[ interface.mat.pairs= <list>] [interface.region.pairs= <list>]
#----------------------sytax----------------------------------#

#if [string match "1" @case@] && [string match "*interface_offsetting*" @mesh_type@]
	refinebox offsetting min.normal.size= 10e-3<um> normal.growth.ratio= 1.5 interface.mat.pairs= { Silicon Oxide }
#endif

#if [string match "2" @case@] && [string match "*interface_offsetting*" @mesh_type@]
	refinebox offsetting min.normal.size= 10e-3<um> normal.growth.ratio= 1.5 interface.mat.pairs= { Silicon Oxide } \
	!double.side
#endif

#if [string match "3" @case@] && [string match "*interface_offsetting*" @mesh_type@]
	refinebox offsetting min.normal.size= 10e-3<um> normal.growth.ratio= 1.5 interface.mat.pairs= { Silicon Oxide } 
	refinebox offsetting.maxlevel= 10 interface.materials= { Silicon }
#endif

#if [string match "4" @case@] && [string match "*interface_offsetting*" @mesh_type@]
	refinebox offsetting min.normal.size= 10e-3<um> normal.growth.ratio= 1.5 interface.mat.pairs= { Silicon Oxide } 
	refinebox offsetting.maxlevel= 10 interface.materials= { Silicon }
	refinebox offsetting.maxlevel= 2 interface.materials= { Oxide }
#endif

#if [string match "5" @case@] && [string match "*interface_offsetting*" @mesh_type@]
	refinebox offsetting max= { 2.0 2.0 } min= { 1.0 1.0 } min.normal.size= 10e-3<um> normal.growth.ratio= 1.5 interface.mat.pairs= { Silicon Oxide } 
	refinebox offsetting.maxlevel= 10 interface.materials= { Silicon }
	refinebox offsetting.maxlevel= 2 interface.materials= { Oxide }
#endif

#if [string match "6" @case@] && [string match "*interface_offsetting*" @mesh_type@]
	#global setting
	pdbSet Grid SnMesh offsetting.maxlevel 5.0
	refinebox offsetting min.normal.size= 10e-3<um> normal.growth.ratio= 1.5 interface.mat.pairs= { Silicon Oxide PolySilicon Oxide} 
#endif


#####################  body  mesh ##############################
#----------------------sytax----------------------------------#
#	refinebox min=<list> max=<list> xrefine=<list> yrefine=<list> zrefine=<list> \ 
#	materials=<list>
#----------------------sytax----------------------------------#

#if [string match "1" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox xrefine= 0.05<um>  yrefine= 0.2<um>
#endif

#if [string match "2" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox min= {3 1} max= {4 2}  xrefine= 0.05<um>  yrefine= 0.2<um>
#endif

#if [string match "3" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox min= {3 1} max= {4 2}  xrefine= {0.01 0.1}   yrefine= {0.01 0.1}
#endif

#if [string match "4" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox min= {3 1} max= {4 2}  xrefine= {0.01 0.1 0.01}   yrefine= {0.01 0.1 0.01}
#endif


#if [string match "5" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox mask= trench_mask extrusion.max= 4.0<um> extrusion.min= 3.0<um> xrefine= {0.01 0.1 0.01}   yrefine= {0.01 0.1 0.01}
#endif

#if [string match "6" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox mask= trench_mask extrusion.max= 4.0<um> extrusion.min= 3.0<um> extend= -0.2<um> xrefine= {0.01 0.1 0.01}   yrefine= {0.01 0.1 0.01}
#endif

#if [string match "7" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox mask= trench_mask extrusion.max= 4.0<um> extrusion.min= 3.0<um> extend= 0.5<um> xrefine= {0.01 0.1 0.01}   yrefine= {0.01 0.1 0.01}
#endif

#if [string match "8" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox mask= trench_mask extrusion.max= 2.0<um> extrusion.min= 1.0<um>   xrefine= 0.01   yrefine=  0.01 
#endif

#if [string match "9" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox materials= {Silicon PolySilicon} mask= trench_mask extrusion.max= 2.0<um> extrusion.min= 1.0<um>   xrefine= 0.01   yrefine=  0.01 
#endif

#if [string match "10" @case@] && [string match "*body_mesh*" "@mesh_type@" ]
	refinebox mask= trench_mask mask.edge.refine.extent= 0.5<um> mask.edge.mns= 5e-3<um> mask.edge.ngr= 1.5<um> \
	extrusion.max= 1.0<um> extrusion.min= 2.0<um>
#endif


# final mesh 
#if  [string match "*mixed*" "@mesh_type@" ]
	#body mesh: coarse
	refinebox name= Global xrefine= 5.0/10<um> yrefine= 3.0/10.0<um>
	#interface offsetting 
	refinebox name= Offsetting_Trench offsetting min.normal.size= 5e-3<um> normal.growth.ratio= 1.3 \
	interface.mat.pairs= {Silicon Oxide PolySilicon Oxide} 
	refinebox offsetting.maxlevel= 5 interface.materials= { Silicon PolySilicon }
	refinebox offsetting.maxlevel= 3 interface.materials= { Oxide}
	#mask based mesh 
	refinebox name= Trench_mask_mesh mask= trench_mask extrusion.max= 2.0 extrusion.min= 1.0 extend= 0.5<um> \
	xrefine= 0.1<um> yrefine= 0.1<um>
	# top silicon refine 
	refinebox name= source_refine materials= {Silicon} min= {0.0 0.0} max= {2.0 3.0} xrefine= {0.01 0.1}
	 
#endif

grid remesh 

struct tdr= n@node@_@mesh_type@_case@case@  




