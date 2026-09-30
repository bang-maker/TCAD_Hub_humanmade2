
#setdep @node|UMOS@

 
Device UMOS{

	File {
		Grid=   "@tdr@"
		Parameters= "@parameter@"
		Plot=   "@tdrdat@"
		Current="@plot@"
	}
	
	Electrode {
		{ Name= "gate"   Voltage= 0 }
		{ Name= "source" Voltage= 0 }
		{ Name= "drain"  Voltage= 0 }
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
	Rhsmin= 1e-3
	CheckRhsAfterUpdate
	
	ErrEff(electron)= 1e5
	ErrEff(hole)= 1e5
	
	RHSmax= 1e30
	RHSFactor= 1e30	
	Notdamped= 20
	Iterations= 18
	
	ExitOnFailure
	ExtendedPrecision(80)		
	TensorGridAniso(aniso)
	NumberofThreads= 4
	Method= Blocked
	SubMethod= ILS(set= 12)
    ILSrc= "
      set (12) {      
      iterative(gmres(150), tolrel=1e-9, tolunprec=1e-6, tolabs=0, maxit=300);
      preconditioning(ilut(1e-6,-1), left);
      ordering(symmetric=nd, nonsymmetric=mpsilst);
      options(compact=yes, linscale=0, refineresidual=10, verbose=0);
    };"  
	
    Transient= BE
	
}

#define tdi 3e-7
#define tr 10e-09
#define tf 10e-09
#define tfirst @<Ldsw*Idc/Vdc>@

System {
   #UMOS MOS1 (source=2 gate=2 drain=3){
   #File{
   #     Current    = "n@node@_mos1_des.plt" 
   #    }}
   Diode_pset d1 (2 3)
   UMOS MOS2 (source=0 gate=1 drain=2){
   File{
        Current    = "n@node@_mos2_des.plt" 
       }}
          
   Inductor_pset Ll  (2 3) {inductance= @Ldsw@ }
   
   Vsource_pset Vdd (3 0) { pwl = (-10.0 0.0 -1.0 @Vdc@ ) }
   Vsource_pset vg  (11 0) { pwl = (
   		   0    				    			0.0 
   		   @<tdi>@				    			0.0
   		   @<tdi+tr>@							@VgMax@
   		   @<tdi+tr+tfirst>@        			@VgMax@
   		   @<tdi+tr+tfirst+tf>@     			0.0
   		   @<tdi+tr+(1.5*tfirst)+tf>@     		0.0
   		   @<tdi+(2*tr)+(1.5*tfirst)+tf>@     	@VgMax@
   		   @<tdi+(2*tr)+(2.0*tfirst)+tf>@     	@VgMax@
   		   @<tdi+(2*tr)+(2.0*tfirst)+(2*tf)>@   0.0
   		   @<tdi+(2*tr)+(4.0*tfirst)+(2*tf)>@   0.0
   			)}
   			
   Resistor_pset rg (11 1) {resistance= @Rgsw@}

   Plot "n@node@_sys_des.plt" (time() v(11) v(2) i(MOS1,4) 
   		i(MOS1,3) i(MOS2,2) i(MOS2,1) i(Ll,3) i(Ll,4))
}

Solve {

	Coupled (Iterations=1000){ Poisson }
	Transient (
		InitialTime= -10 FinalTime= 0.0
		InitialStep= 1e-2 MaxStep= 2.0 MinStep= 1e-15
	) {
		Coupled { Poisson Electron  Hole  Circuit }
	}
	
	Coupled(Iterations=1000 linesearchdamping=1e-2){Poisson Electron  Hole  Circuit}
	
	NewCurrentPrefix="SW_" 
	Transient (
	  InitialTime=0.0 FinalTime= @<tdi+(2*tr)+(4.0*tfirst)+(2*tf)>@
	  InitialStep= 1e-9 Increment=1.2 Decrement=2.0
	  MinStep= 1e-15 MaxStep= @<tfirst/10.0>@
	){ Coupled { Poisson Electron Hole Circuit }
	}

}

