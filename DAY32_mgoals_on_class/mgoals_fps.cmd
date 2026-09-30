	fset Tsub 1.0
	fset Ymax 2.0
	
	math numThreads= 8
	math coord.ucs
	
	# initial mesh
	line x location= 0.0 tag= top
	line x location= 0.1 
	line x location= $Tsub tag= bottom
	
	
	line y location= 0  	 spacing= 100.0 tag= left
	line y location= $Ymax   spacing= 100.0 tag= right
	
	
	region Silicon xlo= top xhi= bottom yhi= right ylo= left substrate
	init Silicon field= Boron concentration= 1.0e15 wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 
	
	grid set.min.normal.size= 100e-3<um> set.normal.growth.ratio.2d= 1.5
	
	refinebox clear 
	refinebox interface.materials= { Silicon PolySilicon }
	
	mgoals accuracy= 1e-5 resolution= 1.0/5.0
	
	deposit oxide thickness= 0.6<um> isotropic
	
	
	mask name= Etch segments= { 0.5 1.5 }
	
	photo mask= Etch thickness= 3.0<um>
	
	etch material= { Oxide } thickness= 0.7<um> anisotropic 
	
	strip Resist

	
	#split deposit
	
	# change mgoals settings
	mgoals accuracy= @accuracy@ resolution= 1.0/@res_steps@
	 
	deposit PolySilicon thickness= 0.5<um> type= isotropic
	
 
	struct tdr= n@node@