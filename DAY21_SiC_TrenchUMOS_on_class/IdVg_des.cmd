#setdep @node|UMOS@
 
File {
	grid      = "n@node|UMOS@_msh.tdr"
	current   = "@plot@"	
	plot      = "@tdrdat@"
	parameter = "@parameter@"	
	
}

## Electrical contacts
Electrode {
	#if "@tool_label@" == "IV"
	{ Name="drain" 	Voltage= 0.0 }
	#elif "@tool_label@" == "CV"
	{ Name="drain" 	Voltage= (0.0 at 0.0, 100.0 at 100.0) }
	#else
	{ Name="drain" 	Voltage= 0.0 }
	#endif
	{ Name="source" Voltage= 0.0 }
	{ Name="gate"  	Voltage= 0.0 }
	
}

## Physics models
Physics(material = "SiliconCarbide") {
	Fermi
	EffectiveIntrinsicDensity ( OldSlotboom NoFermi )
	Recombination (
		SRH(DopingDependence)
		Auger
		#if "@tool_label@" == "BV"
			Avalanche(Okuto GradQuasiFermi)
			ConstantCarrierGeneration(value=1e10)
		#endif
	)  
	Mobility ( 
		HighFieldSaturation
		Enormal(Lombardi )
	)
	IncompleteIonization (  
		Split (
			Doping = "NitrogenConcentration"
			Weights = (0.5 0.5)
		)
		
		#tdr: B P N
		#par: B Al N_spilt1 N_split2 P_split1 P_split2
		#valid: B N_spilt1 N_split2
	)
  	## Anisotropic modeling
	Aniso (
		Mobility 
		#if "@tool_label@" == "BV"
			Avalanche	
		#endif
		direction(SimulationSystem) = (0,1,0)
	)
	
}

Physics {
	Fermi
	AreaFactor  = @AF@
	#if "@tool_label@" == "BV"
	Recombination (
		Avalanche(Okuto GradQuasiFermi)
	)
	#endif
}

 

## FixedCharge at SiC-Oxide Interface 
Physics(MaterialInterface= "SiliconCarbide/Oxide") {
  Traps (FixedCharge Conc=1e11
  	  Add2TotalDoping
  )
}


Math {
	Extrapolate
	Notdamped= 30
	Iterations= 15
	RHSMax= 1e60
	RHSFactor= 1e60
	
	
	ExitOnFailure
	DirectCurrent
	#if "@tool_label@" == "BV"
		method= ILS(set=21)
		ExtendedPrecision(80)
		RhsMin= 1e-20
		BreakCriteria{Current (Contact="drain" absval=1.0e-5)}	
		Digits= 6
		ErrEff(electron)= 1e5
		ErrEff(hole)= 1e5
		RefDens_eGradQuasiFermi_Zero= 1.000e+12
	    RefDens_hGradQuasiFermi_Zero= 1.000e+12
	    RefDens_eGradQuasiFermi_EparallelToInterface_HFS= 1.000e+12
	    RefDens_hGradQuasiFermi_EparallelToInterface_HFS= 1.000e+12
	    ComputeGradQuasiFermiAtContacts= UseQuasiFermi
    ## For C-V Simulations
	#elif "@tool_label@" == "CV"
		method= ILS(set=31)
		ImplicitACSystem
		ExtendedPrecision(128)
		RhsMin= 1e-20
		Digits= 5
		ErrEff(electron)= 1e8
		ErrEff(hole)= 1e8
		RefDens_eGradQuasiFermi_Zero= 1.000e+12
	    RefDens_hGradQuasiFermi_Zero= 1.000e+12
	    RefDens_eGradQuasiFermi_EparallelToInterface_HFS= 1.000e+12
	    RefDens_hGradQuasiFermi_EparallelToInterface_HFS= 1.000e+12
	#else
		ExtendedPrecision(80)
		method= ILS(set=21)
		CheckRhsAfterUpdate
		RhsMin= 1e-3
		Digits= 5
		ErrEff(electron)= 1e8
		ErrEff(hole)= 1e8
		RefDens_eGradQuasiFermi_Zero= 1.000e+12
	    RefDens_hGradQuasiFermi_Zero= 1.000e+12
	    RefDens_eGradQuasiFermi_EparallelToInterface_HFS= 1.000e+12
	    RefDens_hGradQuasiFermi_EparallelToInterface_HFS= 1.000e+12
	    ComputeGradQuasiFermiAtContacts= UseQuasiFermi
	#endif
 
	
        ILSrc= "set (21) { 
            iterative (gmres(100), tolrel=1e-10, maxit=400);
            preconditioning(ilut(1e-6,-1),left);
            ordering(symmetric=nd, nonsymmetric=mpsilst);
            options( compact=yes, linscale=2, verbose=0, refineresidual=5);
         };
         
         set (31) { 
            iterative (gmres(150), tolrel=1e-13, tolunprec=1e-11, tolabs=0, maxit=400);
            preconditioning(ilut(1e-7,-1),left);
            ordering(symmetric=nd, nonsymmetric=mpsilst);
            options( compact=yes, linscale=2, verbose=0, refineresidual=10);
         };
         "
	
	TensorGridAniso(aniso)
	NumberofThreads= 4
	Transient= BE
		
 
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
	Doping DonorConcentration DonorPlusConcentration 
	
	AcceptorConcentration AccepMinusConcentration
	
	NitrogenConcentration NitrogenActiveConcentration
	AluminumConcentration AluminumActiveConcentration
	ConductionBandEnergy ValenceBandEnergy BandGap
	
	# Traps visualization
	eTrappedCharge hTrappedCharge
	eInterfaceTrappedCharge hInterfaceTrappedCharge
	eGapStatesRecombination hGapStatesRecombination
	TotalInterfaceTrapConcentration
	#
	eMobilityAniso
	hMobilityAniso
}

Solve {
	# ----- solution at initial conditions
	Coupled(Iterations= 1000 LineSearchDamping= 1e-4 ){ Poisson }
	Coupled(Iterations= 1000){ Poisson Hole }
	Coupled(Iterations= 1000){ Poisson Electron Hole }

	# Ramp gate voltage to desired value
	Transient ( # transient ramp
		InitialTime= 0 FinalTime= 1.0
		InitialStep= 1e-2 MaxStep= 0.05 MinStep= 1e-10 # 0-1 step: percentage
		Goal {Name="drain" Voltage= @<Vd>@}
		Goal {Name="gate" Voltage=  0}
	) {
		Coupled { Poisson Electron Hole }
		Plot(FilePrefix= "n@node@_off" Time=(1.0))
	}

	# Simulate IdVg curve
	NewCurrentFile="IdVg_" 
	Transient( 
		InitialTime= 1 FinalTime= 2
		InitialStep= 1e-2 Increment= 1.5 MinStep= 1e-10 MaxStep= 0.02 
		Goal { Name="gate" Voltage= 20}
		){ 
			Coupled { Poisson Electron Hole }
		}
}



