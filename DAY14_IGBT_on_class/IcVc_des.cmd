#if @IcVc@ == 0
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
     *  Avalanche (Lackner)
   )      
}

Insert = "PlotSection_des.cmd"
#include "MathSection_des.cmd"

Solve {
   Poisson
   Coupled { Poisson Electron Hole }

*- Ramp to gate to Vgmax
   Quasistationary( 
      InitialStep= 1e-2 Increment= 2.0 Decrement= 1.5
      MinStep= 1e-8 MaxStep= 0.5 
      Goal { Name="Gate" Voltage=@Vgmax@ }
   ){ Coupled { Poisson Electron Hole Temperature }
      Save( FilePrefix="IcVc_n@node@" NoOverWrite
!( 
  set TIMES "Time=("
  for { set i 1 } { $i < @NVg@ } { incr i } {
    set dV [expr (@Vgmax@-@Vgmin@)/(@NVg@-1.0)]
    set Time [expr (@Vgmin@ + ($i-1)*$dV)/@Vgmax@]
    append TIMES "[format %.3f ${Time}];"
  }
  set Time 1.0
  append TIMES "[format %.3f ${Time}]) )"
  puts $TIMES
)!
   }

*- Vc sweeps 
!(
  for { set i 0 } { $i < @NVg@ } { incr i } {
    set Number [format "%04d" $i]
    puts "
      NewCurrentFile=\"IcVc_${i}_\" 
      Load(FilePrefix=\"IcVc_n@node@_$Number\")
      Quasistationary( 
         DoZero 
         InitialStep=1e-3 Increment= 2.0 Decrement= 1.5 
         MinStep=1e-8 MaxStep=0.05 
         Goal \{ Name=\"Collector\" Voltage=@Vc@ \}
      )\{ Coupled \{ Poisson Electron Hole Temperature \}
         CurrentPlot( Time=(Range=(0 1) Intervals=20) )
      \}"
  }
)!
}
