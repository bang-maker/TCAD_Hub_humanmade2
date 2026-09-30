### 
## input/output files 
File{
  # input the device structure {sprocess}
  Grid      = "n@node|PN@_fps.tdr"  
  # input the parameters of the physics model
  Parameter = "@parameter@"
  # output
  ## plot the variables in the device
  Plot      = "@tdrdat@"
  ## save the variables in the BC,e.g. Current Voltage Charge.
  Current   = "@plot@"
  ## log file
  Output    = "@log@"
}

# BC
Electrode{


}
## optional
Thermode{


}


# physics models
Physics{


}

# 
Math{
 
}


# solve 
# Quasistationary, Transient, AC analysis
Solve{



}

# plot
Plot{
	

}



