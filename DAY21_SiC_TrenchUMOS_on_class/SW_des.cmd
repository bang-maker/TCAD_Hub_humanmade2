## Tool: Sentaurus Device 
## Characteristics: Switching with inductive load. Using the body diode.
## Dependency: Should be run after the process simulation of NMOS device
#setdep @node|NMOS@

Device NMOS {
    #include "init_nmos_des.cmd"
}




File {
   Output  = "@log@"	
}

Math {	
	Digits= 5
	Rhsmin= 1e-3
	CheckRhsAfterUpdate
	
	ErrEff(electron)= 1e5
	ErrEff(hole)= 1e5
	
	RHSmax= 1e30
	RHSFactor= 1e30	
	Notdamped= 20
	Iterations= 18
	
	ExitOnFailure
	ExtendedPrecision(80)		
	TensorGridAniso(aniso)
	NumberofThreads= 4
	Method= Blocked
	SubMethod= ILS(set= 12)
    ILSrc= "
      set (12) {      
      iterative(gmres(150), tolrel=1e-9, tolunprec=1e-6, tolabs=0, maxit=300);
      preconditioning(ilut(1e-6,-1), left);
      ordering(symmetric=nd, nonsymmetric=mpsilst);
      options(compact=yes, linscale=0, refineresidual=10, verbose=0);
    };"  
	
    Transient= BE
	
}

#define tdi 1e-6
#define tr 10e-09
#define tf 10e-09
#define tfirst @<Ldsw*Idc/Vdc>@

System {
   NMOS MOS1 (source=2 gate=2 drain=3){
   File{
        Current    = "n@node@_mos1_des.plt" 
       }}
   NMOS MOS2 (source=0 gate=1 drain=2){
   File{
        Current    = "n@node@_mos2_des.plt" 
       }}
          
   Inductor_pset Ll  (2 3) {inductance= @Ldsw@ }
   
   Vsource_pset Vdd (3 0) { dc = 0 }
   Vsource_pset vg  (11 0) { pwl = (
   		   0    				    0.0 
   		   @<tdi>@				    0.0
   		   @<tdi+tr>@				@Vg@
   		   @<tdi+tr+tfirst>@        @Vg@
   		   @<tdi+tr+tfirst+tf>@     0.0
   		   @<tdi+tr+(1.5*tfirst)+tf>@     0.0
   		   @<tdi+(2*tr)+(1.5*tfirst)+tf>@     @Vg@
   		   @<tdi+(2*tr)+(2.0*tfirst)+tf>@     @Vg@
   		   @<tdi+(2*tr)+(2.0*tfirst)+(2*tf)>@     0.0
   		   @<tdi+(2*tr)+(4.0*tfirst)+(2*tf)>@     0.0
   			)}
   			
   Resistor_pset rg (11 1) {resistance= @Rgsw@}

   Plot "n@node@_sys_des.plt" (time() v(11) v(2) i(MOS1,4) 
   		i(MOS1,3) i(MOS2,2) i(MOS2,1) i(Ll,3) i(Ll,4))
}

Solve {

   Coupled (Iterations=1000){ Poisson }
   Coupled (Iterations=1000){ Poisson Electron  }
   Coupled (Iterations=100){ Poisson Electron Hole }

   Quasistationary( 
   InitialStep= 1e-6 MinStep= 1e-10 MaxStep= 1.0
   Increment= 1.2 Decrement= 1.5
   Goal { Parameter=Vdd.dc Voltage= @Vdc@ } 	      	      
   ){ Coupled { Poisson Electron Hole  }  }   
	
   NewCurrentPrefix="SW_" 

   Transient (
      InitialTime=0 FinalTime= @<tdi+(2*tr)+(4.0*tfirst)+(2*tf)>@
      InitialStep= 1e-9 Increment=1.2 Decrement=2.0
      MinStep= 1e-15 MaxStep= @<tfirst/10.0>@
   ){ Coupled { Poisson Electron Hole  }
   }

}

