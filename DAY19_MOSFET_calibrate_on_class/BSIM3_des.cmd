#*******
#Device{
#}


File{
	Output="@log@"
	SPICEPath= "./my_spice_model/"
}


System{  # tox is not a instance parameter
	
	#if [string match "NMOS" "@type@"]
	my_nmos_pset mos (d g s b) { l=@Lgate@u w=1.0u }
	#else  
	my_pmos_pset mos (d g s b) { l=@Lgate@u w=1.0u }
	#endif
 
	#power 
	Vsource_pset 	Vd (d 0)	{dc = 0.0}
	Vsource_pset 	Vg (g 0)	{dc = 0.0}
	Vsource_pset 	Vs (s 0)	{dc = 0.0}
	Vsource_pset 	Vb (b 0)	{dc = 0.0}
	
	Plot "n@node@_des.plt" (time() v(g) v(d) v(s) v(b) i(mos,d) i(mos,s) i(mos,g) i(mos,b))

}

Solve{
	Circuit

	#if [string match "NMOS" "@type@"]
		#define _Vg_ 1.5
		#define _Vd_ 1.5
	#else
		#define _Vg_ -1.5
		#define _Vd_ -1.5
	#endif 
	
 
  Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.2
    Goal { Parameter= Vd.dc Value= _Vd_ }
    Goal { Parameter= Vg.dc Value= 0 }
  ){
    Coupled { 
    	Circuit
    }
  }
  
  NewCurrentFile="IdVg_"
    Quasistationary ( 
    InitialStep= 1e-2 Increment= 1.41
    MinStep= 1e-7     MaxStep= 0.02
    Goal { Parameter= Vg.dc Value= _Vg_ }
  ){
    Coupled { 
    	Circuit
    }
  }
   
}