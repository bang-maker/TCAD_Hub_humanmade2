#if @BV@ == 0
#noexec
#endif
 
File {
   Grid= "@tdr@" 
   Parameters= "@parameter@"
   Plot= "@tdrdat@"
   Current= "@plot@" 
   Output= "@log@"	
}	

Electrode {
   { Name="Gate"      Voltage= 0 Resist= 1e-3 }
   { Name="Emitter"   Voltage= 0 Resist= 1e-3 }
   { Name="Collector" Voltage= 0 Resistor=@Rc@}
}

Thermode {
   { Name="Gate"      Temperature= @Temp@ }
   { Name="Emitter"   Temperature= @Temp@ }
   { Name="Collector" Temperature= @Temp@ }
}

Physics {
   Temperature= @Temp@
   EffectiveIntrinsicDensity(BandGapNarrowing (Slotboom))
   Thermodynamic
   AnalyticTEP
}

Physics(Material="Silicon"){
  Mobility ( 
      Enormal(IALMob)
      HighFieldSaturation      
   )
   Recombination (
      SRH(DopingDependence TempDependence)
      Auger
      Avalanche (Lackner)
   )      
}

Insert= "PlotSection_des.cmd"
#include "MathSection_des.cmd"

Solve {
   Poisson
   Coupled { Poisson Electron Hole }

   Quasistationary (
      InitialStep= 1e-5 Increment= 2.0 Decrement= 1.5
      MinStep= 1e-9 MaxStep= 0.05
      Goal { Name= Collector Value=@Vcmax@ }
   ){ Coupled { Poisson Electron Hole Temperature} }	
}

