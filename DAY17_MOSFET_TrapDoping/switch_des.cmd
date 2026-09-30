
Device NMOS{

	* 1 input output file 
	File{
		* input files 
		Grid = "n@node|MOSFET@_msh.tdr"
		* Parameter = "@parameter@" * not exists
		
		* output files 
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
	
	Plot{
	  eDensity hDensity 
	  Current eCurrent  hCurrent
	  Potential  SpaceCharge  ElectricField
	  eMobility  hMobility  eVelocity  hVelocity
	  Doping DonorConcentration AcceptorConcentration
	}

}



Device PMOS{
	* 1 input output file 
	File{
		* input files 
		Grid = "n@node|MOSFET:+1@_msh.tdr"
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
	
	Plot{
	  eDensity hDensity 
	  Current eCurrent  hCurrent
	  Potential  SpaceCharge  ElectricField
	  eMobility  hMobility  eVelocity  hVelocity
	  Doping DonorConcentration AcceptorConcentration
	}

}


Math{
	Method= ParDiSo
	Iterations = 15
}

System{
	Vsource_pset Vdd (dd 0) { dc = 0.0 }
	#                                  init  pulse      delay         rt               ft           pulsewidth      period
	Vsource_pset Vin (in 0) { pulse =  ( 0   1.5    @<2*time_ps>@  @<0.2*time_ps>@   @<0.2*time_ps>@  @<12*time_ps>@  @<24.4*time_ps>@) }
	Vsource_pset Vss (ss 0) { dc = 0.0} 
	NMOS nmos (source=ss drain=out gate=in substrate=ss)
	PMOS pmos (source=dd drain=out gate=in substrate=ss)
	Capacitor_pset Cout (out 0) {capacitance= 20e-15}
	
	Plot "n@node@_sys_des.plt" (time() v(dd) v(in) v(out) 
								i(nmos out) i(nmos ss) 
								i(pmos out) i(pmos dd)
							   )
}


Solve{  
  NewCurrentPrefix="init"
  Coupled{ Poisson nmos.Electron pmos.Hole Contact Circuit }

  Quasistationary( 
     InitialStep=1e-3 Increment=1.35 
     MinStep=1e-5 MaxStep=0.1 
     Goal{ Parameter=Vdd.dc Voltage= 1.5 }
     Goal{ Parameter=Vin.dc Voltage= 0.0 } 
  ){ Coupled{ Poisson nmos.Electron pmos.Hole Contact Circuit}
  }

  NewCurrentPrefix="switch_"
  Transient (
    InitialTime= 0 FinalTime= @<50*time_ps>@
    InitialStep= @<0.01*time_ps>@ Increment= 1.41
    Minstep= 1e-15 MaxStep= @<1*time_ps>@
  ){
    Coupled {
      Poisson nmos.Electron pmos.Hole Contact Circuit
    }
  }

}




