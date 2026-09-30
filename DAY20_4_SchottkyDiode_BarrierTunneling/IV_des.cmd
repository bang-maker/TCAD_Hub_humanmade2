###this project was created by lanxiaomu######
File{
	Grid = "@tdr@"
	Parameter = "@parameter@"  
	Output = "@log@"
	Plot   = "@tdrdat@"
	Current= "@plot@" 
	#if 0
		#if [string match "yes" "@NLTunneling@"]
			NonLocalPlot = "n@node@_nlm_plot_des.tdr"  
		#endif
	#endif
	
}

 

Electrode{
	{Name= "top" 			Voltage= 0.0 Schottky Workfunction=4.5 }
	{Name= "bottom" 		Voltage= 0.0 } 
}

Physics{ *global model
	Fermi
	
	#if [string match "yes" "@NLTunneling@"]
		eBarrierTunneling "NLM"  hBarrierTunneling "NLM" 
	#endif
}

Physics(Material="Silicon"){
	* Drift-Diffuse Model
	Mobility (
	  DopingDep
	  HighFieldSaturation
	)
	Recombination(
		SRH(ElectricField)  
		Auger
	)
	EffectiveIntrinsicDensity(OldSlotboom)
}


Math{
	Method = Super
	#if [string match "yes" "@NLTunneling@"]
		NonLocal "NLM" (
			# where is the barrier 
			Electrode= "top"
			# maxium length of the Nonlocal mesh
			Length= 10.0e-6 #centimeter
			# 
			Digits= 5
			EnergyResolution= 0.001
		)
	#endif
	ExitOnFailure
	# ExtendedPrecision
	ErrRef(Hole) =1e11
	ErrRef(Electron) =1e11
	Iterations=20
	
	
}

Plot{
  eDensity hDensity 
  Current eCurrent  hCurrent
  Potential  SpaceCharge  ElectricField
  eMobility  hMobility  eVelocity  hVelocity
  Doping DonorConcentration AcceptorConcentration
  ConductionBandEnergy ValenceBandEnergy
  
  # for visulize NLM
  eBarrierTunneling hBarrierTunneling
  NonLocal
  
}

Solve{ 
	Poisson
 
	Coupled{Poisson Electron  } 
	Coupled{Poisson Electron Hole } 
	
	NewCurrentPrefix = "Boot_"  
	Quasistationary( 
	 maxstep= 0.01 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3  
	Goal{Name= "top"   Voltage= 5.0}
	){ Coupled{ Poisson Electron Hole }}
	
	NewCurrentPrefix = "IV_"  
	Quasistationary( 
	 maxstep= 0.01 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3  
	Goal{Name= "top"   Voltage= -5.0}
	){ Coupled{ Poisson Electron Hole }}
  }

 
