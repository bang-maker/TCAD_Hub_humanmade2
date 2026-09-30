# this was created by Lanxiaomu
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
	* trappedcarplotfile = "n@node@_trap"
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
		SRH  
		Auger
	)
	EffectiveIntrinsicDensity(OldSlotboom)
}
# TID model
Physics{
	Radiation(
		DoseRate= @DoseRate@ # rad/s
		DoseTime= (0,@<1.0*1e6*Dose/DoseRate>@)  # TID = DoseRate*DoseTime
		# Dose= #rad/ DoseTime=(,) 
		# DoseTSigma= 
	)
}

# add traps in OxideAsSemiconductor 
Physics(Material="OxideAsSemiconductor"){
	Traps(
		(Donor Level EnergyMid= 3.0 fromValBand Conc=1e21)
	)
	Mobility(
		ConstantMobility
	)
}


* 4 math 
Math{
	Method = ParDiSo
	TrapDLN=20
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

Solve {
	# step 1 prepare the device  (empty traps)---fresh
	Set(TrapFilling= Empty)
	Poisson
	*  solve poisson electron hole together
	Coupled{Poisson Electron  } 
	Coupled{Poisson Electron Hole } 
	Quasistationary( 
	 maxstep= 0.10 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3  
	Goal{Name= "gate"  Voltage= 	_VgsStart_}
	Goal{Name= "drain" Voltage=  	_Vds_}
	){ Coupled{ Poisson Electron Hole }}
	
	NewCurrentPrefix = "IdVg_PreTID_" * IdVg_n@node@_des.plt
	Quasistationary( 
	 maxstep= 0.02 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "gate"  Voltage= _VgsEnd_}
	){ Coupled{ Poisson Electron Hole }
 	} #end of IdVg
 	
	NewCurrentPrefix = "PrepareForTID_" * IdVg_n@node@_des.plt
	Quasistationary( 
	 maxstep= 0.02 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Name= "gate"  Voltage= @Vgate@}
		){ Coupled{ Poisson Electron Hole }
 	}
 	
	
	# step 2 add Gamma Radiation during (0, D/DoseRate)
	unset(TrapFilling)
	NewCurrentFile = "TransientTID_"
	Transient (
		InitialTime= 0 FinalTime= @<Dose*1e6/DoseRate>@
		InitialStep= 1e-2 Increment= 1.41
		Minstep= 1e-12 MaxStep= 50
	){Coupled { Poisson Electron Hole}
		Plot(FilePrefix="PreTID_n@node@"  time=(0)	)
		Plot(FilePrefix="PostTID_n@node@" time=(@<Dose*1e6/DoseRate>@)	)
	}
	
	# step 3 test the device characteristics after the Radiation(IdVg)
	# QuasiStationary:
	Set(TrapFilling=Frozen)
	NewCurrentFile = "Prepare_"
    Quasistationary ( 
		InitialStep= 1e-2 Increment= 1.41
		MinStep= 1e-7     MaxStep= 0.1
		Goal { Name="gate"  Voltage= _VgsStart_ }
		Goal { Name="drain" Voltage= _Vds_ }
	  ){Coupled { Poisson Electron Hole}}
	  
   NewCurrentFile = "IdVg_PostTID_"
   Quasistationary ( 
	InitialStep= 1e-2 	Increment= 1.41
	MinStep= 1e-7     	MaxStep= 0.01
    Goal { Name="gate"	Voltage= _VgsEnd_ }
  ){Coupled { Poisson Electron Hole }}
	
}
