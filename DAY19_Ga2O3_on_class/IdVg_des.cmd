#setdep @node|MOSFET@

File {
   * input files:
   Grid=   "@tdr@"
   Parameter="@parameter@"
   * output files:
   Plot=   "@tdrdat@"
   Current="@plot@"
   Output= "@log@"
}

Electrode {
  { name="gate" voltage=0.0 workfunction=6.3
    Voltage= (
        0 at 0,
        0 at 1, 
        @Vg@ at 2 
    )
}
  { name="drain" voltage=0.0 DistResist=@rhoc@
    Voltage= (
        0 at 0, 
        @Vd@ at 1
    )
  }
  { name="source" voltage=0.0 DistResist=@rhoc@ }  
}

Physics {
  AreaFactor=500
  EffectiveIntrinsicDensity(OldSlotboom)
  Recombination(SRH(DopingDep))
}

Physics(Region="Substrate"){
   Traps (
      (
          Acceptor
          Level EnergyMid=0.0 fromValBand
          conc = @trap_conc@
      )
   )
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

Plot {
    eCurrent/Vector hCurrent/Vector
    ElectricField/Vector Current/Vector TotalCurrent/Vector
    Doping DonorConcentration AcceptorConcentration SpaceCharge

    SRH Auger
    eMobility hMobility
    eEparallel eEnormal 
    hEparallel hEnormal 
    ConductionBandEnergy ValenceBandEnergy 
    hQuasiFermiEnergy eQuasiFermiEnergy
    eBarrierTunneling hBarrierTunneling nonlocal
    eTrappedCharge hTrappedCharge
}


Solve {
  Coupled(Iterations=1000) {Poisson}
  * Coupled(Iterations=1000) {Poisson Electron Hole}
  Plot (FilePrefix="n@node@_init" )

  NewCurrentFile="Vd_" 
  Transient (
  InitialTime= 0 FinalTime= 1
  InitialStep= 1e-3 Increment= 1.41
  Minstep= 1e-6 MaxStep= 0.05
  ){ Coupled { Poisson Electron Hole }  
     Plot (FilePrefix="n@node@_drain_sweep" Time= ( 0; 0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9; 1 ) NoOverwrite )
}
  

  NewCurrentFile="IdVg_" 
  Transient (
  InitialTime= 1 FinalTime= 2
  InitialStep= 1e-3 Increment= 1.41
  Minstep= 1e-6 MaxStep= 0.02
  ){ Coupled { Poisson Electron Hole }  
     Plot (FilePrefix="n@node@_IdVg" Time= ( 1.1; 1.2; 1.3; 1.4; 1.5; 1.6; 1.7; 1.8; 1.9; 2 ) NoOverwrite )
}
}
