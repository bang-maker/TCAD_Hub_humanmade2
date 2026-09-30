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
		MaxElementSize = ( 1 10 4 )
		MinElementSize = ( 1 1 1 )
		RefineFunction = MaxTransDiff(Variable = "DopingConcentration",Value = 1)
	}
}

Placements {
	SubMesh "ExternalProfilePlacement_1" {
		Reference = "ExternalProfileDefinition_1"
		EvaluateWindow {
			Element = SweepElement  {
				Base = Polygon [(0 -0.3 0) (4.8 -0.3 0) (4.8 70 0) (0 70 0)]
				Distance = 10
			}

			DecayLength = 1
		}
	}
	Refinement "RefinementPlacement_1" {
		Reference = "RefinementDefinition_1"
		RefineWindow = material ["Silicon"]
	}
}

