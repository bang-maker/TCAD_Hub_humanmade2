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
			Element = Rectangle [(0 -0.3) (9.8 70)]
			DecayLength = 1
		}
	}
	Refinement "RefinementPlacement_1" {
		Reference = "RefinementDefinition_1"
		RefineWindow = material ["Silicon"]
	}
}

