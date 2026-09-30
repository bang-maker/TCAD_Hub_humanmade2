File {
  Grid      = "@tdr@"
  Parameter = "@parameter@"
  Plot      = "@tdrdat@"
  Current   = "@plot@"
  Output    = "@log@"
  
}

Electrode {
	  { Name= "P"    		Voltage= 0    }
	  { Name= "N"     		Voltage= 0    }
	  #{ Name= "substrate"   Voltage= 0   }
}

Physics {
	Fermi
	
}

Physics (material= "Silicon"){

	Mobility ( 
		# ConstantMobility
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
#if "@tool_label@"=="BV"
  	    Avalanche
		#set BV x  	    
#endif
  	    Band2Band
  	    Auger
  	)
    EffectiveIntrinsicDensity (
    	BandGapNarrowing(OldSlotboom)
    )  
 
}

 
 
Physics (MaterialInterface="Silicon/Oxide") { Recombination(surfaceSRH) }



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
  Digits=9
  RHSmin=1e-10
  Notdamped=100
  Iterations=30
  DirectCurrent
  ExitOnFailure
  
  * Please uncomment if you have 8 CPUs or more
  NumberOfThreads= 16
  Method = ILS
  ExtendedPrecision
}

Solve {
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson  }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson electron }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson electron hole }
  Save ( FilePrefix="n@node@_init" )
  #-- Ramp P to init voltage 
  Quasistationary( 
  	  DoZero
    InitialStep=1e-2 Increment=1.5 
    MinStep=1e-6 MaxStep=0.1 
    Goal { Name="P" Voltage=-6 } 
  ){ Coupled { Poisson electron hole   }
  Plot(FilePrefix = "n@node@_Reverse_" time=(1))
  }
   
  NewCurrentPrefix="IV_" 
  Quasistationary( 
    DoZero 
    InitialStep=1e-2 Increment=1.2 
    MinStep=1e-8 MaxStep=0.05
    Goal { Name="P" Voltage= 6} 
  ){ Coupled { Poisson electron hole  }
   CurrentPlot(time=(range=(0 1) intervals= 120))
   }
}
