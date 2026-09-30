Title ""

Controls {
}

IOControls {
	outputFile = "./sdemodel"
	EnableSections
}

QualityReport {
	Material = { "Silicon" } {
		limitMaxConnectivity = 1
		limitMaxNonDelaunay = 2
		limitMinAngle = 3
		limitMinEdgeLength = 4
		limitMinVolume = 5
	}
}

