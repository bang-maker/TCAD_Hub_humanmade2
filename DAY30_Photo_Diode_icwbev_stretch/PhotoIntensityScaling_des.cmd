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
      { Name= "substrate"   Voltage= 0    }
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



RayTraceBC {
		{ Name= "P"
			Reflectivity= 1.0
		}
		{ Name= "N"
			Reflectivity= 1.0
		}
}


Physics{

		
	Optics (
		#
		Excitation (
			Wavelength= @wavelength@		* Incident light wavelength [um]
			Intensity= @intensity@			* Incident light intensity [W/cm2]	
			Polarization= 0.5				* Unpolarized light
			Theta= 90						* Normal incidence,	in -ve y direction
			Window(
				Origin= (-40, @Ymin@)			* Shift origin 0.1 um below the bottom photodiode surface
				Line(x1= @Ymin@ x2= @Ymax@)		* Illumination window covers width of photodiode. 
				XDirection = (0 1 0)
			)			
		) * end Excitation
    	ComplexRefractiveIndex (WavelengthDep(Real Imag))
    	# Optical Generation
		OpticalGeneration (
			QuantumYield (StepFunction (EffectiveBandgap)) * number of generated carriers per photon, default: 1
			ComputeFromMonochromaticSource
			Scaling=0
		) * end OpticalGeneration
		# Excitation
		OpticalSolver (
      		RayTracing (	        		
				RayDistribution(
					Mode= AutoPopulate
					NumberOfRays= 3000				* Number of rays in the illumination window
				)
				CompactMemoryOption
				DepthLimit= 1000 					* Stop tracing a ray after passing through more than x material boundaries
				MinIntensity= 1e-5					* Stop tracing a ray when its intensity becomes less than x times the original intensity			
			) * end RayTracing
		)	* end OpticalSolver		
	) * end Optics	




}
 

CurrentPlot {
	ModelParameter= "Wavelength"
	ModelParameter= "Intensity"
	ModelParameter= "Scaling"
	OpticalGeneration(Integrate(Semiconductor) ) 
	AbsorbedPhotonDensity(Integrate(Semiconductor) ) 
	OpticalGeneration(Integrate(material="Silicon") ) 
    SRH(Integrate(Semiconductor))
    Auger(Integrate(Semiconductor))
	SRH(Average(Semiconductor))
	Auger(Average(Semiconductor))
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
  Digits=5
  RHSmin=1e-10
  Notdamped=100
  Iterations=30
  DirectCurrent
  ExitOnFailure
  
  * Please uncomment if you have 8 CPUs or more
  NumberOfThreads= 8
  Method = ParDiSo
  # ExtendedPrecision
}

Solve {
  Optics
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson  }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson electron }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson electron hole }
 

  Quasistationary( 
  	  DoZero
    InitialStep=1e-2 Increment=1.5 
    MinStep=1e-6 MaxStep=0.1 
    Goal { Name="N" Voltage= @<-1.0*Vr>@ } 
  ){ Coupled { Poisson electron hole   }
  }
   
  NewCurrentPrefix="Intensity_" 
  Quasistationary( 
    DoZero 
    InitialStep=1e-2 Increment=1.2 
    MinStep=1e-8 MaxStep=0.02
    Goal { ModelParameter= "Scaling" Value= 1 } 
  ){ Coupled { Poisson electron hole  } 
  }
}
