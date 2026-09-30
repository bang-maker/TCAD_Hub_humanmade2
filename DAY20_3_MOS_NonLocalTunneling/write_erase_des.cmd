###this project was created by lanxiaomu######
File{
	Grid = "@tdr@"
	Parameter = "@parameter@"  
	Output = "@log@"
	Plot   = "@tdrdat@"
	Current= "@plot@" 
	#if 0
		#if [string match "yes" "@NLTunneling@"]
			NonLocalPlot = "n@node@_nlm_plot_des.tdr"  
		#endif
	#endif
	
}

!(
	set v_e		-40
	set v_w		15
	set t_0 	0.5e-4
	set t_e 	1e-4
	set t_w 	1e-4
	set t_rf	1e-5
	set time_list 	[list $t_0 $t_w $t_0 $t_e $t_0] 
	set volt_list 	[list 0.0 $v_w 0.0 $v_e 0.0]
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
	
	#if [string match "yes" "@NLTunneling@"]
		eBarrierTunneling "NLM"  
	#endif
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


Math{
	Method = Super
	#if [string match "yes" "@NLTunneling@"]
		Nonlocal "NLM" ( 
			Barrier(Region="R.GateOxide")
		)	
	#endif
	
}

Plot{
  eDensity hDensity 
  Current eCurrent  hCurrent
  Potential  SpaceCharge  ElectricField
  eMobility  hMobility  eVelocity  hVelocity
  Doping DonorConcentration AcceptorConcentration
  
  # for visulize NLM
  eBarrierTunneling hBarrierTunneling
  NonLocal
  
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
    Plot(FilePrefix= "profile_n@node@_positive" time=(1e-4)) 
    Plot(FilePrefix= "profile_n@node@_negative" time=(3e-4)) 
  }

}
