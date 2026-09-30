###this project was created by lanxiaomu######

File{
	Grid = "@tdr@"
	Parameter = "@parameter@"  
	Output = "@log@"
	Plot   = "@tdrdat@"
	Current= "@plot@" 
 
}
 
Electrode{
	{Name= "top" 			Voltage= 0.0 Schottky Workfunction=4.5 }
	{Name= "bottom" 		Voltage= 0.0 } 
}

Physics{ *global model
	Fermi
	
	#if [string match "yes" "@NLTunneling@"]
		eBarrierTunneling "NLM"   
		hBarrierTunneling "NLM"  
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
	
		#if @case@==1 
			NonLocal "NLM" (
				Electrode= "top"
				Length= 10.0e-6	#cm 	
				Digits= 5
				EnergyResolution= 0.001
			)
		#elif @case@==2
			NonLocal "NLM" (
				Electrode= "top"
				Length= 10.0e-6	#cm 	
				Digits= 5
				EnergyResolution= 0.001
				-Transparent(Region="R.Silicon")
			)
		#elif @case@==3
			NonLocal "NLM" (
				Electrode= "top"
				Length= 10.0e-6	#cm 	
				Digits= 5
				EnergyResolution= 0.001
				-EndPoint(Region="R.Silicon") # Insulator : -EndPoint Semiconductor: EndPoint
			)
		#elif @case@==4
			NonLocal "NLM" (
					Barrier(Region="R.Oxide1")
				)
		#elif @case@==5
			NonLocal "NLM" (
					Barrier(Region="R.Oxide1")
					Permeation=2e-7
				)
		#elif @case@==6
			NonLocal "NLM" (
					Barrier(Region="R.Oxide1")
					Permeation=2e-7
					-Permeable(Region="R.Silicon")
				)
		#elif @case@==7 
			NonLocal "NLM" (
					RegionInterface="R.Sub1/R.Sub2"
					Length=20e-7
				)
		#elif @case@==8 
			NonLocal "NLM" (
					RegionInterface="R.Sub1/R.Sub2"
					Length=20e-7
					Permeation=10e-7
					 
				)
		#elif @case@==9
			NonLocal "NLM" (
					RegionInterface="R.Sub1/R.Sub2"
					Length=20e-7
					Permeation=10e-7
					-Permeable(Region="R.Sub1")
				)
		#elif @case@==10
			NonLocal "NLM" (
					RegionInterface="R.Sub1/R.Sub2"
					Length=20e-7
					Permeation=10e-7
					-Transparent(Region="R.Sub1")
				)
		
		#elif @case@==11
			NonLocal "NLM" (
				RegionInterface="R.Oxide1/R.Sub1"
				Length=15e-7
			)
			NonLocal "NLM2" (
				Electrode="top"
				Length=15e-7
			)
		
		#endif
			
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
	
	#if 0
	NewCurrentPrefix = "Boot_"  
	Quasistationary( 
	 maxstep= 0.01 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3  
	Goal{Name= "top"   Voltage= 0.0}
	){ Coupled{ Poisson Electron Hole }}
	
	NewCurrentPrefix = "IV_"  
	Quasistationary( 
	 maxstep= 0.01 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3  
	Goal{Name= "top"   Voltage= 2.0}
	){ Coupled{ Poisson Electron Hole }}
	#endif 
  }

 
