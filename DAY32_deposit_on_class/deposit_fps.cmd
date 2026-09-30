	#set A0 x
	#set A1 x 
	#set A2 x
	
	fset Tsub 4.0
	fset Ymax 2.0
	math numThreadsMGoals= 4 
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
	
	#split deposit
	
	pdbSet InfoDefault 2
	
	#save tdr 
	struct tdr= n@node@_pre
	
	# change mgoals settings
	#if @case@ == 1
		deposit  Nitride thickness= 0.1<um> type= isotropic
	#elif @case@ == 2
		deposit  material= Nitride thickness= 0.1<um> type= anisotropic
	#elif @case@ == 3
		deposit  material= Nitride  type= polygon polygon= { -1.5 0.25 0.0 0.25 0.0 1.75 -1.5 1.75 } 
	#elif @case@ == 4
		deposit  material= Nitride  type= fill coord= -0.423<um> ;# x-axis
	#elif @case@ == 5
		deposit material= Nitride time= 0.1  type= crystal \
		crystal.rate = {"<100>" =1.0 "<110>" =0.1 "<111>" =0.05}
	#elif @case@ == 6
		#Fourier Deposit 1
		set A0 1.0
		set A1 0.0
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 0 0} factor= 1
		deposit nitride time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 }
	#elif @case@ == 7
		#Fourier Deposit 2
		set A0 0.0
		set A1 1.0
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 0 0} factor= 1
		deposit nitride time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 }
	#elif @case@ == 8	
		#Fourier Deposit 3
		set A0 -0.3
		set A1 0.7
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 0 0} factor= 1
		deposit Nitride time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 }
	#elif @case@ == 9
		#Fourier Deposit 4
		set A0 -0.3
		set A1 0.7
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 0 0} factor= 1
		deposit Nitride time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 }
		deposit Aluminum time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 }
	#elif @case@ == 10
		#Fourier Deposit 5
		set A0 -0.3
		set A1 0.7
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 1 0} factor= 1
		deposit Nitride time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 }
		deposit Aluminum time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 }
	#elif @case@ == 11
		#Fourier Deposit 5
		set A0 0.1
		set A1 0.7
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 1 0} factor= 1
		deposit Nitride time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 } shadowing
		 
 	#elif @case@ == 12
		#Fourier Deposit 6
		set A0 0.1
		set A1 0.7
		set A2 0.0
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 1 0} factor= 1
		deposit Nitride time= 0.2<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 } shadowing.nonisotropic
		 
	#elif @case@ == 13
	
		etch material= Silicon type= trapezoidal thickness= 2.7<um> angle= 82<degree> undercut= 0.05<um> 
		etch material= Silicon type= isotropic thickness= 0.1<um>  
		#Fourier Deposit 6
		set A0 1.0
		set A1 -0.6
		set A2 -0.1
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 0 0} factor= 1
		deposit Nitride time= 0.55<min> fourier sources= {src1} coeffs= { $A0 $A1 $A2 }   
		
	#elif @case@ == 14
		# only valid in 3D
		deposit material= PolySilicon type= trapezoidal \
		selective.materials= Silicon thickness= 0.25 angle= 120
	
	
	#elif @case@ == 15
		etch material= Silicon type= trapezoidal thickness= 2.7<um> angle= 82<degree> undercut= 0.05<um> 
		etch material= Silicon type= isotropic thickness= 0.1<um>  
		#Fourier Deposit 6
		set A0 1.0
		set A1 -0.8
		set A2 -0.1
		puts "DOE: A0 $A0"
		puts "DOE: A1 $A1"
		puts "DOE: A2 $A2"
		beam name= src1 direction= {1 0 0} factor= 1
		deposit Nitride time= 0.55<min> fourier selective.materials= {Silicon} sources= {src1} coeffs= { $A0 $A1 $A2 } 
	
	#elif @case@ == 16
	 	
		doping name= strainGe field= Germanium depths= {0 0.1} values= {1e10 1e22}
		deposit material= Silicon doping= {strainGe} type= isotropic thickness= 0.3 selective.materials= Silicon
	
	#elif @case@ == 17
		doping name= strainGe field= Germanium times= {0 0.1} values= {1e10 1e22}
		deposit material= Silicon doping= {strainGe} type= isotropic time= 0.3<min> rate= 1<um/min> selective.materials= Silicon
		#with isotropic, anisotropic, or Fourier deposition
		
	#elif @case@ == 18
		# constant field
		deposit material= Silicon type= isotropic thickness= 0.1 fields.values= {Vacancy=1e10 Germanium=2e22 } 
 
	#endif
	
	
	 
	struct tdr= n@node@_post