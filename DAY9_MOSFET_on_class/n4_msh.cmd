Title "Untitled"

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	Constant "CP.Channel" {
		Species = "BoronActiveConcentration"
		Value = 1e+15
	}
	AnalyticalProfile "DD.GaussLDD" {
		Species = "PhosphorusActiveConcentration"
		Function = Gauss(PeakPos = 0, PeakVal = 1e+17, ValueAtDepth = 1e+15, Depth = 0.05)
		LateralFunction = Gauss(Factor = 1)
	}
	AnalyticalProfile "DD.GaussSD" {
		Species = "PhosphorusActiveConcentration"
		Function = Gauss(PeakPos = 0, PeakVal = 1e+20, ValueAtDepth = 1e+15, Depth = 0.1)
		LateralFunction = Gauss(Factor = 0.8)
	}
	Refinement "RD.Global" {
		MaxElementSize = ( 0.1 0.1 )
		MinElementSize = ( 0.003 0.003 )
		RefineFunction = MaxTransDiff(Variable = "DopingConcentration",Value = 1)
		RefineFunction = MaxTransDiff(Variable = "DopingConcentration",Value = 1)
		RefineFunction = MaxLenInt(Interface("R.EPI","R.GateOxide"), Value=0.001, factor=1.5, DoubleSide, UseRegionNames)
		RefineFunction = MaxLenInt(Interface("R.EPI","R.GateOxide"), Value=0.001, factor=1.5, DoubleSide, UseRegionNames)
		RefineFunction = MaxLenInt(Interface("Contact","Silicon"), Value=0.001, factor=1.5)
		RefineFunction = MaxLenInt(Interface("Contact","Silicon"), Value=0.001, factor=1.5)
	}
	Refinement "RD.Channel" {
		MaxElementSize = ( 0.03 1 )
		MinElementSize = ( 0.01 0.01 )
	}
}

Placements {
	Constant "PL.Channel" {
		Reference = "CP.Channel"
		EvaluateWindow {
			Element = material ["Silicon"]
		}
	}
	AnalyticalProfile "PL.SourceLDD" {
		Reference = "DD.GaussLDD"
		ReferenceElement {
			Element = Line [(-0.3 0) (-0.15 0)]
			Direction = positive
		}
	}
	AnalyticalProfile "PL.DrainLDD" {
		Reference = "DD.GaussLDD"
		ReferenceElement {
			Element = Line [(0.3 0) (0.15 0)]
			Direction = negative
		}
	}
	AnalyticalProfile "PL.Source" {
		Reference = "DD.GaussSD"
		ReferenceElement {
			Element = Line [(-0.3 0) (-0.25 0)]
			Direction = positive
		}
	}
	AnalyticalProfile "PL.Drain" {
		Reference = "DD.GaussSD"
		ReferenceElement {
			Element = Line [(0.3 0) (0.25 0)]
			Direction = negative
		}
	}
	Refinement "RPL.Global" {
		Reference = "RD.Global"
		RefineWindow = Rectangle [(-1000 -1000) (1000 1000)]
	}
	Refinement "RPL.Channel" {
		Reference = "RD.Channel"
		RefineWindow = Rectangle [(-0.15 0) (0.15 0.2)]
	}
}

AxisAligned {
	xCuts=(-0.15, 0.15)
	yCuts=(0, 1)
}
