#define _Vgs_ 8.0

File {
   Grid       = "@tdr@"
   Parameters = "@parameter@" 
   Output     = "@log@"
   Current    = "@plot@"
   Plot       = "@tdrdat@"
}

Electrode {

{ name = "drain"	Voltage=0.0 }
{ name = "gate"  Material= "PolySi"(N)	 Voltage=0.0 }
{ name = "source"  Voltage= 0.0 }
{ name= "substrate"    Voltage= 0.0}

}

Physics (Material="Silicon") {
 
 EffectiveIntrinsicDensity(OldSlotboom)
 Recombination ( 
   SRH(DopingDependence TempDependence)
   Auger  
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
   Extrapolate
   RelErrControl
   Digits= 5
   Iterations= 20
   NotDamped= 50
   eDrForceRefDens= 1e12
   hDrForceRefDens= 1e12
   Number_Of_Threads= 8

   Method= ILS(set= 21)
   ILSrc= "
   set(21) {
   iterative (gmres(150), tolrel=1e-11, maxit=250);
   preconditioning ( ilut( 2e-5,-1), left);
   ordering (symmetric=nd, nonsymmetric=mpsilst);
   options (compact=yes, refineresidual=30 );
   };
   "
		                 
}

Solve {
Coupled(Iterations=100 LineSearchDamping=1e-4){ Poisson } 
   Coupled { Poisson Electron }
   Coupled { Poisson Electron Hole }

   Quasistationary (
		Initialstep= 0.01 Increment= 1.25
		MaxStep= 0.4 Minstep= 1.e-4
		Goal { Name= "gate" Voltage= _Vgs_}
	){ Coupled { Poisson Electron Hole } }
  
   NewCurrentPrefix= "IdVd_"
   Quasistationary (
		Initialstep= 2.5e-4 Increment= 1.25
		Minstep= 1.e-6 MaxStep= 0.05 
		Goal { Name= "drain" Voltage= @Vds@ }
	){ Coupled { Poisson Electron Hole }
	   CurrentPlot( Time= (Range= (0 1) Intervals= 50) )
	 }

}

