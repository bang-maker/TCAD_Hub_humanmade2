 
File {
   Grid= "@tdr@" 
   Parameters= "@parameter@"
   Plot= "@tdrdat@"
   Current= "@plot@" 
   Output= "@log@"	
}	

Electrode {
   { Name="Gate"      Voltage= 0   }
   { Name="Emitter"   Voltage= 0   }
   { Name="Collector" Voltage= 0   }
}

Thermode {
   { Name="Gate"      Temperature= 300 }
   { Name="Emitter"   Temperature= 300 }
   { Name="Collector" Temperature= 300 }
}

Physics {
   Temperature= 300
   EffectiveIntrinsicDensity(BandGapNarrowing (Slotboom))
   Thermodynamic
   AnalyticTEP
}

Physics(Material="Silicon"){
  Mobility ( 
      Enormal(IALMob)
      HighFieldSaturation      
   )
   Recombination (
      SRH(DopingDependence TempDependence)
      Auger
      Avalanche (Lackner)
   )      
}

Plot{

  *- Carrier Densities:
  eDensity hDensity
  # EffectiveIntrinsicDensity IntrinsicDensity
  # eEquilibriumDensity hEquilibriumDensity
  *- Currents and current components:
  Current/Vector eCurrent/Vector hCurrent/Vector
  # ConductionCurrent/Vector DisplacementCurrent/Vector
  eMobility hMobility
  eVelocity hVelocity
  *- Fields, Potentials and Charge distributions
  ElectricField/Vector
  Potential
  eQuasiFermi hQuasiFermi
  SpaceCharge
  *- Driving forces
  eGradQuasiFermi/Vector hGradQuasiFermi/Vector
  eEparallel hEparallel 
  eENormal hENormal
  # eEffectiveField hEffectiveField
  *- Temperatures
  LatticeTemperature
  eTemperature hTemperature
  *- Generation/Recombination
  SRHRecombination Band2BandGeneration AugerRecombination RadiativeRecombination
  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
  TotalRecombination
  eLifeTime hLifeTime
  SurfaceRecombination
  # CDL CDL1 CDL2 CDL3
  # eCDL1lifetime eCDL2lifetime hCDL1lifetime hCDL2lifetime
  # SurfaceMultRecombination
  *- Doping Profiles
  Doping 
  DonorConcentration AcceptorConcentration
  # AntimonyConcentration ArsenicConcentration BoronConcentration 
  # IndiumConcentration NitrogenConcentration PhosphorusConcentration
  # NDopantConcentration PDopantConcentration
  *- Incomplete ionization
  # AsPlus PhPlus SbPlus NitrogenPlus
  # BMinus InMinus 
  # NDopantPlus PDopantMinus 

  *- Band structure
  BandGap 
  BandGapNarrowing
  ElectronAffinity
  ConductionBandEnergy ValenceBand
  eQuantumPotential hQuantumPotential
  *- Composition
  # xMoleFraction yMoleFraction
  *- Traps
  # eTrappedCharge hTrappedCharge
  # eGapStatesRecombination hGapStatesRecombination
  *- Optical Generation
  # ComplexRefractiveIndex AbsorbedPhotonDensity OpticalGeneration
  # OpticalAbsorptionHeat QuantumYield
  *- Generation due to Ion Strikes
  # AlphaCharge HeavyIonChargeDensity
  *- Gate Tunneling/Hot carrier injection
  # FowlerNordheim 
  # HotElectronInjection HotHoleInjection
  *- Tunneling
  # BarrierTunneling eBarrierTunneling hBarrierTunneling
  # eDirectTunnelCurrent hDirectTunnelCurrent
  *- Ionization Integrals
  # MeanIonIntegral eIonIntegral hIonIntegral 
  *- Heat flow
  # TotalHeat eJouleHeat hJouleHeat
  # PeltierHeat ThomsonHeat RecombinationHeat
  # ThermalConductivity 
  *- Stress-Tensor
  # Stressxx Stressxy Stressxz Stressyy Stressyz Stresszz
  *- Ferro-electrical Polarization
  # Polarization/Vector
  *- Piezo
  # PiezoCharge ConversePiezoelectricField
  # ConversePiezoelectricFieldXX ConversePiezoelectricFieldXY ConversePiezoelectricFieldXZ
  # ConversePiezoelectricFieldYY ConversePiezoelectricFieldYZ ConversePiezoelectricFieldZZ

}

Math {
   Extrapolate
   Transient= BE
   Notdamped= 50
   Iterations= 15
   ExitOnFailure
   Digits= 5
   ErrEff(electron)= 1.5e10
   ErrEff(hole)= 1.5e10
   Method= Super
   Numberofthreads = 2
}

Solve {
   Poisson
   Coupled { Poisson Electron  }
   Coupled { Poisson Electron Hole }
   
   NewCurrentFile= ""
   Continuation(
   	NewArc
    Name="Collector"                 * Curve is traced at this electrode
    InitialVStep=0.01                * Initial voltage step (V)
    Increment=1.41 Decrement=2
    MaxVstep= 8 *(V)                 * limits voltage step along curve trace
    MinVoltage=0   MaxVoltage=500    * Define the I-V window where
    MinCurrent=0   MaxCurrent=1e-4   * IV curve is traced
    Iadapt=1e-12                     * up to this current a Quasistationary
                                     * with voltage ramping is used instead
                                     * of continuation
    MaxRload=1e10
   	) { Coupled { Poisson Electron Hole Temperature} }
 
}

