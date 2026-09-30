#********this project was created and shared by Lan Xiaomu (wechat:TCAD2017) *********#

#if [string match "@type@" "NMOS"]
	#define _Vds_ 		0.1
	#define _VgsStart_ 	-0.5
	#define _VgsEnd_ 	1.0
 
#else
	#define _Vds_ 		-0.1
	#define _VgsStart_ 	0.5
	#define _VgsEnd_ 	-1.0
 
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

Thermode{
	{Name= "source" 	Temperature= 300.0 SurfaceResistance= 1e-3}
	{Name= "gate" 		Temperature= 300.0 SurfaceResistance= 1e-3}
	{Name= "drain" 		Temperature= 300.0 SurfaceResistance= 1e-3}
	{Name= "substrate" 	Temperature= 300.0 SurfaceResistance= 1e-3}
}


 

* 3 Physics

Physics{ *global model
	Fermi
	Temperature = @temp@
	#if [string match "*postTemp*" "@model@"] 
		PostTemperature
	#endif
	
	#if [string match "*thermodynamic*" "@model@"]
		thermodynamic
	#endif
	
	#if [string match "*hydrodynamic*" "@model@"]
		Hydrodynamic
		* Hydro(eTemp) * electron Temperature Only
		* Hydro(hTemp) * hole Temperature Only
	#endif 
	 
}
* material-wise
Physics(Material="Silicon"){
	* Drift-Diffuse Model
	
	Mobility (
		DopingDep
		Enormal
		HighFieldSat
	)
	Recombination(
		SRH( ElectricField)  
		Auger
	)
	EffectiveIntrinsicDensity(OldSlotboom)
}
 

* 4 math 
Math{
	Method = Super
	ExitOnFailure
	Iterations=20
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

CurrentPlot{
	ElectrostaticPotential((0 1e-3))
	eDensity((0 1e-3))
	srhRecombination(
		(0 1e-3)
		Integrate(Semiconductor)
	)
 
}

#define _LatticeTempEquation_ 


#if [string match "*CoutpledLatticeTemp*"  "@model@"]
	#define _LatticeTempEquation_  Temperature
#else
	#define _LatticeTempEquation_ 
#endif 

#if [string match "*thermodynamic*" "@model@"]
	#define _LatticeTempEquation_  Temperature
#endif

#if [string match "*hydrodynamic*" "@model@"]
	#define _CarrierTempEquation_ eTemperature hTemperature
	* eTemperature only   
	* #define _CarrierTempEquation_ eTemperature 
	*  hTemperature only 
	* #define _CarrierTempEquation_ hTemperature
#else 
	#define _CarrierTempEquation_
#endif 

#if [string match "*latticeTemp*" "@model@"]
	#define _LatticeTempEquation_ Temperature
#endif
 

* 6 Solve
Solve{
	#------------"pure mathmatic problem"-------#
	# Ax=b(gate= 0 drain=0) ---> tdr
	* step 1 initial solution
	*  solve poisson equation only 
	Poisson
	*  solve poisson electron hole together
	Coupled{Poisson Electron  } 
	Coupled{Poisson Electron Hole _LatticeTempEquation_ _CarrierTempEquation_} 
	* - get a solution 
	* step 2 change boundary condition
	Quasistationary( 
	 maxstep= 0.10 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "gate"  Voltage= 	_VgsStart_}
	Goal{Name= "drain" Voltage=  	_Vds_}
	* t: t=0 (gate=0 drain=0) t=1(gate=-0.5 drain=0.1)
	){ Coupled{ Poisson Electron Hole _LatticeTempEquation_  _CarrierTempEquation_} }
	# Ax=b(gate= -0.5 drain=0.1)
	
	* step 3 sweep the Id-Vg curve
	* n@node@_des.plt
	NewCurrentPrefix = "IdVg_" * IdVg_n@node@_des.plt
	Quasistationary( 
	 maxstep= 0.02 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "gate"  Voltage= _VgsEnd_}
	* t(time) t=0 (gate=-0.5 drain=0.1) t=1 (gate= 1.0 drain =0.1)
	){ Coupled{ Poisson Electron Hole _LatticeTempEquation_ _CarrierTempEquation_}
		CurrentPlot(Time=(
			*time list
			Range=(0.0 1.0) Intervals= 50*---> 0.05;0.10;0.15....1.00
			* Range=(0.5 0.6) Intervals=20   *---> 0.505;0.51;0.515....0.60
			)
		)
		Plot(FilePrefix="Profile_n@node@" Time=(Range=(0 1.0) Intervals= 10 ) noOverwrite ) * save tdr files
	}
 
} 