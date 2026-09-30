
Electrode {
   { name= "drain"     Voltage= 0.0}
   { name= "gate"      Material= "PolySi"(N) Voltage= 0.0}
   { name= "source"    Voltage= 0.0}
   { name= "substrate"    Voltage= 0.0}
   
}

File {
   Grid       = "@tdr@"
   Parameters = "@parameter@" 
   Output     = "@log@"
   Current    = "@plot@"
   Plot       = "@tdrdat@"
}

Physics (Material="Silicon") {
    EffectiveIntrinsicDensity( OldSlotboom )     
    Mobility(
       DopingDependence
       HighFieldSaturation 
       Enormal
    )
    Recombination(
       SRH(DopingDependence TempDependence) 
       Auger
       
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
   Number_Of_Threads= 8
   eDrForceRefDens= 1e12
   hDrForceRefDens= 1e12

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
*- Creating initial guess:
   Coupled(Iterations=100 LineSearchDamping=1e-4){ Poisson } 
   Coupled { Poisson Electron Hole }
 
}

