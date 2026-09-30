Title "Untitled"

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	Constant "Const.Substrate" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+15
	}
	AnalyticalProfile "DD.1DExternalEmitter" {
		Function = SubMesh1d(datafile = "n2_fps.plx", scale = 1)
		LateralFunction = Gauss(Factor = 0.1)
	}
	AnalyticalProfile "DD.1DExternalPBody" {
		Function = SubMesh1d(datafile = "n4_fps.plx", scale = 1)
		LateralFunction = Gauss(Factor = 0.15)
	}
	Constant "Const.PolySilicon" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+21
	}
	AnalyticalProfile "Impl.fieldstopprof" {
		Species = "ArsenicActiveConcentration"
		Function = Gauss(PeakPos = 0, PeakVal = 1e+19, ValueAtDepth = 1e+15, Depth = 3)
		LateralFunction = Erf(Length = 0.1)
	}
	AnalyticalProfile "Impl.collectorprof" {
		Species = "BoronActiveConcentration"
		Function = Gauss(PeakPos = 0.1, PeakVal = 1e+20, ValueAtDepth = 1e+17, Depth = 0.5)
		LateralFunction = Erf(Length = 0.1)
	}
	AnalyticalProfile "AP.eLifetime" {
		Species = "eLifetime"
		Function = Eval( init = "a=5.0;b=5e-6"  function = "1e-5-b*exp(-1.0*x/a)" value = 0.1)
	}
	AnalyticalProfile "AP.hLifetime" {
		Species = "hLifetime"
		Function = Eval( init = "a=5.0;b=1e-6"  function = "3e-6-b*exp(-1.0*x/a)" value = 0.1)
	}
	Refinement "RD.Global" {
		MaxElementSize = ( 0.48 7 1 )
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
		RefineFunction = MaxTransDiff(Variable = "eLifetime",Value = 1)
	}
	Refinement "Ref.TrBot" {
		MaxElementSize = ( 0.1 0.5 )
		MinElementSize = ( 0.05 0.05 )
		RefineFunction = MaxTransDiff(Variable = "DopingConcentration",Value = 1)
	}
}

Placements {
	Constant "PlaceCD.Substrate" {
		Reference = "Const.Substrate"
		EvaluateWindow {
			Element = material ["Silicon"]
		}
	}
	AnalyticalProfile "PL.1DExternalEmitter" {
		Reference = "DD.1DExternalEmitter"
		ReferenceElement {
			Element = Line [(2.8 0) (3.6 0)]
		}
	}
	AnalyticalProfile "APL.1DExternalPBody" {
		Reference = "DD.1DExternalPBody"
		ReferenceElement {
			Element = Line [(3.1 0) (4.8 0)]
		}
	}
	Constant "PL.Const.PolySilicon" {
		Reference = "Const.PolySilicon"
		Replace
		EvaluateWindow {
			Element = material ["PolySi"]
		}
	}
	AnalyticalProfile "Impl.fieldstop" {
		Reference = "Impl.fieldstopprof"
		ReferenceElement {
			Element = Line [(0 70) (5 70)]
			Direction = negative
		}
	}
	AnalyticalProfile "Impl.collector" {
		Reference = "Impl.collectorprof"
		ReferenceElement {
			Element = Line [(0 70) (5 70)]
			Direction = negative
		}
	}
	AnalyticalProfile "PL.eLifetime" {
		Reference = "AP.eLifetime"
		ReferenceElement {
			Element = Line [(-10 0) (14.8 0)]
		}
	}
	AnalyticalProfile "PL.hLifetime" {
		Reference = "AP.hLifetime"
		ReferenceElement {
			Element = Line [(-10 0) (14.8 0)]
		}
	}
	Refinement "PL.Global" {
		Reference = "RD.Global"
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
	Refinement "RefPlace.TrBot" {
		Reference = "Ref.TrBot"
		RefineWindow = Rectangle [(1 1.8) (3 4)]
	}
}

Offsetting {

	noffset material "Silicon" {
		maxlevel=10
	}

	noffset region "R.Si" "R.Gox" {
		hlocal=0.0015
		factor=1.5
	}

	noffset region "R.Gox" "R.PolyGate" {
		hlocal=0.01
		factor=1.5
	}

	noffset region "R.Gox" "R.Si" {
		hlocal=0.004
		factor=1.5
	}

	noffset region "R.Si" "R.LOCOS" {
		hlocal=0.005
		factor=1.5
	}

}

