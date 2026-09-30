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


File {
	Output= "@log@"	# the log file of the simulation
}

Math{
	Method = ParDiSo
	ExitOnFailure
}
 
System {
	* SPICE model/TCAD model + Netlist
	* choice1 : HSPICE netlist (.sp)
	* choice2 : SPICE circuit file (.scf)
	* by command
	
	NMOS nmos (source=s drain=d gate=g substrate=b )
	# power supply
	Vsource_pset Vg (g 0) {dc = 0.0} #instance parameter 
	Vsource_pset Vs (s 0) {dc = 0.0} #instance parameter 
	Vsource_pset Vd (d 0) {dc = 0.0} #instance parameter 
	Vsource_pset Vb (b 0) {dc = 0.0} #instance parameter 
	#save the result at the system nodes
	Plot "n@node@_sys_des.plt" (time() v(g) v(s) v(d) v(b)
									i(nmos,s) i(nmos d) i(nmos g) i(nmos b)
								)

}


Solve{

   #step 1:  inital solution 
   Poisson #without (contact equation) 
   Coupled{ Poisson Electron   }
   Coupled{ Poisson Electron   Contact Circuit }
   
   
   #step 2: prepare
  Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter= Vd.dc Value= 1.5 }
  ){
    Coupled { 
      Poisson Electron   Contact Circuit
    }
  }
  #step 3: simulate IdVg Curve #
  NewCurrentFile= "IdVg_"
  Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter= Vg.dc Value= 1.5 }
  ){
    Coupled { 
      Poisson Electron   Contact Circuit
    }
  }
  
   
  
}
