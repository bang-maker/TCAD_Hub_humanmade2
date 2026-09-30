File {
	Grid       = "@tdr@"
	Parameters = "@parameter@"
	Output     = "@log@"
	Current    = "@plot@"
	Plot       = "@tdrdat@"
}

Electrode {
	{ Name= "emitter"   Voltage= 0.0 Resist= 1e-3 }
	{ Name= "base"	    Voltage= 0.0 Resist= 1e-3 }
	{ Name= "collector" Voltage= 0.0 Resist= 1e-3 }
	{ Name= "substrate" Voltage= 0.0 Resist= 1e6  }
}
 
Plot{
*--Density and Currents, etc
	eDensity hDensity
	TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
	eMobility hMobility
	eVelocity hVelocity
	eQuasiFermi hQuasiFermi

*--Temperature
	* eTemperature Temperature hTemperature

*--Fields and charges
	ElectricField/Vector Potential SpaceCharge

*--Doping Profiles
	Doping DonorConcentration AcceptorConcentration

*--Generation/Recombination
	SRH * Band2Band * Auger
	* AvalancheGeneration eAvalancheGeneration hAvalancheGeneration

*--Driving forces
	eGradQuasiFermi/Vector hGradQuasiFermi/Vector
	eEparallel hEparallel eENormal hENormal

*--Band structure/Composition
	BandGap
	BandGapNarrowing
	Affinity
	ConductionBand ValenceBand
	* eQuantumPotential hQuantumPotential

*--Gate Tunneling
	* eBarrierTunneling hBarrierTunneling	BarrierTunneling
	* eDirectTunnel hDirectTunnel
}


Physics {
	EffectiveIntrinsicDensity( OldSlotboom )
	Fermi
}
Physics (Material="Silicon"){
	Mobility(
		PhuMob
		HighFieldSaturation
		Enormal
	)
	Recombination(
		SRH( DopingDependence )
		Auger
	)
}

Math {

	Extrapolate
	Notdamped=100
	Iterations=50
	ErrRef(electron)= 1e5
	ErrRef(hole)    = 1e5
	ExitOnFailure
	NumberOfThreads= 4
	RefDens_eGradQuasiFermi_ElectricField= 1e14
	RefDens_hGradQuasiFermi_ElectricField= 1e14
 
}
 

Solve {
* Initial Guess
	Coupled ( Iterations=100 LineSearchDamping= 1e-4 ) { Poisson }
	Coupled { Poisson Electron Hole }

* Initial base ramp
	set("base" mode current)
	Quasistationary (
		InitialStep= 1e-12 Increment= 1.5	  
		Minstep= 1e-15 MaxStep= 0.1
		Goal { Name= "base" Current= @Ib@ }   
	){ Coupled { Poisson Electron Hole } }

#  Voltage Sweep (0->1V) : initialstep= 0.001  Minstep= 1e-5  dV= 1e-5 V
# Current Sweep (??->1e-5 A) : initialstep= 0.001  Minstep= 1e-5 dI= 1e-10A  
# 1e-13 ....>1e-8 

	
	
* Base and Collector ramp

	NewCurrentPrefix="IcVce_"
	Quasistationary (
		InitialStep= 1.0e-3 Increment= 1.25
		Minstep= 1e-8 MaxStep= 0.03
		Goal { Name= "collector" Voltage= 3.3 }
	){ Coupled { Poisson Electron Hole }

	}
}