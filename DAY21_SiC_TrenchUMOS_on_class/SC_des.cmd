## Tool: Sentaurus Device 
## Characteristics: Short circuit withstand capability
## Dependency: Should be run after the process simulation of NMOS device
#setdep @node|UMOS@
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
	   { Name= "gate"   Temperature=!(puts $TEMPF)! surfaceresistance= 7.5e2} 
	   { Name= "source" Temperature=!(puts $TEMPF)! surfaceresistance= 0.055} 
	   { Name= "drain"  Temperature=!(puts $TEMPF)! surfaceresistance= 0.055} 
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
			Avalanche	
			direction(SimulationSystem) = (0,1,0)
		)
		
	}
	
	
	Physics {
		Fermi
		AreaFactor  = @AF@
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

Math {	
	Digits= 5
	Extrapolate
	ErrEff(electron)= 1e8
	ErrEff(hole)= 1e8
	RHSmin= 1e-15
	RHSmax= 1e30
	RHSFactor= 1e30	
	Notdamped= 20
	Iterations= 15
	ExitOnFailure
	ExtendedPrecision(80)		
	TensorGridAniso(aniso)
	NumberofThreads= 4
	CdensityMin= 1e-20
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
	BreakCriteria { # Current ( Contact="drain" maxval = 1e-3 )
		# Voltage ( Contact="drain" absval = 60 )
	LatticeTemperature ( maxval = 1200 ) }		# 1687
}

System {
   UMOS MOS1 (source=20 gate=1 drain=2){
   File{
        Current    = "n@node@_mos1_des.plt" 
       }}
   Inductor_pset Ld  (2 3) {inductance= 10e-9 }
   Resistor_pset Rd  (3 4) {resistance= 0.01}
   
   Inductor_pset Ls  (20 21) {inductance= 10e-9 }
   Resistor_pset Rs  (21 0) {resistance= 0.01 }
   
   Vsource_pset Vcc  (4 0) { pwl = ( -10 0.0 0.0 @Vx1@) }
   Vsource_pset vg  (11 0) { pwl = 
   			(0 0 1e-8 @VgMax@ @<tw+1e-8>@ @VgMax@ @<tw+2e-8>@ 0)}
   			 
   Resistor_pset rg (11 1) {resistance= 1.0}

}

Solve {
   ## Initial solution   
   Coupled (Iterations=1000){ Poisson }
   #Coupled (Iterations=1000){ Poisson Electron Hole }


	Transient (
		InitialTime= -10 FinalTime= 0.0
		InitialStep= 1e-2 MaxStep= 2.0 MinStep= 1e-15
	) {
		Coupled { Poisson Electron  hole  Circuit }
	}
   
   Coupled(Iterations=1000 LineSearchDamping=1e-2) {  Poisson Electron Hole Temperature }
	
   NewCurrentFile="SC_" 
   Transient (
      InitialTime=0 FinalTime= @<tw*4.0>@
      InitialStep=1e-12 Increment=1.3 Decrement= 1.5
      MinStep=1e-14 MaxStep=1e-7
      BreakCriteria { LatticeTemperature (maxval = 1850.0)}
   ){ Coupled { Poisson Electron Hole Temperature Circuit}
   }

}

