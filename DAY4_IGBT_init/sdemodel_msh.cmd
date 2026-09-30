Title "Untitled"

Controls {
}

IOControls {
	outputFile = "sdemodel"
	EnableSections
}

Definitions {
	AnalyticalProfile "AP.eLifetime" {
		Species = "eLifetime"
		Function = Eval( init = "a=10.0"  function = "-1e-6*exp(-1*y/a)" value = 0.1)
	}
	AnalyticalProfile "AP.hLifetime" {
		Species = "hLifetime"
		Function = Eval( init = "a=10.0"  function = "-1e-6*exp(-1*y/a)" value = 0.1)
	}
	Refinement "global" {
		MaxElementSize = ( 2.5 10 2.5 )
		MinElementSize = ( 0.1 0.1 0.1 )
	}
	Refinement "active_domain" {
		MaxElementSize = ( 2 5 0.5 )
		MinElementSize = ( 0.02 0.02 0.05 )
		RefineFunction = MaxTransDiff(Variable = "DopingConcentration",Value = 1)
		RefineFunction = MaxLenInt(Interface("R.Si","emitter"), Value=0.002, factor=2, UseRegionNames)
		RefineFunction = MaxLenInt(Interface("R.Si","thermo_left"), Value=0.025, factor=2, UseRegionNames)
		RefineFunction = MaxLenInt(Interface("R.Si","thermo_right"), Value=0.025, factor=2, UseRegionNames)
	}
	Refinement "active" {
		MaxElementSize = ( 1 5 1 )
		MinElementSize = ( 0.03 0.02 0.5 )
		RefineFunction = MaxTransDiff(Variable = "DopingConcentration",Value = 1)
	}
}

Placements {
	AnalyticalProfile "Impl.eLifetime" {
		Reference = "AP.eLifetime"
		ReferenceElement {
			Element = Line [(0 0) (4.8 0)]
			Direction = positive
		}
	}
	AnalyticalProfile "Impl.hLifetime" {
		Reference = "AP.hLifetime"
		ReferenceElement {
			Element = Line [(0 0) (4.8 0)]
			Direction = positive
		}
	}
	Refinement "global" {
		Reference = "global"
		RefineWindow = Rectangle [(-100000 -100000) (100000 100000)]
	}
	Refinement "active_domain" {
		Reference = "active_domain"
		RefineWindow = material ["Silicon"]
	}
	Refinement "active" {
		Reference = "active"
		RefineWindow = Rectangle [(0 0) (4.8 70)]
	}
}

