line x location= 0.0 spacing= 0.001 tag= top
line x location= 5.0 spacing= 0.001 tag= bottom

region Silicon substrate xlo= top xhi= bottom
init concentration= 5e15 field= Boron  wafer.orient= {0 0 1} flat.orient= {1 1 0}

AdvancedCalibration 

pdbSet Grid Adaptive 1
pdbSet Diffuse Diffuse.Regrid.Steps 5
# max 1.0
pdbSet Grid Refine.Percent 0.1
# max 100
pdbSet Grid Unrefine.Percent 75

#NWELL
implant Phosphorus dose= 1.2e13<cm-2> energy= 360<keV> tilt= 0 
implant Phosphorus dose= 3.0e12<cm-2> energy= 130<keV> tilt= 0
implant Arsenic    dose= 1.0e13<cm-2> energy= 100<keV> tilt= 0

#NIMP
implant Arsenic    dose= 5.5e15<cm-2> energy= 60<keV> tilt= 0 rotation= 0
implant Phosphorus dose= 1.5e14<cm-2> energy= 35<keV> tilt= 0 rotation= 0
diffuse temperature= 1030 time= 1.0<min>

#split remesh
struct tdr= n@node@_preRemesh !Gas


##############adaptive mesh################
refinebox  clear 
line clear 

# boxmethod conformal constratined(default)
grid  set.Delaunay.type= boxmethod   
pdbSet Grid AdaptiveField Refine.Abs.Error     1e37
pdbSet Grid AdaptiveField Refine.Rel.Error     1e10
pdbSet Grid AdaptiveField Refine.Target.Length 100
########
line x location= 0.0 
line x location= 5.0
 
refinebox Silicon min= 0.0<um> max= 5.0<um> xrefine= 0.5<um>


#if [string match "*max.difference*" "@mesh_type@"]
#max.difference
	refinebox Silicon Adaptive refine.fields= { @remesh_field@ } \
		def.max.difference= @value@ \
		refine.max.edge= 1.0<um> refine.min.edge= 1e-3<um>
#endif

#if [string match "*rel.error*" "@mesh_type@"]
#max.difference
	refinebox Silicon Adaptive refine.fields= { @remesh_field@ } \
		def.rel.error= @value@ def.abs.error= @abs.error@  \
		refine.max.edge= 1.0<um> refine.min.edge= 1e-3<um>
#endif


#if [string match "*max.logdiff*" "@mesh_type@"]
#max.difference
	refinebox Silicon Adaptive refine.fields= { @remesh_field@ } \
		def.max.logdiff= @value@ def.abs.error= @abs.error@  \
		refine.max.edge= 1.0<um> refine.min.edge= 1e-3<um>
#endif

#if [string match "*asinhdiff*" "@mesh_type@"]
#max.difference
	refinebox Silicon Adaptive refine.fields= { @remesh_field@ } \
		def.max.asinhdiff= @value@  \
		refine.max.edge= 1.0<um> refine.min.edge= 1e-3<um>
#endif

#if [string match "*max.dose*" "@mesh_type@"]
#max.difference
	refinebox Silicon Adaptive refine.fields= { @remesh_field@ } \
		def.max.dose.error= @value@  \
		refine.max.edge= 1.0<um> refine.min.edge= 1e-3<um>
#endif




grid remesh

struct tdr= n@node@_postRemesh !Gas  




