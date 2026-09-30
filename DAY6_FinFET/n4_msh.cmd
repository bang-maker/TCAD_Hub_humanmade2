Title "Untitled"

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	Constant "SD_Dop" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+20
	}
	Refinement "R.Global" {
		MaxElementSize = ( 0.024 0.0112 0.032 )
		MinElementSize = ( 0.0096 0.00448 0.00448 )
		RefineFunction = MaxLenInt(Interface("Silicon","SiO2"), Value=0.0032, factor=1.5)
		RefineFunction = MaxLenInt(Interface("Silicon","Silicon"), Value=0.0064, factor=1.5, DoubleSide)
		RefineFunction = MaxLenInt(Interface("Silicon","HfO2"), Value=0.00064, factor=1.5, DoubleSide)
	}
	Refinement "RD.channel" {
		MaxElementSize = ( 0.0048 0.00448 0.0096 )
		MinElementSize = ( 0.0024 0.00224 0.0064 )
	}
	Refinement "RD.source" {
		MaxElementSize = ( 0.0096 0.0056 0.0128 )
		MinElementSize = ( 0.0048 0.00336 0.0096 )
	}
	Refinement "RD.drain" {
		MaxElementSize = ( 0.0096 0.0056 0.0128 )
		MinElementSize = ( 0.0048 0.00336 0.0096 )
	}
}

Placements {
	Constant "Source_Dop_PL" {
		Reference = "SD_Dop"
		EvaluateWindow {
			Element = region ["R.source"]
		}
	}
	Constant "Drain_Dop_PL" {
		Reference = "SD_Dop"
		EvaluateWindow {
			Element = region ["R.drain"]
		}
	}
	Refinement "P.Global" {
		Reference = "R.Global"
		RefineWindow = Cuboid [(-1 -1 -1) (1 1 1)]
	}
	Refinement "PL.channel" {
		Reference = "RD.channel"
		RefineWindow = Cuboid [(0 -0.007 0) (0.03 0.007 0.04)]
	}
	Refinement "PL.source" {
		Reference = "RD.source"
		RefineWindow = Cuboid [(-0.015 -0.007 0) (0 0.007 0.04)]
	}
	Refinement "PL.drain" {
		Reference = "RD.drain"
		RefineWindow = Cuboid [(0.03 -0.007 0) (0.045 0.007 0.04)]
	}
}

