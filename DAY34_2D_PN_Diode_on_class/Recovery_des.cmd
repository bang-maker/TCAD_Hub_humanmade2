 
Device PN {
	
	* 1 input output file 
	File{
		* input files 
		Grid = "@tdr@"

		* output files
		Plot   = "@tdrdat@"
		Current= "@plot@" * n@node@_des.plt
		
	}
	
	* 2 Boundary Condition 
	Electrode{
		{ Name= "p_contact" 	Voltage= 0.0    }
		{ Name= "n_contact" 	Voltage= 0.0  	}
	}

	 
	* 3 Physics
	
	Physics{ *global model
		Fermi
	}
	
	* material-wise
	Physics(Material="Silicon"){
		* Drift-Diffuse Model
		
		Mobility (
		  DopingDep
		  Enormal
		  #HighFieldSaturation
		)
		
		Recombination(
			SRH(
					DopingDep
				 
			)  
					Auger
	 
		)
		#band gap 
		EffectiveIntrinsicDensity(OldSlotboom)
		
		#activate traps model for Pt_my
		#if [string match "*yes*" "@PtImp@"] 
			traps(
				(Acceptor SFactor= "DeepLevels" Gaussian EnergyMid=0 EnergySig= 0.05 fromMidBandGap)
			)
		#endif 
	
		
	}
	
 
	* 4 output
	Plot{
 	  eDensity hDensity
 	  Current/Vector eCurrent/Vector hCurrent/Vector
	  eMobility hMobility
	  eVelocity hVelocity
	  ElectricField/Vector
	  Potential
	  eQuasiFermi hQuasiFermi
	  SpaceCharge
	  LatticeTemperature
	  eTemperature hTemperature
	  SRHRecombination Band2BandGeneration AugerRecombination RadiativeRecombination
	  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
	  TotalRecombination
	  eLifeTime hLifeTime
	  SurfaceRecombination
	  CDL CDL1 CDL2 CDL3
	  eCDL1lifetime eCDL2lifetime hCDL1lifetime hCDL2lifetime
 
	  Doping 
	  DonorConcentration AcceptorConcentration
 
	  BandGap 
	  BandGapNarrowing
	  ElectronAffinity
	  ConductionBandEnergy ValenceBand
	  eQuantumPotential hQuantumPotential
 
	}

} #end of Device Section 

* 5 Math 
Math{
	Method = Blocked
	SubMethod= ParDiSo
	Number_of_Threads= 4
	ExitOnFailure
	Transient= BE
}


#define _Vforward_  10.0
#define _Vreverse_ -100.0


* 6 Output Files 
File {
	Output = "@log@"
}


* 7 System 
System{
	Resistor_pset 	R1 		( 2 	1 )		{resistance= 1 }
	Vsource_pset 	V1 		( 2 	0 ) 	{ pwl = ( 
												 0.0		0
												1e-7		_Vforward_
												2e-7 		_Vforward_
												2.1e-7		_Vreverse_
												5e-7		_Vreverse_
												) }
	PN pn ( p_contact=1 n_contact=0 ) {Physics{Areafactor=1e4}}									

	Plot "n@node@_sys_des.plt" (time() v(2) v(1) i(pn,1) i(pn,0))
	
} 

* 8 Solve
Solve{
	Poisson
	Coupled(Iterations=1000 LineSearchDamping=1e-4){Poisson Electron   } 
	Coupled(Iterations=1000 LineSearchDamping=1e-4){Poisson Electron Hole  } 
	Coupled(Iterations=1000 LineSearchDamping=1e-4){Poisson Electron Hole Circuit} 
 
	NewCurrentFile= "Recovery_"
	Transient (
	InitialTime= 0.0 FinalTime= 3e-7
	InitialStep= 1e-10 Increment= 1.41
	Minstep= 1e-15 MaxStep= 1e-9
	){ Coupled {Poisson Electron Hole Circuit}
	CurrentPlot(Time=(Range=(0.0 3e-7) Intervals= 50; Range=(1.99e-7 2.05e-7) Intervals=50))
	}
 
} 