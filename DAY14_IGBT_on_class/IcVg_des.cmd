#set ni @[format "%.2e" [expr 9.38e19*(@Temp@/300.0)*(@Temp@/300)*exp(-6884.0/@Temp@)]]@
#if @IcVg@ == 0
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
   { Name="Collector" Voltage= 0 Resist= 1e-3 }
}

Thermode {
   { Name="Gate"      Temperature= @Temp@ }
   { Name="Emitter"   Temperature= @Temp@ }
   { Name="Collector" Temperature= @Temp@ }
}

Physics {
   Temperature= @Temp@
   EffectiveIntrinsicDensity(BandGapNarrowing(Slotboom))
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
      * Avalanche (Lackner)
   )      
}

Insert= "PlotSection_des.cmd" # sdevice command  : exec at sdevice   @var@ is not valid!
#include "MathSection_des.cmd" 
   # #include----> swb preprocess command: exec at preprocess  @var@

Solve {
   Poisson
   Coupled { Poisson Electron Hole }

   Quasistationary (
      InitialStep= 1e-2 Increment= 2.0 Decrement= 1.5
      MinStep= 1e-8 MaxStep= 0.5
      Goal { Name= Collector Value=@Vc@ }
   ){ Coupled { Poisson Electron Hole Temperature } }	

   NewCurrentPrefix="IcVg_"
   Quasistationary (
      InitialStep= 1e-2 Increment= 2.0 Decrement= 1.5
      MinStep= 1e-8 MaxStep= 0.05
      Goal { Name= Gate Value=@Vg@ }
   ){ Coupled { Poisson Electron Hole Temperature } }
}

