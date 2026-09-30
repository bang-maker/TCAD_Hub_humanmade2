
File {
   * input files:
   Grid=    "@tdr@"
   Piezo=   "@tdr@"
   Parameter="@parameter@"
   
   * output files:
   Plot=   "@tdrdat@"
   Current="@plot@"
   Output= "@log@"
}


Electrode {
	  { Name= "P"    		Voltage= 0   }
	  { Name= "N"     		Voltage= 0  Resistor= 1e10 }
      { Name= "substrate" 	Voltage=0.0  }
}

Physics {
	Fermi
	Areafactor = @W@
}

Physics (material= "Silicon"){
	Mobility ( 
		DopingDependence
		HighFieldSaturation
		Enormal
	)
      Recombination( 
  		SRH (DopingDependence
			ElectricField (
				Lifetime = Hurkx
				DensityCorrection = Local
			)
  		)
  	    Band2Band
  	    Avalanche
  	    Auger
  	)
    EffectiveIntrinsicDensity (
    	BandGapNarrowing(OldSlotboom)
    )  
 
}
 
Plot{
  eDensity hDensity
  TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
  eMobility hMobility
  eVelocity hVelocity
  eQuasiFermi hQuasiFermi
  eTemperature Temperature * hTemperature
  ElectricField/Vector Potential SpaceCharge
  Doping DonorConcentration AcceptorConcentration
  SRH Band2Band * Auger
  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
  eGradQuasiFermi/Vector hGradQuasiFermi/Vector
  eEparallel hEparallel eENormal hENormal
  BandGap 
  BandGapNarrowing
  Affinity
  ConductionBand ValenceBand
  eBarrierTunneling hBarrierTunneling * BarrierTunneling
  eTrappedCharge  hTrappedCharge
  eGapStatesRecombination hGapStatesRecombination
  eDirectTunnel hDirectTunnel
  
}


Math {
  Extrapolate
  Derivatives
  RelErrControl
  Digits=7
  RHSmin=1e-12
  Notdamped=100
  Iterations=30
  DirectCurrent
  ExitOnFailure
  
  * Please uncomment if you have 8 CPUs or more
  NumberOfThreads= 4
  Method = Pardiso 
  ExtendedPrecision 
}




 

Solve {
  
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson Electron  }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson Electron Hole  }
 
  
  NewCurrentFile="BV_"
  QuasiStationary ( 
    InitialStep=1e-6 Maxstep=0.01 MinStep=1e-15 Increment=1.41 
    Goal { name="N" Voltage= 1e3 }
  ) { Coupled { Poisson electron hole } }
  
  
}
