Title "Untitled"

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	Constant "DC.P_PLUS" {
		Species = "BoronConcentration"
		Value = 2e+18
	}
	Constant "DC.SOURCE" {
		Species = "NitrogenConcentration"
		Value = 1e+19
	}
	Constant "DC.DRIFT" {
		Species = "NitrogenConcentration"
		Value = 3e+15
	}
	Constant "DC.SUB" {
		Species = "NitrogenConcentration"
		Value = 1e+19
	}
	Constant "DC.PBASE" {
		Species = "BoronConcentration"
		Value = 2e+17
	}
	Constant "DC.GATE" {
		Species = "PhosphorusConcentration"
		Value = 1e+21
	}
	Constant "DC.GATE_N_MINUS" {
		Species = "NitrogenConcentration"
		Value = 1e+21
	}
	Constant "DC.GATE_P_PLUS" {
		Species = "BoronConcentration"
		Value = 1e+17
	}
	Refinement "Global_RD" {
		MaxElementSize = ( 0.4275 0.55 0 )
		MinElementSize = ( 0.1425 0.18333333333333 0 )
		RefineFunction = MaxLenInt(Interface("All","Oxide"), Value=0.0125, factor=1.3)
		RefineFunction = MaxLenInt(Interface("SiliconCarbide","SiliconCarbide"), Value=0.02, factor=1.2)
		RefineFunction = MaxLenInt(Interface("SiliconCarbide","PolySilicon"), Value=0.02, factor=1.2)
	}
}

Placements {
	Constant "CPM1.P_PLUS" {
		Reference = "DC.P_PLUS"
		EvaluateWindow {
			Element = region ["Reg.P_PLUS"]
		}
	}
	Constant "CPM1.SOURCE" {
		Reference = "DC.SOURCE"
		EvaluateWindow {
			Element = region ["Reg.SOURCE"]
		}
	}
	Constant "CPM1.DRIFT" {
		Reference = "DC.DRIFT"
		EvaluateWindow {
			Element = region ["Reg.DRIFT"]
		}
	}
	Constant "CPM1.SUB" {
		Reference = "DC.SUB"
		EvaluateWindow {
			Element = region ["Reg.SUB"]
		}
	}
	Constant "CPM1.PBASE" {
		Reference = "DC.PBASE"
		EvaluateWindow {
			Element = region ["Reg.PBASE"]
		}
	}
	Constant "CPM1.GATE" {
		Reference = "DC.GATE"
		EvaluateWindow {
			Element = region ["Reg.GATE"]
		}
	}
	Constant "CPM1.GATE_N_MINUS" {
		Reference = "DC.GATE_N_MINUS"
		EvaluateWindow {
			Element = region ["Reg.POLY_SOURCE_N_PLUS"]
		}
	}
	Constant "CPM1.GATE_P_PLUS" {
		Reference = "DC.GATE_P_PLUS"
		EvaluateWindow {
			Element = region ["Reg.POLY_SOURCE_P_MINUS"]
		}
	}
	Refinement "Global_PL" {
		Reference = "Global_RD"
		RefineWindow = Rectangle [(1000 1000) (-1000 -1000)]
	}
}

