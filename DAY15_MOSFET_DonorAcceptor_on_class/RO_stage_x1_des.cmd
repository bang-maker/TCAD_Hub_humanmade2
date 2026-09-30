
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

!( 
	set stage @stage@
	
)!


System{
	Vsource_pset Vdd (dd 0) {dc = 0.0}
	Vsource_pset Vss (ss 0) {dc = 0.0}
	!(
		for {set i 1} {$i<= $stage} {incr i} {
			if {$i != 1} {
				puts "NMOS nmos$i (source=ss drain=out$i gate=out[expr $i -1] substrate=ss)"
				puts "PMOS pmos$i (source=dd drain=out$i gate=out[expr $i -1] substrate=ss)"
			} else {
				puts "NMOS nmos$i (source=ss drain=out$i gate=out$stage substrate=ss)"
				puts "PMOS pmos$i (source=dd drain=out$i gate=out$stage substrate=ss)"
			}
		}
	
	)!
	
	Plot "n@node@_sys_des.plt" (time() v(dd) 
			!(
			for {set i 1} {$i<= $stage} {incr i} {
					puts "v(out$i)"
					puts "i(nmos$i out$i)"
					puts "i(pmos$i out$i)"
					}
			)!
		)
 
}

!(
	 set coupld_equations ""
	 for {set i 1} {$i<= $stage} {incr i} {
	 	  append coupld_equations "nmos$i.Electron pmos$i.Hole "
	 }
	
)!


Solve{  
  NewCurrentPrefix="init_"
  Coupled{ Poisson    }
  Coupled{ Poisson !(puts $coupld_equations)!  }
  Coupled{ Poisson !(puts $coupld_equations)! Contact Circuit }

  Quasistationary( 
     InitialStep=1e-3 Increment=1.35 
     MinStep=1e-5 MaxStep=0.1 
     Goal{ Parameter=Vdd.dc Voltage= 2.0 }
     !(
     	for {set i 1} {$i< $stage} {incr i} {
     		     puts "Goal\{ Node=out$i Voltage= 1.0 \}"
     	}
     
     )!
  ){ Coupled{ Poisson !(puts $coupld_equations)! Contact Circuit}
  }

  NewCurrentPrefix="RO_"
  Transient (
    InitialTime= 0 FinalTime= 1e-9
    InitialStep= 1e-11 Increment= 1.41
    Minstep= 1e-15 MaxStep= 1e-11
  ){
    Coupled {
      Poisson !(puts $coupld_equations)! Contact Circuit
    }
  }
 
}




