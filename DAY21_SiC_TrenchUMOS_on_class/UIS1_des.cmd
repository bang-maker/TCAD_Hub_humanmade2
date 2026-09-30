############################################################################
#    
# UIS Curve Simulation
#
############################################################################

#-- TCL Script for variables
!( 
   set half_cell 0.4   
    
   set EQNS1  "Poisson Electron Hole"
   set EQNS2  "Poisson Electron Hole Temperature"
   set PULSE  "0 0 1.0e-8 @VgMax@ [expr @Tw@+1.0e-8] @VgMax@ [expr @Tw@+2.0e-8] 0 1 0"
   set RESIST "[expr 2.1*1e-3*@AF@]"
   set TEMPF  "[expr 25+275]"
)!
                                                 
Device UMOS {
 File {
   Grid=   "@tdr@"
   Parameters= "@parameter@"
   Plot=   "@tdrdat@"
   Current="@plot@"
 }

 Electrode {
   { Name= "gate"   Voltage= 0 }
   { Name= "source" Voltage= 0 }
   { Name= "drain"  Voltage= 0 Resist=!(puts $RESIST)! }
 }

 Thermode {
   { Name= "gate"   Temperature=!(puts $TEMPF)! surfaceresistance= 7.5e4} 
   { Name= "source" Temperature=!(puts $TEMPF)! surfaceresistance= 5.5e1} 
   { Name= "drain"  Temperature=!(puts $TEMPF)! surfaceresistance= 5.5e1} 
 }
 
 Physics{
   Temperature=!(puts $TEMPF)!
   AreaFactor=@AF@
   EffectiveIntrinsicDensity( OldSlotboom ) 
   Thermodynamic
   AnalyticTEP    
 }

 Physics(Material= "Silicon"){
  Mobility ( 
      Enormal(IALMob)
      HighFieldSaturation      
   )
   Recombination( SRH(DopingDep ExpTemperatureDependence) Auger Avalanche(UniBo))
 }


}

File {
   Output= "@log@"
   ACExtract= "@acplot@"
}

Math {
   Extrapolate
   Notdamped= 50
   Iterations= 20
   ExitOnFailure
   Digits=8
   *Number_Of_Threads= 8
   Transient= BE
   Method= Blocked
   BreakCriteria { LatticeTemperature ( maxval= 1687 ) }		# 1687
}

System {
   UMOS nmos (source=s  gate=g drain=d)
   Vsource_pset vd  (nd 0) { dc = 0 }
   Vsource_pset vs  (s 0)  { dc = 0 }
   
   Vsource_pset vg  (ng 0) { pwl = (!(puts $PULSE)!)}
   
   Inductor_pset ld (nd d) { inductance = @<Lload>@ }   
   Resistor_pset rg (ng g) { resistance = @<Rg>@ }      #Fiting Parameters
   
   Resistor_pset  ri (ng 0){ resistance = 1e3 }
   Capacitor_pset ci (nd 0){ capacitance=50e-12 }
   
   Plot (time() v(g) v(d) v(nd) v(ng) i(lc d))
   Plot "n@node@_nodeplots" (time() v(g) v(d) v(nd) v(ng) i(ld d))
}

Plot{
*--Density and Currents, etc
   eDensity hDensity
   TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
   * eMobility hMobility
   * eVelocity hVelocity
   eQuasiFermi hQuasiFermi

*--Temperature 
   Temperature
   * eTemperature hTemperature

*--Fields and charges
   ElectricField/Vector Potential SpaceCharge

*--Doping Profiles
   Doping DonorConcentration AcceptorConcentration

*--Generation/Recombination
   SRH Band2Band Auger
   AvalancheGeneration eAvalancheGeneration hAvalancheGeneration

*--Driving forces
   eGradQuasiFermi/Vector hGradQuasiFermi/Vector
   * eEparallel hEparallel eENormal hENormal

*--Band structure/Composition
   BandGap 
   * BandGapNarrowing
   * Affinity
   ConductionBand ValenceBand
   * eQuantumPotential hQuantumPotential

*--Gate Tunneling
   * eBarrierTunneling hBarrierTunneling  BarrierTunneling
   * eDirectTunnel hDirectTunnel

*-- UIS analysis   
   ConductionCurrent EffectiveIntrinsicDensity
}


CurrentPlot {
   
   EffectiveIntrinsicDensity (  
       Maximum( Material= "Silicon"  )
   )

   ConductionCurrent (
       Maximum( Material= "Silicon"  )
   )

   AvalancheGeneration ( 
       Maximum( Material= "Silicon"  )
   )
   
   SpaceCharge (
       Maximum(Name= "Nsc" Window[(-1 1 0) (1 3 0)] )
   )

   eCurrentDensity (
       Maximum(Name= "eDensity" Window[(-1 1 0) (1 3 0)] )
   )

}

Solve {
*- Creating initial guess:
   Poisson
   Coupled { !(puts $EQNS1)! }

   Quasistationary (
      InitialStep= 1e-3 Increment= 1.35
      MinStep= 1e-8 MaxStep= 0.5
      Goal { Parameter= vd.dc  Value= @VddMax@ }
    ){ Coupled {!(puts $EQNS1)!} }
   
    Coupled { !(puts $EQNS2)! }
	
   NewCurrentPrefix="UIS_"
   Transient (
      InitialTime= 0 FinalTime= @<Tw*4.0>@ 
      Increment= 1.25 Decrement= 2.1
      InitialStep= 1e-8  MinStep= 1e-15 MaxStep= @<Tw/50>@
   ){  Coupled { !(puts $EQNS2)! }
     
   }
}



