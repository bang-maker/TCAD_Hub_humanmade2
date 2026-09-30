###this project was created by lanxiaomu######
File{
	Grid = "@tdr@"
	Parameter = "@parameter@"  
	Output = "@log@"
	Plot   = "@tdrdat@"
	Current= "@plot@" 
}

!(
	set v_e		-40
	set v_w		15
	set t_0 	0.5e-4
	set t_e 	1e-4
	set t_w 	2e-4
	set t_rf	1e-5
	set time_list 	[list $t_0 $t_w $t_0 $t_e $t_0] 
	set volt_list 	[list 0.0 $v_w 0.0 $v_e 0.0 ]
)!


Electrode{
	{Name= "sub" 		Voltage= 0.0 }
	{Name= "gate" 		Voltage= ( !(
			set t 0.0
			foreach t0 $time_list v0 $volt_list {
					puts "$v0 at $t"
					set t [expr $t+$t0]
					puts "$v0 at $t"
					set t [expr $t+$t_rf]
			}		
	)! )
	}
}

Physics{ *global model
	Fermi
}

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

#if [string match "yes" "@Fowler@"]
	Physics(MaterialInterface="Silicon/Oxide"){
		GateCurrent(Fowler)
	}
#endif

Math{
	Method = Super
}

Plot{
  eDensity hDensity 
  Current eCurrent  hCurrent
  Potential  SpaceCharge  ElectricField
  eMobility  hMobility  eVelocity  hVelocity
  Doping DonorConcentration AcceptorConcentration
}

Solve{ 
	Poisson
	Coupled{Poisson Electron  } 
	Coupled{Poisson Electron Hole } 
	
  NewCurrentFile="It_"
  Transient (
    InitialTime= 0.0 FinalTime= !(puts $t)!
    InitialStep= 1e-5 Increment= 1.41
    Minstep= 1e-15 MaxStep= !(puts [expr $t/100.0])!
  ){
    Coupled {
      Poisson Electron Hole
    }
  }

}
