###this project was created by lanxiaomu######

File {
   * input files:
   Grid=   "@tdr@"
   Parameter="@parameter@"
   * output files:
   Plot=   "@tdrdat@"
   Current="@plot@"
   Output= "@log@"
 
}

Electrode {
             {Name="gate"     Voltage=0.0       Workfunction=@WF@ }
             {Name="source"     Voltage=0.0     }
	         {Name="drain"     Voltage=0.0       }
}

Physics {
          
          Mobility ( 
          	  DopingDep(unibo) 
          	  Enormal
              )
          EffectiveIntrinsicDensity(BandGapNarrowing(OldSlotboom))
          Recombination (
	          	  SRH(DopingDep)
					  Auger
					  Band2Band(Model=NonlocalPath1)
                  )
          Fermi 
}
 
Plot {       
	 eDensity hDensity
	 eCurrentDensity hCurrentDensity
	 Current
	 eBand2BandGeneration hBand2BandGeneration
	 Band2BandGeneration
	 SRHRecombination 
	 Potential SpaceCharge ElectricField
	 eMobility hMobility eVelocity hVelocity 
     Doping DonorConcentration AcceptorConcentration 
	 SemiconductorGradConductionBand/vector
	 SemiconductorGradValenceBand/vector
	 ConductionBandEnergy ValenceBandEnergy
	 eQuasiFermiEnergy hQuasiFermiEnergy
     AvalancheGeneration
	 BandGap EffectiveBandGap
	 NonLocal
}

Math {
	Cylindrical(yAxis=0.02)		
	RelErrControl
	Digits=5
	NotDamped=50
	Iterations=30
	Number_of_threads=4
	Method= Pardiso
	ErrRef(electron)=1e10
	ErrRef(hole)=1e10
	Derivatives
 
}

 

Solve {
#-initial solution:
Poisson
Coupled { Poisson Electron }
Coupled { Poisson Electron Hole}
Save ( FilePrefix="n@node@_init" )
  #-- Ramp drain to VdLin
  Quasistationary( 
    InitialStep=1e-2 Increment=1.5 
    MinStep=1e-6 MaxStep=0.5 
    Goal { Name="drain" Voltage=0.05 } 
  ){ Coupled { Poisson  Electron   Hole } }
  Save ( FilePrefix="n@node@_VdLin" )

  #-- Ramp drain to VdSat
  Load ( FilePreFix="n@node@_init" )
  Quasistationary( 
    InitialStep=1e-2 Increment=1.5 
    MinStep=1e-6 MaxStep=0.5 
    Goal { Name="drain" Voltage=@Vdd@ } 
  ){ Coupled { Poisson  Electron  Hole  } }
  Save ( FilePrefix="n@node@_VdSat" )

  #-- Vg sweep for Vd=VdLin
  NewCurrentPrefix="IdVg_VdLin_" 
  Load ( FilePrefix = "n@node@_VdLin" )
  Quasistationary( 
    DoZero 
    InitialStep=1e-2 Increment=1.2 
    MinStep=1e-8 MaxStep=0.02
    Goal { Name="gate" Voltage=@Vdd@ } 
  ){ Coupled { Poisson  Electron  Hole }
   
	 Plot(FilePrefix= "n@node@_OFF" Time= (0.1))
     Save(FilePrefix= "n@node@_OFF" Time= (0.1))
     Plot(FilePrefix= "n@node@_SUB" Time= (0.5))
     Save(FilePrefix= "n@node@_SUB" Time= (0.5))
     Plot(FilePrefix= "n@node@_ON" Time= (1))
     Save(FilePrefix= "n@node@_ON" Time= (1))
   }
   
  #-- Vg sweep for Vd=VdSat
  NewCurrentPrefix="IdVg_VdSat_" 
  Load ( FilePrefix="n@node@_VdSat" )
  Quasistationary( 
    DoZero 
    InitialStep=1e-2 Increment=1.2 
    MinStep=1e-8 MaxStep=0.02 
    Goal { Name="gate" Voltage=@Vdd@ } 
  ){ Coupled { Poisson  Electron Hole   } 
   
   }

 
 
}


