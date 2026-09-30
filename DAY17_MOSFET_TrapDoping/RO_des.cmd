
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
	ExitOnFailure
	Iterations = 15
	Transient= BE
}

System{
	Vsource_pset Vdd (dd 0) {dc = 0.0}
	Vsource_pset Vss (ss 0) {dc = 0.0}
	#stage 1
	NMOS nmos1 (source=ss drain=out1 gate=out3 substrate=ss)
	PMOS pmos1 (source=dd drain=out1 gate=out3 substrate=ss)
	#stage 2
	NMOS nmos2 (source=ss drain=out2 gate=out1 substrate=ss)
	PMOS pmos2 (source=dd drain=out2 gate=out1 substrate=ss)
	
	#stage 3
	NMOS nmos3 (source=ss drain=out3 gate=out2 substrate=ss)
	PMOS pmos3 (source=dd drain=out3 gate=out2 substrate=ss)
 
	
	Plot "n@node@_sys_des.plt" (time() v(dd) v(out1) v(out2) v(out3)
								v(nmos1 out1) v(nmos2 out2) v(nmos3 out3)
								v(pmos1 out1) v(pmos2 out2) v(pmos3 out3)
							   )
}


Solve{  
  NewCurrentPrefix="init_"
  Coupled{ Poisson    }
  Coupled{ Poisson nmos1.Electron pmos1.Hole nmos2.Electron pmos2.Hole nmos3.Electron pmos3.Hole  }
  Coupled{ Poisson nmos1.Electron pmos1.Hole nmos2.Electron pmos2.Hole nmos3.Electron pmos3.Hole Contact Circuit }

  Quasistationary( 
     InitialStep=1e-3 Increment=1.35 
     MinStep=1e-5 MaxStep=0.1 
     Goal{ Parameter=Vdd.dc Voltage= 2.0 }
     Goal{ Node=out1 Voltage= 1.0 }
     Goal{ Node=out2 Voltage= 1.0 }
     #Goal{ Node=out3 Voltage= 1.0 }
  ){ Coupled{ Poisson nmos1.Electron pmos1.Hole nmos2.Electron pmos2.Hole nmos3.Electron pmos3.Hole Contact Circuit}
  }

  NewCurrentPrefix="RO_"
  Transient (
    InitialTime= 0 FinalTime= 4e-10
    InitialStep= 1e-11 Increment= 1.41
    Minstep= 1e-15 MaxStep= 1e-11
  ){
    Coupled {
      Poisson nmos1.Electron pmos1.Hole nmos2.Electron pmos2.Hole nmos3.Electron pmos3.Hole Contact Circuit
    }
  }
 
}




