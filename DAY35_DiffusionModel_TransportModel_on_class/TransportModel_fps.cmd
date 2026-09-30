	line x location= 0.0 spacing= 10<nm>  tag= top
	line x location= 0.1 spacing= 10<nm>  
	line x location= 2.0 spacing= 10<nm>  tag= bottom
 
	region Silicon xlo= top xhi= bottom  substrate
	init Silicon  wafer.orient= {0 0 1} notch.direction= {1 1 0} !DelayFullD 
	
	
	
	doping  name= BoronDop field= Boron   depths= "0 0.1" values= "2.0e20 2.0e20"
	doping  name= IntDop field= Int depths= "0 0.1" values= "@IntDop@ @IntDop@ "
	deposit material= { Silicon } doping= {  BoronDop IntDop } type= isotropic thickness= 0.1<um>
	
	
	struct tdr= n@node@_PreDiffuse !gas !interfaces
	
	pdbSet Silicon Boron DiffModel @model@
	
	
	#pdbSet Silicon Boron 		ActiveModel None
	#pdbSet Silicon Vacancy 		ClusterModel None
	#pdbSet Silicon Interstitial 	ClusterModel None
	# selection of the Activation / Cluster model of Boron in Silicon 
	#pdbSet Silicon Boron 		ActiveModel None
	# selection of the Cluster model of Point-Defects in Silicon 
	#pdbSet Silicon Interstitial 	ClusterModel None
	#pdbSet Silicon Vacancy 			ClusterModel None
	#pdbSet Silicon Boron DiffModel  
	#pdbSet Silicon Potential Poisson 0
	
	diffuse temperature= 900<C> time= 10<min>
 
	struct tdr= n@node@_PostDiffuse !gas !interfaces