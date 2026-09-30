#header
# math setting 
math coord.ucs
math numThreads= 4

#pdb setting 
pdbSet InfoDefault 1

#device parameter
set Tsi 4.0
set DEBUG 1
set CNode @node@
#endheader


fset count 1

fproc WriteTdr { NAME } {
	global count
	global CNode
	if { $count<10 } {
		struct tdr= n${CNode}_0${count}_${NAME}
	} else {
		struct tdr= n${CNode}_${count}_${NAME}
	} 
	fset  count [expr $count+1 ]
} 


line x location= 0.0<um>  		spacing= 0.01<um>		tag= top 		
line x location= 0.3<um>  		spacing= 0.1<um>
line x location= $Tsi<um>		spacing= $Tsi/5.0<um>	tag= bottom		
 
line y location= 0.0<um>		spacing= 0.1<um>		tag= left		
line y location= 7.0<um>  		spacing= 0.1<um>		tag= right		


# Initial simulation domain
# -------------------------

region Silicon substrate xlo= top xhi= bottom ylo= left yhi= right


# Initialize the simulation
# -------------------------

init concentration= 5e15<cm-3> field= Boron wafer.orient= {0 0 1} flat.orient= {1 1 0}


#calibration
AdvancedCalibration

# Global Mesh settings for automatic meshing in newly generated layers
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



#mask 
mask name= active  segments= { 1.0 2.0 3.5  6.0}  negative


photo mask= active thickness= 1.0
if { $DEBUG } { WriteTdr photo1 }
etch material= Silicon type= trapezoidal rate= 0.35<um/min> time= 1.0<min> angle= 80<degree>
if { $DEBUG } { WriteTdr etch1 }
strip Resist
if { $DEBUG } { WriteTdr etch2 }
deposit material= Oxide  type= fill coord= 0.0
 
#split implant
#mask 
mask name= NWELL segments= { 2.75  6.5 }    
photo mask= NWELL thickness= 1.0
if { $DEBUG } { WriteTdr photo2 }
#implant Phosphorus dose= 1.4e13<cm-2> energy= 400<keV> tilt= 0 
implant Phosphorus dose= 5.2e12<cm-2> energy= 150<keV> tilt= 0
implant Arsenic    dose= 1.4e13<cm-2> energy= 150<keV> tilt= 0
strip Resist

mask name= PWELL segments= { 2.75 6.5 }  negative 
photo mask= PWELL thickness= 1.0
implant Boron 	dose= 1.1e13 energy= 150 tilt= 0.0
implant Boron 	dose= 5.3e12 energy= 26 tilt= 0.0
implant Indium	dose= 7.2e12 energy= 140 tilt= 0.0
strip Resist

#split anneal
diffuse temperature= 1030 time= 1.0<min>
set SR [SheetResistance y=5]
select z= "NetActive" 
layers y= 5
set xj [interpolate Silicon y=5 value= 0.0]
puts "DOE: xj [format %.3f $xj]"
puts "DOE: SheetR [format %.3e [lindex [lindex $SR 0] 9]] " 
puts "[lindex $SR 0] "
puts "[lindex [lindex $SR 0] 9] " 

foreach char [lindex $SR 0] {
	puts $char
}

#split PLUS
mask name= Pplus  segments= { 1.0  2.0 }   
photo mask= Pplus thickness= 1.0                
implant Boron dose= 3.0e13<cm-2> energy= 15<keV> tilt= 0 rotation= 0
strip Resist
mask name= Nplus  segments= { 3.5  6.0}   
photo mask= Nplus thickness= 1.0    
implant Arsenic    dose= 5.5e15<cm-2> energy= 60<keV> tilt= 0 rotation= 0
strip Resist

#split anneal2
diffuse temperature= 1030 time= 1.0<min>


#split PtImp
###################### code for MC Implant ############################
if [ string match "*yes*" "@PtImp@" ]  {
	#Pt Implant 
	pdbSetDouble ImplantData Pt_my AtomicNumber 78
	pdbSetDouble ImplantData Pt_my AtomicMass 	195.078
	
	implant species= Pt_my Silicon
	# X datexcodes 
	implant Pt_my energy= 3000<keV> dose= @PtDose@ sentaurus.mc
	
	#W/O activation
	
	
	sel  name= DeepLevels z= Pt_my store 
} 
###################### code for MC Implant ############################
 

#split metal
deposit material= Oxide thickness= 0.2<um> type= isotropic

mask name= CNT segments= { 1.1 1.9  4.2 5.2}
photo mask= CNT thickness= 1.0
etch material= Oxide thickness= 0.21<um> type= anisotropic
strip Resist

deposit material= Aluminum thickness= 0.3<um> type= isotropic
mask name= METAL1 segments= { 2.5  3.5 }
photo mask= METAL1 thickness= 1.0
etch material= Aluminum thickness= 0.31<um> type= anisotropic
strip Resist

contact name= n_contact point x= -0.35<um> y= 7<um> replace
contact name= p_contact point x= -0.35<um> y= 0<um> replace

#split remesh 

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

SetPlxList   { NetActive }
WritePlx n@node@_doping_diode.plx  y= 2.5 Silicon
 

struct tdr= n@node@ !gas !interfaces


