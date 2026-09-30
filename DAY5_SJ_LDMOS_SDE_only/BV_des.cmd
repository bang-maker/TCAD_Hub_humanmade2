
File {
   Grid = "@tdr@"
   Parameters= "@parameter@"
   Plot = "@tdrdat@"
   Current="@plot@"
   Save = "@save@"
}

Electrode {
	{ name = "drain"		Voltage= 0.0 	Resist= 1.5e12}
	{ name = "gate"  		Material= "PolySi"(N) Voltage= 0.0 }
	{ name = "source"  		Voltage= 0.0 }
	{ name= "substrate"    Voltage= 0.0}
}

Physics (Material="Silicon") {
 
 EffectiveIntrinsicDensity(OldSlotboom)
 Recombination ( 
   SRH(DopingDependence TempDependence)
   Auger  
   Avalanche
   )
  		 
 Mobility (
   DopingDependence
   Enormal 
   HighFieldSaturation
   )
}

Plot {
	 Doping
	 eCurrent/Vector hCurrent/Vector TotalCurrent
	 eDensity hDensity
	 ElectricField/Vector
	 SpaceCharge DonorConcentration AcceptorConcentration
	 emobility  hmobility
	 SRH Auger Avalanche
	 eAvalanche hAvalanche
	 eVelocity hVelocity
}

Math {
		AvalDensGradQF
  		Extrapolate
  		RelErrControl
  		Digits= 5
  		RHSmin= 1e-10
		eDrForceRefDens= 1e14
		hDrForceRefDens= 1e14
  		NotDamped= 100
  		Iterations= 25
		
  		Method= ILS(set= 21)
  		ILSrc= "
  		set(21) {
  		iterative (gmres(150), tolrel=1e-11, maxit=250);
  		preconditioning ( ilut( 2e-5,-1), left);
  		ordering (symmetric=nd, nonsymmetric=mpsilst);
  		options (compact=yes, refineresidual=30 );
  		};
  		"
		Number_Of_Threads= 8                
	
             
}

Solve {
Coupled(Iterations=100 LineSearchDamping=1e-4){ Poisson } 
   Coupled { Poisson Electron Hole }
   
   NewCurrentPrefix= "BV_"
   QuasiStationary (
             InitialStep=1e-4 Increment= 1.2
             MaxStep=0.1 MinStep=1e-12 
             Goal {Name= "drain" Voltage= @Vdsmax@ }
             BreakCriteria {Current (Contact="drain" Absval= 1.0e-9 ) }
        ){ Coupled { Poisson Electron Hole } 
           CurrentPlot ( Time= ( Range= (0.00 @<Vd1/Vdsmax>@) ;
            Range= (@<Vd1/Vdsmax>@  @<Vd2/Vdsmax>@) intervals= 100;
            Range= (@<Vd2/Vdsmax>@  1.0) intervals=30 ) )
        }

}

