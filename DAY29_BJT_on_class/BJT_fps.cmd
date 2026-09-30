 
#header
	# parameter define
	set Tsub 		10.0
	set Ymin 		-1.0
	set Ymax 		6.0 
	# STI
	set STI_depth 	0.5
	set STI_tilt	85
	set Tpoly		0.2
	set Tox_pass	1.0
	set Tox_pass_tilt 86
	
#endheader

	math numThreads= 8
	math coord.ucs
	
	# initial mesh
	line x location= 0.0 tag= top
	line x location= 0.1 
	line x location= $Tsub tag= bottom
	
	line y location= $Ymin   spacing= 100.0 tag= left
	line y location= $Ymax   spacing= 100.0 tag= right
	 
	region Silicon xlo= top xhi= bottom ylo= left yhi= right substrate
	init Silicon field= Boron concentration= 1.0e15 wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 
	
	#mesh 
	grid set.min.normal.size= 3e-3<um> set.normal.growth.ratio.2d= 1.5 
	refinebox clear 
	refinebox interface.materials= { Silicon PolySilicon }  
	
	#moving boundary algorithm setting
	mgoals accuracy= 1e-5 resolution= 1.0/3.0
	
	AdvancedCalibration
	
	
	pdbSet Oxide_Silicon Boundary BoundaryCondition ThreePhaseSegregation 
	
	pdbSet ImplantData ResistSkip 1
	pdbSet ImplantData BackBoundary  Reflect
	pdbSet ImplantData LeftBoundary  Reflect
	pdbSet ImplantData FrontBoundary Reflect
	pdbSet ImplantData RightBoundary Reflect
	pdbSet Mechanics EtchDepoRelax 0
	
	#if [string match "*adaptive*" "@mesh_type@"] 
		fset adaptive_flag 1
		
		# activate Adaptive Mesh
		pdbSet Grid Adaptive 1
		pdbSet Grid SnMesh UseLines 1
		
		# Adaptive Activation Setting 
		pdbSet Diffuse Growth.Regrid.Steps -1 ;# during oxidation and silicidation
		pdbSet Diffuse Epi.Regrid.Steps -1 ;# during epitaxy
		pdbSet Diffuse Compute.Regrid.Steps 5 ;# during inert annealings
		# Implant!
		
		
		
		# During Diffusion minimal adaptive temperature 
		pdbSet Grid Min.Adaptive.Temp 600
		
		#-- max 1.0
		pdbSet Grid Refine.Percent 0.1 ;# the percentage of edges that fail
		#-- max 100
		pdbSet Grid Unrefine.Percent 75

		
	#else
		fset adaptive_flag 0
	#endif 
	
	
	#adaptive mesh setting 
	if { $adaptive_flag == 1 } {
		#default 
		pdbSet Grid AdaptiveField Refine.Abs.Error     1e37
        pdbSet Grid AdaptiveField Refine.Rel.Error     1e10
        pdbSet Grid AdaptiveField Refine.Target.Length 100
        
        #overide default list
        refinebox Adaptive  
        
        # type 1
        refinebox Adaptive  name= AdapMesh_NetActive \
		max.asinhdiff= { NetActive=0.8 } \
        refine.min.edge= " 0.008 0.008 " \
        refine.max.edge= " 1  1  " \
        materials= {Silicon} 
        
        
        # type 2 
        # refinebox Adaptive name= AdaptMesh_NetActive \ 
        # def.max.asinhdiff= 0.8 refine.fields= { NetActive }   
        
		refinebox Adaptive  name= AdapMesh_Dopant refine.fields= { Boron Arsenic Phosphorus } \
		max.dose.error= {Boron= 1e9 Arsenic= 1e9 Phosphorus= 1e9} \
		max.asinhdiff=  {Boron= 1.0 Arsenic= 1.0 Phosphorus= 1.0} \
        refine.min.edge= " 0.01 0.01 " \
        refine.max.edge= " 1  1  " \
        materials= {Silicon}
        	
        refinebox list
        refinebox print
	}
	
	 
	
#split NWELL
	





	mask name= NWELL segments= { 0.5 4.5 }    info= 1
	
	deposit oxide thickness= 0.05<um> anisotropic
	## auto remesh 
	
	photo mask= NWELL thickness= 5.0
	## auto remesh 
	
	if { $adaptive_flag == 0 } {
		# refine mesh 
		refinebox name= BG min= " -5.0 $Ymin " max= "10.0 $Ymax " xrefine= 1.0 yrefine= 1.0 zrefine= 1.0
		refinebox name= NwellMaskInsideMesh mask= NWELL \
			extend= 0.5<um> xrefine= {0.5 0.2 0.05}   yrefine= {0.05 0.5 0.05} \
			extrusion.min= 0.0 extrusion.max= 1.5 
		
		grid remesh
		## no - auto remesh
	}
	
	implant Arsenic dose= 2.0e12<cm-2>   energy= 1500<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 2.0e12<cm-2>   energy= 1000<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=  600<keV> tilt= 15 mult.rot= 4
	implant Arsenic dose= 5.0e12<cm-2>   energy=  250<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=  100<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=   70<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=   40<keV> tilt= 0 rotation= 0
	implant Arsenic dose= 5.0e12<cm-2>   energy=   20<keV> tilt= 0 rotation= 0
	
	strip Photoresist

#split DRIVE

	diffuse time= 1<min> temperature= 1100<C>
	strip Oxide 

#split STI
	#-- STI Formation
	mask name= STI segments= { 0.75 3.0 3.5 4.25 }  info= 1 negative
	photo mask= STI thickness= 5.0 
	etch material= {Silicon} type= trapezoidal rate= $STI_depth time= 1.0 angle= $STI_tilt
	strip Photoresist
	deposit Oxide fill coord= -0.0
	deposit Oxide type= isotropic thickness= 0.004<um>

#split BASE
	#-- Base Formation
	mask name= BASE segments= { 0.5 3.25 }  info= 1  
	
	if { $adaptive_flag == 0 } {
		#mesh 
		refinebox name= BaseInsideMesh mask= BASE \
		materials= {Silicon} extend= 0.25<um> xrefine= 0.01  \
		extrusion.min= 0.0<um> extrusion.max= 0.3<um>
		
		grid remesh	
		##
	}
	
	photo mask= BASE thickness= 3.0<um>
	implant Boron dose= 6.15e13<cm-2> energy= 10<keV> tilt= 0 rotation= 0
	strip Photoresist
	etch oxide type= anisotropic rate= 0.004<um/min> time= 1.5<min>
	#--- Base Active
	diffuse time= 1<min> temperature= 1000<C>

#split EMITTER
	doping  name= PolyDop field= Arsenic   depths= "0 $Tpoly" values= "2.0e20 2.0e20"
	deposit material= { PolySilicon } doping= PolyDop type= isotropic thickness= $Tpoly
	
	mask name= EMITTER segments= { 2.00 3.00  }   negative
	mask name= EMITTER_inverted bool= "-EMITTER"
	
	if { $adaptive_flag == 0 } {
		# refine 
		refinebox name= EmitterInsideMesh mask= EMITTER_inverted \
			materials= {Silicon} extend= 0.03<um> xrefine= {0.002}  \
			extrusion.min= 0.0<um> extrusion.max= 0.05<um>
		
		grid remesh
	}
	
	photo mask= EMITTER thickness= 3.0<um> 
	etch  material= {PolySilicon} type= anisotropic  thickness= $Tpoly*1.1
	strip Resist
	#--- Emitter Active
	diffuse time= 2<min> temperature= 1000<C>

#split NPplus
	mask name= NPLUS segments= { 3.5 4.25 } 
	photo mask= NPLUS thickness= 3.0<um>
	
	implant Arsenic    dose= 1.5e15<cm-2> energy= 50<keV> tilt= 0 rotation= 0
	implant Phosphorus dose= 1.5e15<cm-2> energy= 80<keV> tilt= 0 rotation= 0
	
	strip Resist
	
	mask name= PPLUS segments= { 1.0 1.75 } 
	photo mask= PPLUS thickness= 3.0<um>
	
	implant BF2 dose= 1.5e15<cm-2> energy= 10<keV> tilt= 0 rotation= 0
	
	strip Resist
	
	diffuse time= 1<min> temperature= 1000<C>

#split CONTACT
	
deposit  Oxide type= fill coord= -1*$Tox_pass<um>
	
	mask name= VIA segments= { 1.1 1.6 2.25 2.75 3.65 4.15 }
	photo mask= VIA thickness= 3.0<um>
	
	etch material= {Oxide} type= trapezoidal rate= 1.1*$Tox_pass time= 1.0 angle= $Tox_pass_tilt
	
	strip Resist
	
	deposit Aluminum type= fill coord= -1*$Tox_pass<um>
	

#split REMESH

	#-    data (doping stress ... )---based on sprocess mesh(poor quality for sdevice)
	pdbSet Grid SnMesh DelaunayType boxmethod 
	pdbSet Grid sMesh 1
	pdbSet Grid SnMesh DelaunayTolerance 0.0
	
	
	#--- 
	refinebox clear  ;# refinebox is saved in TDR file
	line clear 
	
	#-- remesh command
	refinebox name= Interface_mesh interface.mat.pairs= {Silicon Oxide PolySilicon Oxide} min.normal.size= 6e-3<um> normal.growth.ratio= 1.5
	
	refinebox name= SiliconTop_REMESH min= { 0.0 $Ymin } max= { $Tsub $Ymax } xrefine= { 0.3  2.0 }  yrefine= 0.5<um> 
	# field-based mesh
	refinebox name= Silicon_REMESH \
 	    refine.fields= { NetActive } def.max.asinhdiff= 0.7 \
        refine.min.edge= " 0.04 0.04 " \
        refine.max.edge= " 1.0  1.0  " \
        materials= {Silicon} 
        
	refinebox name= Silicon_Adaptive_REMESH \
	refine.fields= { NetActive } def.max.asinhdiff= 0.9 \
	refine.min.edge= " 0.005 0.005 " \
	refine.max.edge= " 1.0  1.0  " \
	min= { 0.0 $Ymin } max= { 0.3 $Ymax } \
	materials= {Silicon} 
	
	#for highly doped region 
	refinebox name= Silicon_Adaptive2_REMESH \
	refine.fields= { NetActive } def.max.dose.error= 5e9 \
	refine.min.edge= " 0.005 0.005 " \
	refine.max.edge= " 1.0  1.0  " \
	min= { 0.0 $Ymin } max= { 0.3 $Ymax } \
	materials= {Silicon}   

	grid remesh 
	
	contact name= base 		point x= -0.5*$Tox_pass<um> y= 1.35<um> !replace
    contact name= emitter 	point x= -0.5*$Tox_pass<um> y= 2.50<um> !replace
    contact name= collector	point x= -0.5*$Tox_pass<um> y= 3.90<um> !replace
    contact name= substrate bottom
	
	struct tdr= n@node@ !Gas !interfaces
	 