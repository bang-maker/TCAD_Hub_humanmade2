#********this project was created and shared by Lan Xiaomu (wechat:TCAD2017) *********#

#if [string match "*Schottky*" "@BC@" ] 
	#define _Boundary_TYPE_ Schottky 
#elif [string match "*Ohmic*" "@BC@" ] 
	#define _Boundary_TYPE_ 
#else 
    #define _Boundary_TYPE_ 
#endif 

#if [string match "*-*" "@Barrier@" ] 
	#define _BARRIER_ 
#else 
	#define _BARRIER_  Barrier= @Barrier@
#endif 


#if [string match "*-*" "@Workfunction@" ] 
	#define _WORKFUNCTION_ 
#else 
	#define _WORKFUNCTION_  Workfunction=@Workfunction@
#endif 


#if [string match "*-*" "@eRecVelocity@" ] 
	#define _ERECVELOCITY_ 
#else 
	#define _ERECVELOCITY_  eRecVelocity=@eRecVelocity@
#endif 

#if [string match "*-*" "@hRecVelocity@" ] 
	#define _HRECVELOCITY_ 
#else 
	#define _HRECVELOCITY_  hRecVelocity=@hRecVelocity@
#endif 

#if [string match "*SchottkyResist*" @BC@]
	#define _Boundary_TYPE_ 
	#define _SchottkyResist_ DistResist=SchottkyResist
#endif

File{
	* input files  
	Grid = "@tdr@"
	Parameter = "@parameter@" 
	
	* output files 
	Output = "@log@"
	Plot   = "@tdrdat@"
	Current= "@plot@" * n@node@_des.plt
	* other files...
	
}

* 2 Boundary Condition 
Electrode{
	{Name= "top" 			Voltage= 0.0 _Boundary_TYPE_ _BARRIER_ _WORKFUNCTION_ _ERECVELOCITY_ _HRECVELOCITY_ _SchottkyResist_}
	{Name= "bottom" 		Voltage= 0.0  }
}
 
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

* 4 math 
Math{
	Extrapolate
	Notdamped=50
	Iterations=15
	ExitOnFailure
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
  DopingWells
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

 

* 6 Solve
Solve{

	Poisson
 
	Coupled{Poisson Electron  } 
	Coupled{Poisson Electron Hole } 
	
	NewCurrentPrefix = "Boot_"  
	Quasistationary( 
	 maxstep= 0.01 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3  
	Goal{Name= "top"   Voltage= -5.0}
	){ Coupled{ Poisson Electron Hole }}
	
	NewCurrentPrefix = "IV_"  
	Quasistationary( 
	 maxstep= 0.01 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3  
	Goal{Name= "top"   Voltage= 5.0}
	){ Coupled{ Poisson Electron Hole }}
                       
}






