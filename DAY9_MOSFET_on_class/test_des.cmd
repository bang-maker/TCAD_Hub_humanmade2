#if [string match "@type@" "NMOS"]
	#define _VdsStart_ 		0.0
	#define _VdsEnd_ 		1.0
	#define _Vgs1_ 			0.5
	#define _Vgs2_ 			0.75
	#define _Vgs3_ 			1.0
#else
	#define _VdsStart_ 		0.0
	#define _VdsEnd_ 		-1.0
	#define _Vgs1_ 			-0.5
	#define _Vgs2_ 			-0.75
	#define _Vgs3_ 			-1.0
#endif


* 1 input output file 
File{
	* input files 
	* Grid = "n@node|MOSFET@_msh.tdr"  
	Grid = "@tdr@"
	* Parameter = "@parameter@" * not exists
	
	* output files 
	Output = "@log@"
	Plot   = "@tdrdat@"
	Current= "@plot@" * n@node@_des.plt
	* other files...
	
}

* 2 Boundary Condition 
Electrode{
	{Name= "source" 	Voltage= 0.0 }
	{Name= "gate" 		Voltage= 0.0 }
	{Name= "drain" 		Voltage= 0.0 }
	{Name= "substrate" 	Voltage= 0.0 }
}
*Thermode{
*...
*}


* 3 Physics

Physics{ *global model
	Fermi
}
* material-wise
Physics(Material="Silicon"){
	* Drift-Diffuse Model
 
	Mobility (
	  DopingDep
	  Enormal
	  HighFieldSaturation
	)
	Recombination(
		SRH(ElectricField)  
		Auger
	)
	EffectiveIntrinsicDensity(OldSlotboom)
}

#if 0 
	* region-wise
	Physics(Region="R.channel"){
		......
	}
	
	*interface-wise
	Physics(MaterialInterface="Silicon/Oxide") {
		* Traps
	}
	Physics(RegionInterface="R.channel/R.gateoxide") {
		* Traps 
	}
#endif 

* 4 math 
Math{
	Method = Super
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

*CurrentPlot{
*	....
*}

* 6 Solve
Solve{
	#------------"pure mathmatic problem"-------#
	# Ax=b(gate= 0 drain=0 source=0 substrate=0) ---> tdr
	* step 1 initial solution
	*  solve poisson equation only 
	Poisson
	*  solve poisson electron hole together
	Coupled{Poisson Electron  } 
	Coupled{Poisson Electron Hole } 
	* - get a solution 
	* step 2 change boundary condition
	Quasistationary( 
	DoZero
	 maxstep= 0.10 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "gate"  Voltage= _Vgs1_}
	* t: t=0 (gate=0 drain=0) t=1(gate=-0.5 drain=0.1)
	){ Coupled{ Poisson Electron Hole }}

	Quasistationary( 
	 DoZero
	 maxstep= 0.10 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "gate"  Voltage= _Vgs2_}
	* t: t=0 (gate=0 drain=0) t=1(gate=-0.5 drain=0.1)
	){ Coupled{ Poisson Electron Hole }}
	 ***********method 1 end************
	 
	 
}






