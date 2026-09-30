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

#RayTrace  TMM FDTD(EMW) OptBM 

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
	
		Excitation (
			# Monochromatic
			Wavelength= @wavelength@  * Incident light wavelength [um]
			Intensity= @intensity@ 	  * Incident light intensity [W/cm2]
			Polarization= 0.5				* Unpolarized light
			# incident direction
			Theta= 90.0               * x-axis 
			# incident domain
			Window(
				# local coordiate system 
				Origin= (-40, @Ymin@) 
				XDirection= ( 0 1 0)
				Line(x1= 0 x2= @<Ymax-Ymin>@)
			)
			
		)
		# light ---> distribution (n k ) -->  Optical Generation (Step Function)
		
		ComplexRefractiveIndex (
			WavelengthDep(Real Imag)
			#TemperatureDep()
			#CarrierDep(Real Imag)
			#GainDep( )
		)
		
	    OpticalGeneration (
	    	 QuantumYield( StepFunction(EffectiveBandgap)) # bandgap narrowing effect
	    	 ComputeFromMonochromaticSource
	    	 # ComputeFromSpectrum
	    )
	    
	    OpticalSolver( 
	    	RayTracing (	        		
				RayDistribution(
					Mode= AutoPopulate	            * Equidistant (dx dy)  MonteCarlo AutoPopulate
					NumberOfRays= 3000					* Number of rays in the illumination window
				)
				CompactMemoryOption
				DepthLimit= 1000 					* Stop tracing a ray after passing through more than x material boundaries
				MinIntensity= 1e-5					* Stop tracing a ray when its intensity becomes less than x times the original intensity			
			) * end RayTracing
	    )
	)
 

}
 

Plot{
     *- Carrier Densities:
  eDensity hDensity
  # EffectiveIntrinsicDensity IntrinsicDensity
  # eEquilibriumDensity hEquilibriumDensity
  *- Currents and current components:
  Current/Vector eCurrent/Vector hCurrent/Vector
  # ConductionCurrent/Vector DisplacementCurrent/Vector
  eMobility hMobility
  eVelocity hVelocity
  *- Fields, Potentials and Charge distributions
  ElectricField/Vector
  Potential
  eQuasiFermi hQuasiFermi
  SpaceCharge
  *- Driving forces
  eGradQuasiFermi/Vector hGradQuasiFermi/Vector
  eEparallel hEparallel 
  eENormal hENormal
  # eEffectiveField hEffectiveField
  *- Temperatures
  LatticeTemperature
  eTemperature hTemperature
  *- Generation/Recombination
  SRHRecombination Band2BandGeneration AugerRecombination RadiativeRecombination
  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
  TotalRecombination
  eLifeTime hLifeTime
  SurfaceRecombination
  # CDL CDL1 CDL2 CDL3
  # eCDL1lifetime eCDL2lifetime hCDL1lifetime hCDL2lifetime
  # SurfaceMultRecombination
  *- Doping Profiles
  Doping 
  DonorConcentration AcceptorConcentration
  # AntimonyConcentration ArsenicConcentration BoronConcentration 
  # IndiumConcentration NitrogenConcentration PhosphorusConcentration
  # NDopantConcentration PDopantConcentration
  *- Incomplete ionization
  # AsPlus PhPlus SbPlus NitrogenPlus
  # BMinus InMinus 
  # NDopantPlus PDopantMinus 

  *- Band structure
  BandGap 
  BandGapNarrowing
  ElectronAffinity
  ConductionBandEnergy ValenceBand
  eQuantumPotential hQuantumPotential
  *- Composition
  # xMoleFraction yMoleFraction
  *- Traps
  # eTrappedCharge hTrappedCharge
  # eGapStatesRecombination hGapStatesRecombination
  *- Optical Generation
  ComplexRefractiveIndex AbsorbedPhotonDensity OpticalGeneration
  OpticalAbsorptionHeat QuantumYield
  *- Generation due to Ion Strikes
  # AlphaCharge HeavyIonChargeDensity
  *- Gate Tunneling/Hot carrier injection
  # FowlerNordheim 
  # HotElectronInjection HotHoleInjection
  *- Tunneling
  # BarrierTunneling eBarrierTunneling hBarrierTunneling
  # eDirectTunnelCurrent hDirectTunnelCurrent
  *- Ionization Integrals
  # MeanIonIntegral eIonIntegral hIonIntegral 
  *- Heat flow
  # TotalHeat eJouleHeat hJouleHeat
  # PeltierHeat ThomsonHeat RecombinationHeat
  # ThermalConductivity 
  *- Stress-Tensor
  # Stressxx Stressxy Stressxz Stressyy Stressyz Stresszz
  *- Ferro-electrical Polarization
  # Polarization/Vector
  *- Piezo
  # PiezoCharge ConversePiezoelectricField
  # ConversePiezoelectricFieldXX ConversePiezoelectricFieldXY ConversePiezoelectricFieldXZ
  # ConversePiezoelectricFieldYY ConversePiezoelectricFieldYZ ConversePiezoelectricFieldZZ

  
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
    Goal { Name="N" Voltage= 6 } 
  ){ Coupled { Poisson electron hole   }
  	  Plot(FilePrefix = "n@node@_Reverse" time=(1))
  }
   
  NewCurrentPrefix="IV_" 
  Quasistationary( 
    DoZero 
    InitialStep=1e-2 Increment=1.2 
    MinStep=1e-8 MaxStep=0.02
    Goal { Name="N" Voltage= -3 } 
  ){ Coupled { Poisson electron hole  }
  Plot(FilePrefix = "n@node@_Forward" time=(1)) 
  }
}
