 
	
	fset Tsub 1.0
	fset Ymax 5.0
	fset Zmax 5.0
 
	math coord.ucs
 
	# initial mesh
	line x location= 0.0 tag= top
	line x location= 0.1 
	line x location= $Tsub tag= bottom
	
	
	line y location= 0  	 spacing= 100.0 tag= left
	line y location= $Ymax   spacing= 100.0 tag= right
	
	line z location= 0  	 spacing= 100.0 tag= front
	line z location= $Zmax   spacing= 100.0 tag= back
	
	region Silicon xlo= top xhi= bottom yhi= right ylo= left zhi= back zlo= front substrate
	init Silicon field= Boron concentration= 1.0e15 wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 
	
	grid set.min.normal.size= 100e-3<um> set.normal.growth.ratio.2d= 1.5
	
	refinebox clear 
	refinebox interface.materials= { Silicon PolySilicon }
	
	mgoals accuracy= 1e-5 resolution= 1.0/5.0
 
	#split shape
	
	#save tdr 
	struct tdr= n@node@_pre
	# 1: mgoals
	# 2: sentaurus structure editor interface (only 3D)
	
	sde logfile= n@node@_sde_logfile
	
	pdbSet Mechanics EtchDepoRelax 0
	
	
	pdbSet InfoDefault 2
	
	#if @case@ == 1
		  sde on ;#without mgoals
		  #deposit PolySilicon thickness= 1.5<um> type= anisotropic
		  beam name= src1 direction= {1 0 0} factor= 1
		  deposit Nitride time= 2 fourier sources= {src1} coeffs= { -0.3 0.7 }
		                  
		  #sde off  ;# using mgoals
		  #deposit Oxide thickness= 1.5<um> type= anisotropic
 
		  
	#elif @case@ == 2
		  sde off ;#mgoals
		  PolyHedronSTI "test1" left 0.0 1.5 0.5 0.0 $Zmax 0.5 80 0.05 0.1 0.1 0.1 "Oxide" ;#based on sde
		  insert polyhedron= "test1" new.material= "Oxide" ;#insert into sprocess
		  deposit PolySilicon thickness= 1.5<um> type= anisotropic
		  deposit Oxide       thickness= 1.5<um> type= anisotropic
		  #PolyHedronSTI name= "test" direction= front X0= 0.0 Y0= 1.0 Depth= 0.5 Zmin=0.0 Zmax=$Zmax Tsti= 0.5 Asti=80 Hsti=0.5 Rd=0.1 Rb=0.1 Ru=0.1
	 #elif @case@ == 3
	 	 sde on ;# does not need insert command
	 	 PolyHedronSTI "test1" left 0.0 1.5 0.5 0.0 $Zmax 0.5 80 0.05 0.1 0.1 0.1 "Oxide"
		 PolyHedronSTI "test" right 0.0 0.5 0.5 0.0 $Zmax 0.5 80 0.05 0.1 0.1 0.1 "Oxide"
		 deposit PolySilicon thickness= 1.5<um> type= anisotropic
		 deposit Oxide       thickness= 1.5<um> type= anisotropic
	 #elif @case@ == 4
	 	 sde on
	 	 set Depth 0.3
	 	 set DepthSTI 0.8
	 	 PolyHedronSTI "test1" left 0.0 [expr $Ymax/2.0+$Depth] $Depth 0.0 [expr $Zmax/2.0-$Depth ] $DepthSTI 80 0.05 0.1 0.1 0.1 "Oxide"
		 PolyHedronSTI "test2" right 0.0 [expr $Ymax/2.0-$Depth] $Depth 0.0 [expr $Zmax/2.0 ] $DepthSTI 80 0.05 0.1 0.1 0.1 "Oxide"
		 PolyHedronSTIaccc  "corner1"  lf  0.0 [expr $Ymax/2.0-$Depth] [expr $Zmax/2.0+$Depth]  $DepthSTI 80 0.05 0.1 0.1 0.1 $Depth "Oxide"
		 PolyHedronSTIaccv  "corner2"  lf  0.0 [expr $Ymax/2.0+$Depth] [expr $Zmax/2.0-$Depth] $Depth $DepthSTI 80 0.05 0.1 0.1 0.1 $Depth  
		 PolyHedronSTI "test3" back 0.0 [expr $Ymax/2.0+$Depth] $Depth  [expr $Zmax/2.0  ] $Zmax  $DepthSTI 80 0.05 0.1 0.1 0.1 "Oxide"
		 PolyHedronSTI "test4" front 0.0 [expr $Ymax/2.0-$Depth] $Depth [expr $Zmax/2.0+$Depth*2.0  ] $Zmax  $DepthSTI 80 0.05 0.1 0.1 0.1 "Oxide"
 	#elif @case@ == 5
 		 sde off
 		 polyhedron name="STI" tdr= n@node:-1@_post_fps.tdr materials= {Oxide}
 		 insert polyhedron= "STI" new.material= "Oxide"
 	#elif @case@ == 6
 		 sde off 
 		 point name= p1 coord= {1.0 0.5}
 		 point name= p2 coord= {2.0 0.6}
 		 point name= p3 coord= {2.0 1.4}
 		 point name= p4 coord= {1.0 1.5}
 		 
 		 polygon name= "2D_Polygon" xy points= { p1 p2 p3 p4 } 
 		 polyhedron name= "3D_Polyhedron" polygons= "2D_Polygon" min= 0.0 min= 0.5
 		 insert polyhedron= "3D_Polyhedron" new.material= "Oxide"
 	#elif @case@ == 7
 		 sde on
 		 sde external {
 		 	 (sdegeo:create-sphere (position  0.0  2.5  2.5  ) 2.0 "Aluminum" "Aluminum_1")
 		 	 (sdegeo:create-sphere (position -1.0  2.5  2.5  ) 2.0 "Gold" "Aluminum_1")
		 }
		 polyhedron name= sphere external.sde
		 sde off
		 insert polyhedron= sphere 
 
	#endif
	
	
	 
	struct tdr= n@node@_post