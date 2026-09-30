 
File{
	Grid = "@tdr@"
	* Parameter = "@parameter@" * not exists
	Output = "@log@"
	Plot   = "@tdrdat@"
	Current= "@plot@" 
}

!(	
	set t_init 1e-6
	set t_e 1e-6
	set t_w 1e-6
	set t_r	1e-7
	set t_f	1e-7
)!
#define Verase

Electrode{
	{Name= "sub" 		Voltage= 0.0 }
	{Name= "gate" 		Voltage= (
									0.0 at 0.0
									
	
	) }
}

Physics{ *global model
	Fermi
}

Physics(Material="Silicon"){
	* Drift-Diffuse Model
	Mobility (
	  DopingDep
	  Enormal
	  HighFieldSaturation
	)
	Recombination(
		SRH(ElectricField)  
		Auger
	)
	EffectiveIntrinsicDensity(OldSlotboom)
}

Physics(MaterialInterface="Silicon/Oxide"){
	GateCurrent(Fowler GateName="gate")
}

Math{
	Method = Super
}

Plot{
  eDensity hDensity 
  Current eCurrent  hCurrent
  Potential  SpaceCharge  ElectricField
  eMobility  hMobility  eVelocity  hVelocity
  Doping DonorConcentration AcceptorConcentration
}

Solve{ 
	Poisson
	Coupled{Poisson Electron  } 
	Coupled{Poisson Electron Hole } 
}
