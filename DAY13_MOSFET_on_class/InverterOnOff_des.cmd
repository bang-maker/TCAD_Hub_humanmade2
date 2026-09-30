Device NMOS{ #device

	File {
		Grid= "n@node|MOSFET@_msh.tdr"
		*Parameter="@parameter@"
		Current= "@plot@" # nmos_n@node@_des.plt
		Plot= "@tdrdat@"  # nmos_n@node@_des.tdr
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
	
	#CurrentPlot{
	#
	#}
	
}#end of Device NMOS



Device PMOS{ #device

	File {
		Grid= "n@node|MOSFET:+1@_msh.tdr" # :-> Same Col Different Row |-> Same Row different Col
		*Parameter="@parameter@"
		Current= "@plot@" # nmos_n@node@_des.plt
		Plot= "@tdrdat@"  # nmos_n@node@_des.tdr
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
	
	#CurrentPlot{
	#
	#}
	
}#end of Device PMOS



File {
	Output= "@log@"	# the log file of the simulation
}

Math{
	Method = ParDiSo
	ExitOnFailure
	Iterations= 15
}
 
System {
	* SPICE model/TCAD model + Netlist
	* choice1 : HSPICE netlist (.sp)
	* choice2 : SPICE circuit file (.scf)
	* by command
	
	NMOS nmos (source=ss drain=out gate=in substrate=ss ) {Physics{Areafactor=2.0}} #w=1.0um 
	PMOS pmos (source=dd drain=out gate=in substrate=ss ) {Physics{Areafactor=10.0}} #w=1.0um
	Capacitor_pset Cl (out ss) {capacitance= 20e-15}
	# power supply       V+ V-   #instance parameter 
	Vsource_pset Vdd 	(dd 0) 	{   dc = 0.0    } #instance parameter 
	Vsource_pset Vss 	(ss 0) 	{   dc = 0.0      } #instance parameter 
	
	#                                     Vinital  Vpulse       delay           rt              rf             pulse width     period 
	Vsource_pset Vin 	(in 0) 	{ pulse= (   0       2.0  @<2*time_ps>@  @<0.2*time_ps>@  @<0.2*time_ps>@    @<12*time_ps>@   @<24.4*time_ps>@)
															#equal to : [expr 0.2*$time_ps]
	} #instance parameter 
	#Vsource_pset Vout 	(out 0) {dc = 0.0} #instance parameter 
	#save the result at the system nodes
	Plot "n@node@_sys_des.plt" (time() v(dd) v(ss) v(in) v(out)
									i(nmos,ss) i(nmos dd) i(nmos in) i(nmos out)
									i(pmos,ss) i(pmos dd) i(pmos in) i(pmos out)
								)

}


Solve{

   #step 1:  inital solution 
   Poisson #without (contact equation) 
   Coupled{ Poisson nmos.Electron pmos.Hole }
   Coupled{ Poisson nmos.Electron pmos.Hole Contact Circuit }
   
   
   #step 2: prepare: boot: 
  Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter= Vdd.dc Value= 2.0 }
    Goal { Node= out Value= 2.0 } # help
  ){
    Coupled { 
      Poisson nmos.Electron pmos.Hole Contact Circuit
    }
  }
  
  #step 3: simulate VTC Curve #
  NewCurrentFile= "OnOff_"
  Transient (
    InitialTime= 0.0 FinalTime= @<50*time_ps>@
    InitialStep= 1e-12 Increment= 1.41
    Minstep= 1e-20 MaxStep=  @<1.0*time_ps>@
  ){
    Coupled {
      Poisson Electron Hole Contact Circuit
    }
  }

   
}
