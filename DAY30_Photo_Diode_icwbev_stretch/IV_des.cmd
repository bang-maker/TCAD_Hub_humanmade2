File {
  Grid      = "@tdr@"
  Parameter = "@parameter@"
  Plot      = "@tdrdat@"
  Current   = "@plot@"
  Output    = "@log@"
  
}

Electrode {
	  { Name= "N"    		Voltage= 0    DistResist= 1e-3 }
	  { Name= "P"     		Voltage= 0    DistResist= 1e-3 }
      { Name= "substrate"   	Voltage= 0    }
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
  SRH Band2Band Auger
  SRHRecombination
  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
  eGradQuasiFermi/Vector hGradQuasiFermi/Vector
  eEparallel hEparallel eENormal hENormal
  BandGap 
  BandGapNarrowing
  Affinity
  ConductionBand ValenceBand
  eBarrierTunneling hBarrierTunneling  BarrierTunneling
  eTrappedCharge  hTrappedCharge
  eGapStatesRecombination hGapStatesRecombination
  eDirectTunnel hDirectTunnel
  SurfaceRecombination
  eLifeTime hLifeTime
  
}
 

Math {
  Extrapolate
  Derivatives
  RelErrControl
  Digits=7
  RHSmin=1e-10
  Notdamped=100
  Iterations=30
  DirectCurrent
  ExitOnFailure
  
  * Please uncomment if you have 8 CPUs or more
  NumberOfThreads= 8
  Method = ParDiSo
  ExtendedPrecision
}

Solve {
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson  }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson electron }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson electron hole }
  Save ( FilePrefix="n@node@_init" )

  Quasistationary( 
  	  DoZero
    InitialStep=1e-2 Increment=1.5 
    MinStep=1e-6 MaxStep=0.1 
    Goal { Name="N" Voltage= 6 } 
  ){ Coupled { Poisson electron hole   }
  	  Plot(FilePrefix = "n@node@_Reverse_" time=(1))
  }
   
  NewCurrentPrefix="IV_" 
  Quasistationary( 
    DoZero 
    InitialStep=1e-2 Increment=1.2 
    MinStep=1e-8 MaxStep=0.02
    Goal { Name="N" Voltage= -3 } 
  ){ Coupled { Poisson electron hole  }
  Plot(FilePrefix = "n@node@_Forward_" time=(1)) 
  }
}
