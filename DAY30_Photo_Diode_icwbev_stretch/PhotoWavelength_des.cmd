 
File {
   * input files:
   Grid=    "@tdr@"
   Parameter="@parameter@"
   
   * output files:
   Plot=   "@tdrdat@"
   Current="@plot@"
   Output= "@log@"
}

	RayTraceBC {
		{ Name= "N"
			Reflectivity= 1.0
		}
		{ Name= "P"
			Reflectivity= 1.0
		}
 
	}


	Electrode {
	  { Name= "N"    		Voltage= 0   DistResist=1e-3}
	  { Name= "P"     		Voltage= 0   DistResist=1e-3}
	  { Name= "substrate" 	    Voltage=0   }
	}
	
	Physics {
		Fermi
		Areafactor = @W@
 
	
	Mobility ( 
		DopingDependence
			HighFieldSaturation
		)	
		#Thermionic
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
		EffectiveIntrinsicDensity(OldSlotboom) 	  
		
		
	Optics (
    	ComplexRefractiveIndex (WavelengthDep(Real Imag))
		OpticalGeneration (
			QuantumYield (StepFunction (EffectiveBandgap)) * number of generated carriers per photon, default: 1
			ComputeFromMonochromaticSource
		) * end OpticalGeneration
		Excitation (
			Wavelength= 0.3					* Incident light wavelength [um]
			Intensity= @intensity@	 		* Incident light intensity [W/cm2]	
			Polarization= 0.5				* Unpolarized light
			Theta= 90						* Normal incidence,	in -ve y direction
			Window(
				Origin= (-20, @Ymin@)			* Shift origin 0.1 um below the bottom photodiode surface
				Line(x1= @Ymin@ x2= @Ymax@)		* Illumination window covers width of photodiode. 
				XDirection = (0 1 0) 
			)			
		) * end Excitation
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

 
  

 
Plot{
  *- Doping and mole fraction profiles	
	Doping DonorConcentration AcceptorConcentration	
	xMoleFraction
*- Band structure
	BandGap BandGapNarrowing ElectronAffinity
	ConductionBandEnergy ValenceBandEnergy
	eQuasiFermiEnergy hQuasiFermiEnergy		
*- Carrier Densities:
  	eDensity hDensity
	EffectiveIntrinsicDensity IntrinsicDensity
	eEquilibriumDensity hEquilibriumDensity
*- Fields, Potentials and Charge distributions
	ElectricField/Vector
	Potential
	SpaceCharge	
*- Currents	
	Current/Vector eCurrent/Vector  hCurrent/Vector
  	CurrentPotential	* for visualizing current lines
  	eMobility hMobility
	eVelocity hVelocity
*- Generation/Recombination	
  	SRHRecombination AugerRecombination TotalRecombination SurfaceRecombination Band2Band RadiativeRecombination
  	eLifeTime hLifeTime
 	
*- Optical Generation	
    ComplexRefractiveIndex QuantumYield
	OpticalIntensity AbsorbedPhotonDensity OpticalGeneration
* Visualizing raytracing. Can be time consuming to plot.  
* RayTree cannot be  plotted if CompactMemoryOption is specified in Physics section. 	
*  	RayTrees
 
}



Math {
	Extrapolate
	RelErrcontrol
	Digits= 5
	Notdamped= 50
	Iterations= 30
	ElementEdgeCurrent
	ErrRef(electron)= 1e3
	ErrRef(hole)= 1e3	 
	Method = ILS
	ExitOnFailure
}
 
 
 
CurrentPlot {
	ModelParameter= "Wavelength"	
	OpticalGeneration(Integrate(Semiconductor) ) 
	AbsorbedPhotonDensity(Integrate(Semiconductor) ) 
	 OpticalGeneration(Integrate(material="Silicon") ) 
    SRH(Integrate(Semiconductor))
    Auger(Integrate(Semiconductor))
	SRH(Average(Semiconductor))
	Auger(Average(Semiconductor))
}
 
Solve {
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson  }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson electron  }
  Coupled ( Iterations=100 LineSearchDamping=1e-8 ) { Poisson electron hole  }
    Quasistationary( 
   	  DoZero
      InitialStep= 1e-2 Increment= 1.35 
      MinStep= 1e-5 MaxStep= 0.1
      Goal { Name= "N" Voltage= @<-1*Vr>@ } 
    ){Coupled {Poisson Electron Hole }}
 
 
  NewCurrentPrefix = "PhotoWavelength_"
     Quasistationary( 
   	  DoZero
      InitialStep= 1e-2 Increment= 1.35 
      MinStep= 1e-5 MaxStep= 0.02
      Goal { ModelParameter= "Wavelength" Value= 1.0 } 
    ){Coupled {Poisson Electron Hole }
    
    }

}

 
