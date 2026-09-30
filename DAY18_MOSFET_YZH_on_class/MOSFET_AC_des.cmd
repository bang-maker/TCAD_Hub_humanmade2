# this code was created by Lanxiaomu
Device MOS{
	
	File{
		* input files 
		* Grid = "n@node|MOSFET@_msh.tdr"  
		Grid = "@tdr@"
		* Parameter = "@parameter@" * not exists
		
		* output files 
		Plot   = "@tdrdat@"
		Current= "@plot@" * n@node@_des.plt
		* other files...
		
	}

	Electrode{
		{Name= "source" 	Voltage= 0.0 }
		{Name= "gate" 		Voltage= 0.0 }
		{Name= "drain" 		Voltage= 0.0 }
		{Name= "substrate" 	Voltage= 0.0 }
	}
	
	Physics{ *global model
		Fermi
	}
	* material-wise
	Physics(Material="Silicon"){
		* Drift-Diffuse Model
	 
		Mobility (
			Enormal (
				IALmob 
			)
			HighFieldSaturation
		)
		Recombination(
			SRH(DopingDep ElectricField)  
			Auger
			Band2Band
		)
		EffectiveIntrinsicDensity(OldSlotboom)
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
	


} #end of MOS device 


Math{
	ACMethod = Blocked
	ACSubMethod = Super
	Iterations = 15
	Derivatives
	RelErrControl
	Digits= 6
}

File{
	ACExtract 	= "n@node@"
	Output 		= "@log@"
}


System{
	MOS mos ( drain=d source=s substrate=b gate=g)
	# DC
	Vsource_pset vd (d 0 ) { dc = 0.0 }
	Vsource_pset vg (g 0 ) { dc = 0.0 }
	Vsource_pset vs (s 0 ) { dc = 0.0 }
	Vsource_pset vb (b 0 ) { dc = 0.0 }
}


Solve{

# prepare the DC working point
#- initial 
	Poisson
	Coupled{ Poisson Electron} 
	Coupled{ Poisson Electron Hole}
	
	Quasistationary( 
	 maxstep= 0.10 minstep= 1e-5
	 increment= 1.4 decrement= 2.0
	 initialstep= 1e-3 * unit : t(time)
	Goal{Parameter=vg.dc  Voltage=-2.0}
	Goal{Parameter=vd.dc  Voltage= 0.0}
	){ Coupled{ Poisson Electron Hole Circuit }}
 
# simulate the CV curve 
	NewCurrentFile= "CV_"
	Quasistationary (
	InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter=vg.dc Voltage= 2.0}
	){
		ACCoupled(
			StartFrequency=1e1 EndFrequency=1e12 NumberofPoints=45 Decade
			Node(g b s d)
			Exclude( vg vd vb vs)
			ACCompute(Time= (Range=(0 1) Intervals= 40))
		){
			Poisson Electron Hole Circuit  
		}
		CurrentPlot(Time= (Range=(0 1) Intervals= 50))
	}
 
}




