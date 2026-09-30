
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
		{ Name="drain" 	Voltage= 0.0  }
		{ Name="source" Voltage= 0.0  }
		{ Name="gate"  	Voltage= 0.0  }
		
	}
	## Physics models
	Physics(material = "SiliconCarbide") {
		Fermi
		EffectiveIntrinsicDensity ( OldSlotboom NoFermi )
		Recombination (
			SRH(DopingDependence)
			Auger
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
			direction(SimulationSystem) = (1,0,0)
		)
	}

	Physics {
		Fermi
		AreaFactor  = @AF@
	}
 
	## FixedCharge at SiC-Oxide Interface 
	Physics(MaterialInterface= "SiliconCarbide/Oxide") {
	  Traps (FixedCharge Conc=1e11
		  Add2TotalDoping
	  )
	}

}

File{
	Output = "@log@"
}
	


System {
   MOS MOS1 (source=0 gate=1 drain=3)
   Diode_pset d1 (3 4)
   Isource_pset i1  (3 4) { dc =-50.0 }
   Vsource_pset vsupply  (4 0) { pwl = (-1 0 0 100)}
   Isource_pset ig  (0 1) { pwl=(-1 0 1e-6 0 2e-6 100e-3) }

   Plot "n@node@_sys_des.plt" (time() v(1) v(3) v(4) i(MOS1,3))
}

Math {
    Digits= 6
	Extrapolate
	ErrEff(electron)= 1e4
	ErrEff(hole)= 1e4
	RHSmin= 1e-20
	RHSmax= 1e30
	RHSFactor= 1e30	
	Notdamped= 200
	Iterations= 35
	ExitOnFailure
	ExtendedPrecision(80)		
	TensorGridAniso(aniso)
	NumberofThreads= 4		
    
	Transient=BE

    BreakCriteria {
      voltage (contact="gate" absval=20) 
    }
    Method = Blocked
    SubMethod= ILS(set= 12)
    ILSrc= "
      set (12) {      
      iterative(gmres(150), tolrel=1e-9, tolunprec=1e-4, tolabs=0, maxit=600);
      preconditioning(ilut(1e-8,-1), left);
      ordering(symmetric=nd, nonsymmetric=mpsilst);
      options(compact=yes, linscale=0, refineresidual=5, verbose=0);
    };"  
   
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
   Coupled(Iterations=1000) {Poisson}

   set(1=0)
   Transient (
      InitialTime=-1 FinalTime=0 Increment= 2.0 Decrement= 3.0
      InitialStep=1e-8 MinStep=1e-13 MaxStep=5e-2
   ){ Coupled { Poisson Electron Hole Circuit}
   }
   
   Coupled(Iterations=1000 linesearchdamping=1e-2 ) {Poisson Electron Hole}
   
   unset(1)
   NewCurrent="QG_"
   Transient (
      InitialTime=0 FinalTime=1e-2
      InitialStep=1e-8 MinStep=1e-13 MaxStep=0.1e-7
   ){ Coupled { Poisson Electron Hole Circuit}
   }

}

 

