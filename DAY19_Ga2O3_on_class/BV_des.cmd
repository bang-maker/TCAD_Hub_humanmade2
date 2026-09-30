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
  { name="gate" voltage=0.0 workfunction=6.3 Voltage= 0.0 }
  { name="drain" voltage=0.0 Resist= 5e12 Voltage= 0.0 }
  { name="source" voltage=0.0 DistResist=@rhoc@ }  
}

Physics {
  AreaFactor=500
  EffectiveIntrinsicDensity(OldSlotboom)
  Recombination(
  SRH(DopingDep)
  Avalanche 
  )
  
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
      options(compact=yes, linscale=0, refineresidual=2, verbose=0);
  };"
  

  Extrapolate
  ErrRef(electron)= 1e5
  ErrRef(hole)= 1e5
  eDrForceRefDens= 1e5
  hDrForceRefDens= 1e5
  ExtendedPrecision(80)
  CheckRhsAfterUpdate
  RHSmin= 1e-5
  RHSmax= 1e30
  RHSFactor= 1e50
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
  * Coupled(Iterations=1000) {Poisson Electron }
  * Coupled(Iterations=1000) {Poisson Electron Hole}
  Plot (FilePrefix="n@node@_init" )
  
  ## Gate transient
  Transient (
    InitialTime = 0
    FinalTime = 1.0
    Goal {
      name= gate
      voltage= @Vgmin@
    }
    InitialStep= 1e-3
    MaxStep= 0.1
    MinStep= 1e-10 )
    { coupled { poisson electron hole }}
    

  NewCurrentFile="BV_"
   Transient (
    InitialTime = 1.0
    FinalTime = 1e4
    Goal {
      name= drain
      voltage= 1e4
    }
    InitialStep= 1e-3
    MaxStep= 0.1
    MinStep= 1e-10 )
    { coupled { poisson electron hole }}		
   System ("rm n@node@_des.plt")
   
}
