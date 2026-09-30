############################################################################
#    
# UIS Curve Simulation
#
############################################################################

#-- TCL Script for variables
!( 
 
   set PULSE  "0 0 1.0e-8 @VgMax@ [expr @Tw@+1.0e-8] @VgMax@ [expr @Tw@+2.0e-8] 0 1 0"
   set RESIST "[expr 2.1*1e-3*@AF@]"
   set TEMPF  "[expr 25+275]"
)!
                                                 
Device UMOS {
 File {
   Grid=   "@tdr@"
   Parameters= "@parameter@"
   Plot=   "@tdrdat@"
   Current="@plot@"
 }

 Electrode {
   { Name= "gate"   Voltage= 0 }
   { Name= "source" Voltage= 0 }
   { Name= "drain"  Voltage= 0 Resist=!(puts $RESIST)! }
 }

 Thermode {
   { Name= "gate"   Temperature=!(puts $TEMPF)! surfaceresistance= 7.5e4} 
   { Name= "source" Temperature=!(puts $TEMPF)! surfaceresistance= 5.5} 
   { Name= "drain"  Temperature=!(puts $TEMPF)! surfaceresistance= 5.5} 
 }
 

   
	## Physics models
	Physics(material = "SiliconCarbide") {
		Fermi
		EffectiveIntrinsicDensity ( OldSlotboom NoFermi )
		Recombination (
			SRH(DopingDependence)
			Auger
			#if "@tool_label@" == "BV"
				Avalanche(Okuto GradQuasiFermi )
				ConstantCarrierGeneration(value=1e10)
			#endif
		)  
		Mobility ( 
			HighFieldSaturation
			Enormal(Lombardi)
		)
		IncompleteIonization (
			Split (
				Doping = "NitrogenConcentration"
				Weights = (0.5 0.5)
			)		
		)
		## Anisotropic modeling
		Aniso (
			Mobility 
			Avalanche	
			direction(SimulationSystem) = (0,1,0)
		)
		
	}
	
	
	Physics {
		Fermi
		AreaFactor  = @AF@
		Temperature=!(puts $TEMPF)!
		Thermodynamic  
	}
	
	## FixedCharge at SiC-Oxide Interface 
	Physics(MaterialInterface= "SiliconCarbide/Oxide") {
	  Traps (FixedCharge Conc=1e11
		  Add2TotalDoping
	  )
	}
}

File {
   Output  = "@log@"	
}

Plot {
	Potential SpaceCharge
	eDensity hDensity
	eCurrent hCurrent TotalCurrent/vector CurrentPotential
	ElectricField/vector
	eQuasiFermi hQuasiFermi
	egradQuasiFermi hgradQuasiFermi
	SRH Auger
	AvalancheGeneration eAvalanche hAvalanche
	eMobility hMobility
	eMobilityAniso hMobilityAniso
	eMobilityAnisoFactor hMobilityAnisoFactor
	DielectricConstant DielectricConstantAniso
	Doping DonorConcentration DonorPlusConcentration AcceptorConcentration AccepMinusConcentration
	NitrogenConcentration NitrogenActiveConcentration
	NitrogenConcentration_split1 NitrogenActiveConcentration_split1 NitrogenPlusConcentration_split1
	NitrogenConcentration_split2 NitrogenActiveConcentration_split2 NitrogenPlusConcentration_split2
	AluminumConcentration AluminumActiveConcentration
	ConductionBandEnergy ValenceBandEnergy BandGap
	
	# Traps visualization
	eTrappedCharge hTrappedCharge
	eInterfaceTrappedCharge hInterfaceTrappedCharge
	eGapStatesRecombination hGapStatesRecombination
	TotalInterfaceTrapConcentration
}

Math {	
	Digits= 6
	Rhsmin= 1e-3
	CheckRhsAfterUpdate
	
	* Extrapolate
	ErrEff(electron)= 1e-2
	ErrEff(hole)= 1e-2
	
	RHSmax= 1e30
	RHSFactor= 1e30	
	Notdamped= 20
	Iterations= 21
	
	ExitOnFailure
	ExtendedPrecision(80)		
	TensorGridAniso(aniso)
	NumberofThreads= 4
	CdensityMin= 0.0
	Method= Blocked
	SubMethod= ILS(set= 12)
    ILSrc= "
      set (12) {      
      iterative(gmres(150), tolrel=1e-9, tolunprec=1e-4, tolabs=0, maxit=600);
      preconditioning(ilut(1e-8,-1), left);
      ordering(symmetric=nd, nonsymmetric=mpsilst);
      options(compact=yes, linscale=0, refineresidual=5, verbose=0);
    };"  
	
    Transient= BE
   	## When the lattice temperature exceeds 2000 K , abort the simulation
	BreakCriteria {  
	LatticeTemperature ( maxval = 3887 ) }		 
}

System {
    UMOS MOS1 (source=0 gate=2 drain=3)
    Vsource_pset vc  (4 0) { dc = 0 }
	Vsource_pset vg  (5 0) { pwl = (0 0 1e-8 @VgMax@ @<PWidth+1.0e-8>@ @VgMax@ @<PWidth+2.0e-8>@ 0 1 0) }
	
	Inductor_pset lc (4 3) { inductance= @<L*1.0e-6>@ }
	Resistor_pset rg (5 2) { resistance= 2.0 }
	
	Resistor_pset ri (5 0) { resistance= 1e3 }
	Capacitor_pset c1 (4 0) { capacitance= 50e-12 }
	
	
	Plot "n@node@_nodeplots" (time() v(2) v(3) v(4) v(5) i(lc 3))
}


Solve {
    Coupled (Iterations=1000){ Poisson }
    Coupled (Iterations=1000){ Poisson Electron }
    Coupled (Iterations=1000){ Poisson Electron Hole }
	
	Quasistationary (
	InitialStep= 1e-5 Increment= 1.5 Decrement= 3.0
	MinStep=1e-10 MaxStep=0.5
	Goal { Parameter= vc.dc  Value= 600 }
	){ Coupled { Poisson Electron Hole Circuit Contact Temperature } }
	
	* Coupled (LineSearchDamping= 1e-3 Iterations=1000){ Poisson Electron Hole   Temperature}
	
	NewCurrentPrefix="Transient_BE_"
	Transient (
		
	
	InitialTime=0 FinalTime=@<PWidth*4.0>@ 
	Increment= 1.3 Decrement= 2.0
	InitialStep=1e-8  MinStep= 1e-25 MaxStep= @<PWidth/20>@
	){ Coupled { Poisson Electron Hole Circuit Contact   Temperature} }
 	
}




