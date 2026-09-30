# this code was created by Lanxiaomu

System{
	Resistor_pset r1 (in out) {resistance= 10}
	Capacitor_pset c1 (out gnd) {capacitance = 1e-9}
	# dc power 
	Vsource_pset vin (in gnd) {dc = 0.0}
	Vsource_pset vout (out gnd) {dc = 0.0}
	Vsource_pset vgnd (gnd 0 ) {dc = 0.0}
}

File{
	Output = "@log@"
	ACExtract = "n@node@"	
}

Solve{

	ACCoupled(
		StartFrequency = 1e3 EndFrequency=1e3 NumberOfPoints = 1 Decade
		#
		Node( in out gnd )
		#
		Exclude(vin vout vgnd)
	){
		Circuit	
	}
 
}