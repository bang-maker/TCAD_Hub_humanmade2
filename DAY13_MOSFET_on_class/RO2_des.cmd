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
	Iterations= 20
}
 
System {
	* SPICE model/TCAD model + Netlist
	* choice1 : HSPICE netlist (.sp)
	* choice2 : SPICE circuit file (.scf)
	* by command
	
	* stage 1
	NMOS nmos1 (source=ss drain=out1 gate=out3 substrate=ss ) {Physics{Areafactor=1.0}} #w=1.0um 
	PMOS pmos1 (source=dd drain=out1 gate=out3 substrate=ss ) {Physics{Areafactor=1.0}} #w=1.0um
	* stage 2
	NMOS nmos2 (source=ss drain=out2 gate=out1 substrate=ss ) {Physics{Areafactor=1.0}} #w=1.0um 
	PMOS pmos2 (source=dd drain=out2 gate=out1 substrate=ss ) {Physics{Areafactor=1.0}} #w=1.0um
	* stage 3
	NMOS nmos3 (source=ss drain=out3 gate=out2 substrate=ss ) {Physics{Areafactor=1.0}} #w=1.0um 
	PMOS pmos3 (source=dd drain=out3 gate=out2 substrate=ss ) {Physics{Areafactor=1.0}} #w=1.0um

	* write a tcl program to automatically generate sdevice code!
	
	# power supply
	Vsource_pset Vdd 	(dd 0) 	{dc = 0.0} #instance parameter 
	Vsource_pset Vss 	(ss 0) 	{dc = 0.0} #instance parameter 
	#Vsource_pset Vin 	(in 0) 	{dc = 0.0} #instance parameter 
	#Vsource_pset Vout 	(out 0) {dc = 0.0} #instance parameter 
	#save the result at the system nodes
	Plot "n@node@_sys_des.plt" (time() v(dd) v(ss) v(out1) v(out2) v(out3)
									i(nmos1,out1) i(pmos1,out1)
									i(nmos2,out2) i(pmos2,out2)
									i(nmos3,out3) i(pmos3,out3)
								)
	# solution 2							
	Initialize(out1=1.0 out2=1.0 out3=1.0)
 

}

#define _CarreirEquations_ nmos1.Electron nmos2.Electron nmos3.Electron pmos1.Hole pmos2.Hole pmos3.Hole


Solve{

   #step 1:  inital solution 
   Poisson #without (contact equation) 
   Coupled{ Poisson _CarreirEquations_}
   Coupled{ Poisson _CarreirEquations_ Contact Circuit }
   
   
   #step 2: prepare: boot
  Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter= Vdd.dc Value= 2.0 }
    Goal { Node= out1 Value= 1.0 }
    Goal { Node= out2 Value= 1.0 }
    #Goal { Node= out3 Value= 1.0 } #solution 1
  ){
    Coupled { 
      Poisson _CarreirEquations_ Contact Circuit
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
      Poisson _CarreirEquations_ Contact Circuit
    }
  } 
  
}
