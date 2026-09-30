Physics {
	Fermi
	Areafactor = @W@

}

Physics (material= "Silicon"){
	Mobility ( 
		DopingDependence
		HighFieldSaturation
		Enormal
	)
      Recombination( 
  		SRH (DopingDependence
			ElectricField (
				Lifetime = Hurkx
				DensityCorrection = Local
			)
  		)
  	    
  	    Band2Band
  	    #if [string match "*BV*" "@tool_label@"]
  	    	Avalanche
  	    #endif 
  	    Auger
  	)
    EffectiveIntrinsicDensity (
    	BandGapNarrowing(OldSlotboom)
    )  
 
}

 