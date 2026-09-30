#setdep @node|MOS@

#define Frequency  1e6

Plot {
*--Density and Currents, etc
   eDensity hDensity
   TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
   eMobility hMobility
   eVelocity hVelocity
   eQuasiFermi hQuasiFermi
*--Band structure/Composition
   BandGap 
   BandGapNarrowing
   Affinity
   ConductionBandEnergy ValenceBandEnergy 
   eQuantumPotential hQuantumPotential
*--Temperature 
   eTemperature Temperature hTemperature
*--Material Properties
DielectricConstant
xMoleFraction
*--Driving forces
   eGradQuasiFermi/Vector hGradQuasiFermi/Vector
   eEparallel hEparallel eENormal hENormal
*--Generation/Recombination
   SRH Band2Band * Auger
   AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
*--Fields and charges
   ElectricField/Vector Potential SpaceCharge
*--Gate Tunneling
   eBarrierTunneling hBarrierTunneling  BarrierTunneling nonlocal
*--Doping Profiles
   Doping DonorConcentration AcceptorConcentration

   eTrappedCharge hTrappedCharge
}

Math {
  -CheckUndefinedModels
  ExitOnFailure
  Transient=BE

  Method=Blocked
  SubMethod=ILS(set=21)  * linear solver selection

  NumberOfThreads= 8

  ILSrc= "set (21) {      
      iterative(gmres(150), tolrel=1e-8, maxit=500);
      preconditioning(ilut(1.5e-7,-1), left);
      ordering(symmetric=nd, nonsymmetric=mpsilst);
      options(compact=yes, linscale=0, refineresidual=20, verbose=0);
  };"
  

  * Extrapolate
  ErrRef(electron)= 1e5
  ErrRef(hole)= 1e5
  eDrForceRefDens= 1e5
  hDrForceRefDens= 1e5
  ExtendedPrecision(80)
  CheckRhsAfterUpdate
  RHSmax= 1e30
  RHSmin= 1e-5
  RHSFactor= 1e30
  Iterations= 19
}

File {
        ACExtract= "cv_n@node@"
        output=   "cv_n@node@.log" 
     }

Device cv {
	electrode {
		* 2.5 is the electron affinity of Al2O3
		{ name= "anode"   voltage= 0.0 workfunction=@<barrier+2.5>@ }
		{ name= "cathode"   voltage= 0.0  }
	}

	File {
	   Grid=      "@tdr@"
	   Parameter= "@parameter@"
	   Plot=      "@tdrdat@"
	   Current=   "@plot@"
	}

	Physics{ 
	  AreaFactor=7500
	  EffectiveIntrinsicDensity(OldSlotboom)
	  Recombination(SRH(DopingDep))
	  	
	}
}

System {
         cv cv(anode= g cathode= b)
         Vsource_pset  vg(g 0) { pwl = (0.0 0 1.0 @<-1*Vdd>@ 2.0 @Vdd@) }
         Vsource_pset  vb(b 0) { dc= 0 }
       }

Solve {
        Poisson
        Coupled(Iterations= 100 LineSearchDamping= 1e-4){ Poisson }
	
		Transient (
		InitialTime= 0 FinalTime= 1
		InitialStep= 1e-1 Increment= 1.41
	  	Minstep= 5e-3 MaxStep= 0.5
	  	){ Coupled {Poisson Hole Electron Contact circuit }}
	
		NewCurrentFile="CV_" 
		Transient (
		InitialTime= 1 FinalTime= 2
		InitialStep= 1e-3 Increment= 1.41
	  	Minstep= 1e-6 MaxStep= 0.02
	  	){ ACCoupled (
			StartFrequency= 1e6
			EndFrequency= 1e6
			NumberOfPoints= 1
			decade
			Node(g b)
			Exclude(vg vb)
		 ) {Poisson Hole Electron Contact circuit }
		  Plot (FilePrefix="n@node@_CV" Time= ( 1.01; 1.1; 1.2; 1.3; 1.4; 1.5; 1.6; 1.7; 1.8; 1.9; 2.0 ) NoOverwrite ) }
        
}

