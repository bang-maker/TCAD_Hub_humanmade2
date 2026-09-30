Electrode {
    { Name= "top" Voltage= 0.0 }
    { Name= "bottom" Voltage= 0.0 }
}

File {
	Grid= "@tdr@"
	Parameter= "@parameter@"	
	Current= "@plot@"
	Plot= "@tdrdat@"
	Output= "@log@"
}
## Basic Physics required for GaN Simulation
Physics {
    DefaultParametersFromFile
    AreaFactor= 1000
    EffectiveIntrinsicDensity (Nobandgapnarrowing)
    Fermi Thermionic
    Aniso (Poisson direction=(0 0 1))
    Mobility (DopingDependence(Masetti) HighFieldSaturation(CaugheyThomas))
    Recombination(SRH  Radiative)
    #if @pz@
    	Piezoelectric_Polarization (strain)
    #endif
}

## Traps are not included in the simulation for simplicity
Physics (RegionInterface="R.AlGaN/R.GaN") {
    PiezoElectric_Polarization(activation= 1.0)
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
        PiezoCharge
		
        StressXX StressYY StressZZ
        StrainXX StrainYY StrainZZ
}


Math {
 
	Wallclock
	ExitOnFailure
	Extrapolate 
	
	Iterations= 24
	Digits= 5
	ErrRef(electron)= 1e4
	ErrRef(hole)= 1e4
	RHSMin= 1e-15
	Transient= BE
	ExtendedPrecision(80)
	TensorGridAniso(aniso)
	Method= Blocked
	SubMethod= ILS(set=12 )
	ILSrc= "set(12) {
		iterative (gmres(150), tolrel=1e-8, tolunprec=1e-6, maxit=200);
		preconditioning (ilut(1e-08,-1),left);
		ordering (symmetric=nd, nonsymmetric=mpsilst); 
		options(verbose=0, refineresidual=2);
	};"
	
	
}

** Zero bias solution	
Solve {
	Coupled (Iterations= 1000 LinesearchDamping= 1e-5) {Poisson}
	Coupled (Iterations= 1000 LinesearchDamping= 1e-5) {Poisson Electron Hole}
}