File{
	* input files 
	Grid = "@tdr@"
	Parameter = "@parameter@" * not exists
	
	* output files 
	Output = "@log@"
	Plot   = "@tdrdat@"
	Current= "@plot@" * n@node@_des.plt
	* other files...
}

* 2 Boundary Condition 
Electrode{
	{Name= "P" 		Voltage= 0.0 }
	{Name= "N" 		Voltage= 0.0 }
}

Physics{
	* drift-diffuse model 
	EffectiveIntrinsicDensity(OldSlotboom)
	
	* mobility 
	Mobility(
		HighFieldSaturation
	)
	
	* Recombination
	Recombination(
		SRH
	)
}

Physics(Region= "R.SiGe"){
	MoleFraction(
		xFraction= @xMole@
	
	)
}


* 4 math 
Math{
	Method = Super
	ExitOnFailure
	Iterations= 15
}



* 5 output
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
  # eGradQuasiFermi/Vector hGradQuasiFermi/Vector
  # eEparallel hEparallel 
  # eENormal hENormal
  # eEffectiveField hEffectiveField
  *- Temperatures
  LatticeTemperature
  eTemperature hTemperature
  *- Generation/Recombination
  SRHRecombination Band2BandGeneration eBand2BandGeneration hBand2BandGeneration AugerRecombination RadiativeRecombination
  AvalancheGeneration eAvalancheGeneration hAvalancheGeneration
  TotalRecombination
  eLifeTime hLifeTime
  SurfaceRecombination
  CDL CDL1 CDL2 CDL3
  eCDL1lifetime eCDL2lifetime hCDL1lifetime hCDL2lifetime
   
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
  xMolefraction

}

 
* 6 Solve
Solve{
 
	* step 1 initial solution
	*  solve poisson equation only 
	Coupled(Iterations=1000 LineSearchDamping=1e-4){Poisson}
	*  solve poisson electron hole together
	Coupled(Iterations=1000 LineSearchDamping=1e-4){Poisson Electron  } 
	Coupled(Iterations=1000 LineSearchDamping=1e-4){Poisson Electron Hole } 
	* - get a solution 
	Quasistationary( 
	 maxstep= 0.02 minstep= 1e-11
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "P"  Voltage= -10}
	* t(time) t=0 (gate=-0.5 drain=0.1) t=1 (gate= 1.0 drain =0.1)
	){ Coupled{ Poisson Electron Hole }	}
	
	* step 3 sweep the IV curve
	NewCurrentPrefix = "IV_"  
	Quasistationary( 
	 maxstep= 0.02 minstep= 1e-11
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "P"  Voltage= 1}
	* t(time) t=0 (gate=-0.5 drain=0.1) t=1 (gate= 1.0 drain =0.1)
	){ Coupled{ Poisson Electron Hole }	}
 
	
}



