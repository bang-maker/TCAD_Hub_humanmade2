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
	Iterations=15
}

#tcl block
!( 
	set stage @stage@
	
)!


System {
	* SPICE model/TCAD model + Netlist
	* choice1 : HSPICE netlist (.sp)
	* choice2 : SPICE circuit file (.scf)
	* by command
	* stage 1
	!(	
		for {set i 1} {$i<=$stage} {incr i} {
			if { $i == 1} {
				puts "NMOS nmos$i (source=ss drain=out$i gate=out$stage substrate=ss ) \{Physics\{Areafactor=1.0\}\}"
				puts "PMOS pmos$i (source=dd drain=out$i gate=out$stage substrate=ss ) \{Physics\{Areafactor=1.0\}\}" 
			} else {		
				puts "NMOS nmos$i (source=ss drain=out$i gate=out[expr $i-1] substrate=ss ) \{Physics\{Areafactor=1.0\}\}"
				puts "PMOS pmos$i (source=dd drain=out$i gate=out[expr $i-1] substrate=ss ) \{Physics\{Areafactor=1.0\}\}" 
			}
		}
		
	)!
	 * write a tcl program to automatically generate sdevice code!
	
	# power supply
	Vsource_pset Vdd 	(dd 0) 	{dc = 0.0} #instance parameter 
	Vsource_pset Vss 	(ss 0) 	{dc = 0.0} #instance parameter 
	#Vsource_pset Vin 	(in 0) 	{dc = 0.0} #instance parameter 
	#Vsource_pset Vout 	(out 0) {dc = 0.0} #instance parameter 
	#save the result at the system nodes
	Plot "n@node@_sys_des.plt" (time() v(dd) v(ss)  
								!(
									for {set i 1} {$i<=$stage} {incr i} {
										puts "v(out$i)"
										puts "i(nmos$i,out$i)"
										puts "i(pmos$i,out$i)"
									}
								)!
								)
	# solution 2							
	Initialize(
		!(
			for {set i 1} {$i<=$stage} {incr i} {
				puts "out$i=1.0"
			}
		)!
	)

}

!(
	set CarrierEquations ""
	for {set i 1} {$i<=$stage} {incr i} {
		append CarrierEquations "nmos$i.Electron pmos$i.Hole "
	}
)!


Solve{

   #step 1:  inital solution 
   Poisson #without (contact equation) 
   Coupled{ Poisson !(puts $CarrierEquations)!}
   Coupled{ Poisson !(puts $CarrierEquations)! Contact Circuit }
   
   
   #step 2: prepare: boot
  Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter= Vdd.dc Value= 2.0 }
	 !(
		for {set i 1} {$i< $stage} {incr i} {
				 puts "Goal\{ Node=out$i Voltage= 1.0 \}"
		}
	 )!
  ){
    Coupled { 
      Poisson !(puts $CarrierEquations)! Contact Circuit
    }
  }
  # Quasistationary situation (time-----> long)
  
  #step 3: simulate VTC Curve #
  NewCurrentFile= "RO_"
  Transient (
    InitialTime= 0.0 FinalTime= 1e-9
    InitialStep= 1e-12 Increment= 1.41
    Minstep= 1e-15 MaxStep= 1e-11
  ){
    Coupled {
      Poisson !(puts $CarrierEquations)! Contact Circuit
    }
  } 
  
}
