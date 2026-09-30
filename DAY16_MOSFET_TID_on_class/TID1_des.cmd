# this was created by Lanxiaomu

#-- compute total dose effect density
!(
set D @<Dose*1e6>@
set Not [expr -3.0e6*$D*$D+7.0e12*$D-5.0e17 ] 
set Nit [expr -0.0012*$D*$D+7.9762e4*$D+7.0e11 ]
set Nstit [expr 1.0e6*$D*$D+2.0e12*$D-1e17 ]
# the relations was got from papers
 
)!


Physics  (Material="HfO2"){
    Charge(    
    	Conc = !(puts $Not)!
    )
}

Physics  (Material="SiO2"){
    Charge(
    
    	Conc = !(puts $Nstit)!
    
    )
}


Physics  (MaterialInterface="HfO2/Silicon"){
    Traps(
    	Donor Level  EnergyMid = 0 fromMidBandGap Conc= !(puts $Nit)!
    )
}

