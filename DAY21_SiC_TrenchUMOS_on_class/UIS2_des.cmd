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
   { Name= "gate"   Temperature=!(puts $TEMPF)! surfaceresistance= 7.5e1} 
   { Name= "source" Temperature=!(puts $TEMPF)! surfaceresistance= 0.0055} 
   { Name= "drain"  Temperature=!(puts $TEMPF)! surfaceresistance= 0.0055} 
 }
 

   
	## Physics models
	Physics(material = "SiliconCarbide") {
		Fermi
		EffectiveIntrinsicDensity ( OldSlotboom NoFermi )
		Recombination (
			SRH(DopingDependence)
			Auger
			Avalanche(Okuto GradQuasiFermi )
			ConstantCarrierGeneration(value=1e10)
 
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
   Output= "@log@"
   ACExtract= "@acplot@"
}

Math {
    Extrapolate
	Notdamped= 30
	Iterations= 15
	RHSMax= 1e60
	RHSFactor= 1e60
 
	ExitOnFailure
    DirectCurrent
    Method=Blocked
	Submethod= ILS(set=21)
	ExtendedPrecision(80)
	Digits= 5
	Rhsmin= 1e-10
	#CheckRhsAfterUpdate
	ErrEff(electron)= 1e8
	ErrEff(hole)= 1e8
	RefDens_eGradQuasiFermi_Zero= 1.000e+12
	RefDens_hGradQuasiFermi_Zero= 1.000e+12
	RefDens_eGradQuasiFermi_EparallelToInterface_HFS= 1.000e+12
	RefDens_hGradQuasiFermi_EparallelToInterface_HFS= 1.000e+12
	ComputeGradQuasiFermiAtContacts= UseQuasiFermi
 
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
	NumberofThreads= 8
	Transient= BE 
}

System {
   UMOS nmos (source=s  gate=g drain=d)
   Vsource_pset vd  (nd 0) { pwl = (-100 0.0 0.0 @VddMax@) }
   Vsource_pset vs  (s 0)  { dc = 0 }
   
   Vsource_pset vg  (ng 0) { pwl = (!(puts $PULSE)!)}
   
   Inductor_pset ld (nd d) { inductance = @<Lload>@ }   
   Resistor_pset rg (ng g) { resistance = @<Rg>@ }      
   
   Resistor_pset  ri (ng 0){ resistance = 1e3 }
   Capacitor_pset ci (nd 0){ capacitance= 50e-12 }
   
   Plot (time() v(g) v(d) v(nd) v(ng) i(lc d))
   Plot "n@node@_nodeplots" (time() v(g) v(d) v(nd) v(ng) i(ld d))
}

Plot{
*--Density and Currents, etc
   eDensity hDensity
   TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
   * eMobility hMobility
   * eVelocity hVelocity
   eQuasiFermi hQuasiFermi

*--Temperature 
   Temperature
   * eTemperature hTemperature

*--Fields and charges
   ElectricField/Vector Potential SpaceCharge

*--Doping Profiles
   Doping DonorConcentration AcceptorConcentration

*--Generation/Recombination
   SRH Band2Band Auger
   AvalancheGeneration eAvalancheGeneration hAvalancheGeneration

*--Driving forces
   eGradQuasiFermi/Vector hGradQuasiFermi/Vector
   * eEparallel hEparallel eENormal hENormal

*--Band structure/Composition
   BandGap 
   * BandGapNarrowing
   * Affinity
   ConductionBand ValenceBand
   * eQuantumPotential hQuantumPotential

*--Gate Tunneling
   * eBarrierTunneling hBarrierTunneling  BarrierTunneling
   * eDirectTunnel hDirectTunnel

*-- UIS analysis   
   ConductionCurrent EffectiveIntrinsicDensity
}


CurrentPlot {
   
   EffectiveIntrinsicDensity (  
       Maximum( Material= "SiliconCarbide"  )
   )

   ConductionCurrent (
       Maximum( Material= "SiliconCarbide"  )
   )

   AvalancheGeneration ( 
       Maximum( Material= "SiliconCarbide"  )
   )
   
   

}

Solve {
*- Creating initial guess:
   Coupled(Iterations=1000) {Poisson}
    

   	# Ramp gate voltage to desired value
	Transient (
		InitialTime= -100 FinalTime= 0.0
		InitialStep= 1e-2 MaxStep= 2.0 MinStep= 1e-15
	) {
		Coupled { Poisson Electron  hole  Circuit }
	}
   
	Coupled(Iterations=1000 LineSearchDamping=1e-2) {  Poisson Electron Hole Temperature Circuit }
   
   NewCurrentPrefix="UIS_"
   Transient (
      InitialTime= 0 FinalTime= @<Tw*4.0>@ 
      Increment= 1.25 Decrement= 2.1
      InitialStep= 1e-8  MinStep= 1e-25 MaxStep= @<Tw/50>@
   ){   Coupled { Poisson Electron  hole Temperature Circuit } }
}



