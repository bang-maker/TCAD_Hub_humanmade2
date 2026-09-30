#created by Lanxiaomu
#if [string match "@type@" "NMOS"]
	#define _Vds_ 		1.5
	#define _VgsStart_ 	0.0
	#define _VgsEnd_ 	1.5
 
#else
	#define _Vds_ 		-1.5
	#define _VgsStart_ 	0.0
	#define _VgsEnd_ 	-1.5
 
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
	#if ![string match "-" "@traps@"] && ![string match "*interface*" "@traps@"]
		trappedcarplotfile = "n@node@_trap"
	#endif
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
		SRH  
		Auger
	)
	EffectiveIntrinsicDensity(OldSlotboom)

   #if ![string match "-" "@traps@"] && ![string match "*interface*" "@traps@"]
	Traps(
   	   # level exponential Gaussian table(experiment)
   	   # bulk traps (cm^-3)
   	   #if [string match "*Acceptor*" "@traps@"]
		   # acceptor exponential tail of the conduction band 
		   (Acceptor Exponential Conc=1.5e19 EnergySig=0.05 EnergyMid=0 fromCondBand 
		   hXsection= 1e-14 eXsection=1e-15 )
		   # acceptor deep levels
		   (Acceptor Gaussian Conc=1.9e18 EnergySig=0.1 EnergyMid=0.08 fromMidBandGap )
   	   #endif 
   	   #if [string match "*Donor*" "@traps@"]
		   (Donor 	Exponential 	Conc=1e18		fromValBand 	EnergyMid=0 	EnergySig=0.05)
   	   	   (Donor 	Gaussian 		Conc=1.13e18	fromValBand  	EnergyMid=0.51 	EnergySig=0.1)
   	   #endif    	   
  
   )
   ##endif
   #endif
}

#if [string match "*interface*" "@traps@"] 
Physics(MaterialInterface="Silicon/Oxide"){
	# interface traps   (cm^-2)
	Traps(
		(Acceptor Gaussian Conc=1e12 	EnergySig=0.05 	EnergyMid=0 fromCondBand)
		(Donor 	  Gaussian Conc=1e12	EnergySig=0.05 	EnergyMid=0 fromValBand)
	)
}                                      
#endif


 #if ![string match "-" "@traps@"] && ![string match "*interface*" "@traps@"]
	TrappedCarDistrPlot{
		Material="Silicon"{(0.0 0.002)}
	}
#endif
 
* 4 math 
Math{
	Method = Super 
	TrapDLN = 20
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
  eTrappedCharge hTrappedCharge  
  TotalTrapConcentration TotalInterfaceTrapConcentration
  eInterfaceTrappedCharge hInterfaceTrappedCharge
  eGapStatesRecombination hGapStatesRecombination
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
	#------------"pure mathmatic problem"-------#
	# Ax=b(gate= 0 drain=0) ---> tdr
	* step 1 initial solution
	*  solve poisson equation only 
	#if ![string match "-" "@TrapFilling@"]
		set(TrapFilling=@TrapFilling@)
	#endif
	
	Poisson
	*  solve poisson electron hole together
	Coupled{Poisson Electron  } 
	Coupled{Poisson Electron Hole } 
	* - get a solution 
	* step 2 change boundary condition
	Quasistationary( 
	 maxstep= 0.10 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "gate"  Voltage= 	_VgsStart_}
	Goal{Name= "drain" Voltage=  	_Vds_}
	* t: t=0 (gate=0 drain=0) t=1(gate=-0.5 drain=0.1)
	){ Coupled{ Poisson Electron Hole }}
	# Ax=b(gate= -0.5 drain=0.1)
	
	# unset(TrapFilling)
	* step 3 sweep the Id-Vg curve
	* n@node@_des.plt
	NewCurrentPrefix = "IdVg_" * IdVg_n@node@_des.plt
	Quasistationary( 
	 maxstep= 0.02 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "gate"  Voltage= _VgsEnd_}
	* t(time) t=0 (gate=-0.5 drain=0.1) t=1 (gate= 1.0 drain =0.1)
	){ Coupled{ Poisson Electron Hole }
		CurrentPlot(Time=(
			*time list
			Range=(0.0 1.0) Intervals= 40*---> 0.05;0.10;0.15....1.00
			* Range=(0.5 0.6) Intervals=20   *---> 0.505;0.51;0.515....0.60
			)
		)
*		Plot(FilePrefix="Profile_n@node@" Time=(Range=(0 1.0) Intervals= 10 ) noOverwrite ) * save tdr files
	}
 
}






