Title ""

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	SubMesh "ExternalProfileDefinition_1" {
		Geofile = "n6_msh.tdr"
	}
	SubMesh "ExternalProfileDefinition_2" {
		Geofile = "n6_msh.tdr"
	}
	Refinement "RefinementDefinition_1" {
		MaxElementSize = ( 1 10 1 )
		MinElementSize = ( 0.05 0.05 0.05 )
		RefineFunction = MaxTransDiff(Variable = "DopingConcentration",Value = 1)
	}
}

Placements {
	SubMesh "ExternalProfilePlacement_1" {
		Reference = "ExternalProfileDefinition_1"
		EvaluateWindow {
			Element = Rectangle [(0 -0.3) (4.8 70)]
		}
	}
	SubMesh "ExternalProfilePlacement_2" {
		Reference = "ExternalProfileDefinition_2"
		ShiftVector = ( 4.8 0 0 )
		Replace
		EvaluateWindow {
			Element = Rectangle [(4.8 -0.3) (9.6 70)]
		}
	}
	Refinement "RefinementPlacement_1" {
		Reference = "RefinementDefinition_1"
		RefineWindow = material ["Silicon"]
	}
}

