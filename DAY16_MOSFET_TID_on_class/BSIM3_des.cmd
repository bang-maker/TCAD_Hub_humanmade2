
File{
		Output= "@log@"
		SpicePath=". @pwd@/models/"
 
}


System{
	#if [string match "NMOS" "@type@"]
		my_nmos_pset 		mos (d g s b ) {l=0.30u w=1.0u}
		#define __Vd__ 1.5
		#define __Vg__ 1.5
	#else
		my_pmos_pset 		mos (d g s b ) {l=0.30u w=1.0u}
		#define __Vd__ -1.5
		#define __Vg__ -1.5
	#endif
	Vsource_pset 	Vd (d 0)	{dc = 0.0}
	Vsource_pset 	Vg (g 0)	{dc = 0.0}
	Vsource_pset 	Vs (s 0)	{dc = 0.0}
	Vsource_pset 	Vb (b 0)	{dc = 0.0}
	Plot "Spice_n@node@_des.plt" (v(d) v(g) v(s) v(b) i(mos,d) i(mos,g) i(mos,s) i(Vd d))
	
}


Solve{

  Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter= Vd.dc Voltage= __Vd__ }
    Goal { Parameter= Vg.dc Voltage= 0.0 }
  ){
    Coupled { 
      Circuit
    }
    
  }
  
  
  NewCurrentFile="IdVg_"
  Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter= Vg.dc Value= __Vg__ }
  ){
    Coupled { 
      Circuit
    }
    CurrentPlot(time=(range=(0 1) intervals=50))
  }
 
}