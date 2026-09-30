
#setdep @node|UMOS@

Device MOS{
	File {
		grid      = "n@node|UMOS@_msh.tdr"
		current   = "@plot@"	
		plot      = "@tdrdat@"
		parameter = "@parameter@"	
		#NewtonPlot = "n@node@_newtonplot.tdr"
		
	}
	
	## Electrical contacts
	Electrode {
		#if "@tool_label@" == "BV"
		{ Name="drain" 	Voltage= 0.0  }
		#elif "@tool_label@" == "CV"
		{ Name="drain" 	Voltage= (0.0 at 0.0, 100.0 at 100.0) }
		#else
		{ Name="drain" 	Voltage= 0.0 }
		#endif
		{ Name="source" Voltage= 0.0 }
		{ Name="gate"  	Voltage= 0.0  }
		
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
			#if "@tool_label@" == "BV"
				Avalanche	
			#endif
			direction(SimulationSystem) = (1,0,0)
		)
		
	}
	
	
	Physics {
		Fermi
		AreaFactor  = @AF@
	}
	
	
	#if "@type@" == "HJ-DTMOS" 
	Physics (MaterialInterface= "SiliconCarbide/PolySi") {
		Thermionic
		HeteroInterface
	}
	Physics (Material= "PolySi") {
		Recombination (
			Avalanche(Okuto GradQuasiFermi)
		) 
	}
	#endif 
	
	## FixedCharge at SiC-Oxide Interface 
	Physics(MaterialInterface= "SiliconCarbide/Oxide") {
	  Traps (FixedCharge Conc=1e11
		  Add2TotalDoping
	  )
	}

}

File{
	Output = "@log@"
	SpicePath = "@pwd@/models"
}
	


System {

		Vsource_pset Vdd (l1 0) { pwl = (0 0 10e-6 800 ) }
		Inductor_pset L1 (l1 l2) {inductance = 10e-9}
		Inductor_pset L2 (l2 l3) {inductance = 20e-6}
		MOS mos ("source"= l3 "drain"= l2 "gate" = l3)
		Switch_my_pset Sw ("S+" = l3 "S-" = 0 "SC+" = vc "SC-" = 0)  
		Vsource_pset Vc (vc 0) { pwl = (0 2 149.9e-6 2 150e-6 -2 ) }
		Plot "n@node@_sys_des.plt" (time() v(vc) v(l1) v(l2) v(l3) i(mos,l3) i(mos,l2) i(L1,l1) i(L2,l2))	
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
		ErrEff(electron)= 1e8
		ErrEff(hole)= 1e8
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
		Digits= 8
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
	Doping DonorConcentration DonorPlusConcentration AcceptorConcentration AccepMinusConcentration
	NitrogenConcentration NitrogenActiveConcentration
	AluminumConcentration AluminumActiveConcentration
	ConductionBandEnergy ValenceBandEnergy BandGap
	
	# Traps visualization
	eTrappedCharge hTrappedCharge
	eInterfaceTrappedCharge hInterfaceTrappedCharge
	eGapStatesRecombination hGapStatesRecombination
	TotalInterfaceTrapConcentration
}

Solve {
	# ----- solution at initial conditions
	Coupled(Iterations= 1000 LineSearchDamping= 1e-4 ){ Poisson }
	#Coupled(Iterations= 1000 LineSearchDamping= 1e-1 ){ Poisson Electron    }
	##Coupled(Iterations= 1000 LineSearchDamping= 1e-1 ){ Poisson Electron hole  }

	# Ramp gate voltage to desired value
	NewCurrentFile="Boot_" 
	Transient (
		InitialTime= 0 FinalTime = 100e-6
		InitialStep= 1e-8 MaxStep= 5e-6 MinStep= 1e-15
	) {
		Coupled { Poisson Electron  hole Circuit }
	}

	# Simulate BV curve
	NewCurrentFile="RR_" 
    Transient (
		InitialTime = 100e-6
		FinalTime = 1000e-6
		InitialStep= 1e-8
		MaxStep= 2e-6
		MinStep= 1e-15 
	)
    { coupled { poisson electron  hole Circuit }
    plot(FilePrefix = "RR_2us_n@node@_" time=(2e-6))
    plot(FilePrefix = "RR_I50A_n@node@_" 
    	#when(contact = mos.drain current=@<100.0e-3*(Xmax-Xmin)*AF*1e-8>@)
    	when(contact = mos.drain current=-50)
    )
    }	 
}

 

