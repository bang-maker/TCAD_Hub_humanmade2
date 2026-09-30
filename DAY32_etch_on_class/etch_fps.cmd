	#set A0 x
	#set A1 x 
	#set A2 x
	
	fset Tsub 1.0
	fset Ymax 2.0
 
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
	
	deposit oxide thickness= 0.1<um> isotropic
	
	deposit PolySilicon thickness= 0.5<um> isotropic
	
	mask name= Etch segments= { 0.5 1.5 }
	
	photo mask= Etch thickness= 3.0<um>
	
	etch material= { PolySilicon Oxide } thickness= 0.7<um> anisotropic 
	
	strip Resist
	
	mask name= Etch2 segments= { 1.5 1.75 }
	
	photo mask= Etch2 thickness= 3.0<um>
	
	etch material= { PolySilicon  } thickness= 0.25<um> anisotropic 
	
	strip Resist
	
	#split etch
	
	#save tdr 
	struct tdr= n@node@_pre
	
	pdbSet InfoDefault 2
	
	# change mgoals settings
	#if @case@ == 1
		 etch  material= {PolySilicon} thickness= 0.1<um>  type= isotropic
		 #etch  material= {PolySilicon} time= 1.0<min> rate= 0.1<um/min> type= isotropic
	#elif @case@ == 2
		 etch  material= {PolySilicon Silicon Oxide} thickness= 0.1<um>  type= isotropic
	#elif @case@ == 3
		 etch  material= {  Silicon  } thickness= 0.1<um> type= anisotropic
	#elif @case@ == 4
		 etch  material= {  PolySilicon  } thickness= 0.1<um> type= anisotropic
	#elif @case@ == 5
		 etch material= {  Silicon  } rate= 0.1 time= 1.0 type= directional direction= {1 1} ;# vector vx,vy
	#elif @case@ == 6
		 etch material= {  Silicon  }  type= polygon  polygon= {-0.1 0.1 0.1 0.1 0.1 0.6 -0.1 0.6}
	#elif @case@ == 7
		 etch type= cmp coord= 0.05 material= all
	#elif @case@ == 8	
		 etch type= cmp coord= 0.05 material= {PolySilicon}
	#elif @case@ == 9
		#Fourier Etching 1
		set A0 1.0
		set A1 0.0
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		
		beam name= src1 direction= {1 0 0} factor= 1
		etch material= {  Silicon  } type= fourier sources= { src1 } coeffs= {$A0 $A1 $A2} time= 0.2<min>
			# A0 A1 A2 ...An : <um/min> 
			# time <min>
	
	
		 
	#elif @case@ == 10
		#Fourier Etching 2
		set A0 0.0
		set A1 1.0
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		
		beam name= src1 direction= {1 0 0} factor= 1
		etch material= {  Silicon  } type= fourier sources= src1 coeffs= {$A0 $A1 $A2} time= 0.2 
	#elif @case@ == 11
		#Fourier Etching 3
		set A0 0.0
		set A1 0.0
		set A2 1.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		
		beam name= src1 direction= {1 0 0} factor= 1
		etch material= {  Silicon  } type= fourier sources= src1 coeffs= {$A0 $A1 $A2} time= 0.2  
 	#elif @case@ == 12
		#Fourier Etching 4
		set A0 -0.5
		set A1 0.717
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		
		beam name= src1 direction= {1 0 0} factor= 1
		etch material= {  Silicon  } type= fourier sources= src1 coeffs= {$A0 $A1 $A2} time= 0.2 
	#elif @case@ == 13
		#Fourier Etching 5
		beam name= src1 direction= {1 0 0} factor= 1
		etch sources= {src1} type= fourier remesh= false time= 0.6 \
		mat.coeffs= { Silicon= {-1 2} Oxide= {0.1} PolySilicon= {-0.05 0.2} }	
		 		
	#elif @case@ == 14
		#Fourier Etching 6 shadowing
		set A0 0
		set A1 1.0
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		
		beam name= src1 direction= {1 1 0} factor= 1
		etch material= {  Silicon  } type= fourier sources= src1 coeffs= {$A0 $A1 $A2} time= 0.2 shadowing	 			
	#elif @case@ == 15
		#Fourier Etching 6 shadowing
		set A0 0.2
		set A1 1.0
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		
		beam name= src1 direction= {1 1 0} factor= 1
		etch material= {  Silicon  } type= fourier sources= src1 coeffs= {$A0 $A1 $A2} time= 0.2 shadowing.nonisotropic 
	#elif @case@ == 16
		#Fourier Etching 6 shadowing
		set A0 0.2
		set A1 1.0
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		
		beam name= src1 direction= {1 1 0} factor= 1
		etch material= {  Silicon  } type= fourier sources= src1 coeffs= {$A0 $A1 $A2} time= 0.2 shadowing
	#elif @case@ == 17
		etch material= {  Silicon  } type= crystal \
		crystal.rate= {"<100>" =1.0 "<110>" =0.5 "<111>" =0.1} time= 0.25
	
	#elif @case@ == 18
		etch material= silicon type= trapezoidal thickness= 0.25<um> angle= 120<degree> undercut= 0.1<um>
		
	#elif @case@ == 19	
		beam name= src1 direction= {1 0 0} factor= 1
		etch type= angles.rates sources= src1 time= 0.2 \
		angles.rates= { Silicon= { 25 1.0 45 0.3 } }	
		 
	#endif
	
	
	 
	struct tdr= n@node@_post