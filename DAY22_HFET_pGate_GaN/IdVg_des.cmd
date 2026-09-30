Electrode {
	{ Name="gate"   Voltage= 0 DistResist=SchottkyResist}
	{ Name="source" Voltage= 0 Schottky Workfunction= 4.3}
	{ Name="drain"  Voltage= 0 Schottky Workfunction= 4.3}
}

Thermode {
        { Name="thermal" Temperature= 300 SurfaceResistance= 0.004 }
}


File {
	Grid= "@tdr@"
	Parameter= "@parameter@"
	
	Current= "@plot@"
	Plot= "@tdrdat@"
	Output= "@log@"

	NewtonPlot= "n@node@_Newton_%d_des.tdr"	
}
Physics {
	AreaFactor= 1000
	Mobility (
		DopingDependence 
		Highfieldsaturation
	)
	EffectiveIntrinsicDensity (Nobandgapnarrowing)
	Fermi
	Recombination(
		SRH 
	)
	Piezoelectric_Polarization (strain)
	Thermionic
	eBarrierTunneling "SourceNLM"
	eBarrierTunneling "DrainNLM"
}

Physics (MaterialInterface="AlGaN/Nitride") {
	Traps(
		(Donor Level Conc= 5e13 EnergyMid= 0.6 FromMidBandGap)
	)
}

Physics (MaterialInterface="AlGaN/Oxide") {
	Traps(
		(Acceptor Level Conc= 5e13 EnergyMid= 0 FromMidBandGap)
	)
}


Physics (RegionInterface="GaN_channel/AlGaN_1") {
	Traps(
	(Acceptor Conc= 6e12 EnergyMid= 0.23 FromConductionBand )
	)
}

Physics (Region="buffer") {
	Traps(
		(Acceptor Level Conc= 1e15 EnergyMid= 0.45 FromCondBand)
	)
}


Math {
	NonLocal "SourceNLM" (
		Electrode="source"
		Digits= 4
		Length= 12e-7
		EnergyResolution= 1e-3
		Direction=(1 0 0) MaxAngle=1
		-EndPoint(Material="AlGaN")
	)
	NonLocal "DrainNLM" (
		Electrode="drain"
		Digits= 4
		Length= 12e-7
		EnergyResolution= 1e-3
		Direction=(1 0 0) MaxAngle=1
		-EndPoint(Material="AlGaN")
	)
}



Plot {  
	NonLocal
	Electricfield/Vector
	eCurrent/Vector hCurrent/Vector TotalCurrent/Vector
	
	SRH Avalanche
	eMobility hMobility
	eQuasiFermi hQuasiFermi
	eGradQuasiFermi hGradQuasiFermi
	eEparallel hEparallel
	
	eVelocity hVelocity
	Doping DonorConcentration Acceptorconcentration
	SpaceCharge
	ConductionBand ValenceBand
	BandGap Affinity
	xMoleFraction
	
	PE_Polarization/Vector
	PE_Charge
	eTrappedCharge eInterfaceTrappedCharge
	hTrappedCharge hInterfaceTrappedCharge
	
	eBarrierTunneling
}

Math {
	Transient=BE
	ExitOnFailure
	Extrapolate
	Iterations= 12
	DirectCurrentComputation
	ErrRef(Electron)=1e5
	ErrRef(Hole)=1e5
	ExtendedPrecision
	Digits= 5
	RHSMin= 1e-15
	eDrForceRefDens= 1e8 hDrForceRefDens= 1e8
	
	CNormPrint
	NewtonPlot (
		Error MinError
		Residual
	)
}


Solve {
	NewCurrentPrefix="n@node@_init_"
	Coupled (Iterations= 10000 LinesearchDamping= 1e-5) {Poisson}
	Coupled (Iterations= 10000 LinesearchDamping= 1e-5) {Poisson Electron Hole Temperature}	

	Quasistationary (
	DoZero
		InitialStep= 2e-3 Minstep= 1e-5 MaxStep= 0.1
		Goal{Name="drain" Voltage= @Vd@}
	) {
		Coupled {Poisson Electron Hole Temperature}
	}

	Save(FilePrefix="zero_n@node@")
	NewCurrentPrefix="F"
	Quasistationary (
	BreakCriteria{Current(Contact = "drain" minval= 1e-15)}
		InitialStep= 1e-3 Minstep= 1e-7 MaxStep= 0.02
		Goal{Name="gate" Voltage=@Vgmax@}
	) {
		Coupled {Poisson Electron Hole Temperature}
		Plot(FilePrefix="n@node@_zero" Time=(0;@<1.44/7>@) NoOverWrite)
	}
	Load(FilePrefix="zero_n@node@")
	NewCurrentPrefix="R"
	Quasistationary (
	BreakCriteria{Current(Contact = "drain" minval= 1e-15)}
		InitialStep= 1e-3 Minstep= 1e-7 MaxStep= 0.02
		Goal{Name="gate" Voltage=-2}
	) {
		Coupled {Poisson Electron Hole Temperature}
	}

}

