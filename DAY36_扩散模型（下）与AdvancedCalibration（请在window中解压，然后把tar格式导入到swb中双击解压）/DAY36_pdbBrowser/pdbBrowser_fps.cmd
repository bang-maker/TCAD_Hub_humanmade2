#user-defined function####################### 
fproc puts_pdb {cmd} {
	puts "-------------------"
	puts "COMAND: $cmd"
	puts "VALUE : [eval $cmd]"
}
############################################


############################################
puts "1.0 Date Type"
#switch 
puts_pdb "pdbGet Silicon Boron DiffModel"
puts_pdb "pdbGetSwitchString Silicon Boron DiffModel"

#Double
puts_pdb "pdbGet Silicon Boron Dstar"
puts_pdb "pdbGetDouble Silicon Boron Dstar"
puts_pdb "pdbExprDouble Silicon Boron Dstar"

puts_pdb "pdbGet tempK"
puts_pdb "pdbGetDouble Silicon Boron Dstar"
SetTemp 1000.0 ;# C
puts_pdb "pdbGet tempK"
puts_pdb "pdbGetDouble Silicon Boron Dstar"

#DoubleArray
# {key1 value1 key2 value2 ...}
puts_pdb "pdbGet Silicon Boron Int D"
puts_pdb "pdbGetDoubleArray Silicon Boron Int D"
puts_pdb "pdbGet Silicon Boron Int D 0"
puts_pdb "pdbGetElement Silicon Boron Int D 0"
puts "It's Value is: "
puts "[expr [pdbGetElement Silicon Boron Int D 0]]"
puts "set T = 1200 C"
SetTemp 1200.0
puts "It's Value is: "
puts "[expr [pdbGetElement Silicon Boron Int D 0]]"

#Boolean
puts_pdb "pdbGet Grid Adaptive"
puts_pdb "pdbGetBoolean Grid Adaptive"

 
############################################
puts "2.0 pdbSet pdbGet vs pdbSet* pdbGet*"

puts_pdb "pdbGetDouble Lanxiaomu Class"
puts_pdb "pdbGet Lanxiaomu Class"

############################################
puts "3.0 pdbSet"
pdbSet Silicon Boron Int D {     
								0 {[Arr  1111 2222]}
								1 {[Arr  3333 4444]}
							}

puts_pdb "pdbGet Silicon Boron Int D"

pdbSetDoubleArray Silicon Boron Int D {     
								0 {[Arr  5555 6666]}
								1 {[Arr  7777 8888]}
							}
puts_pdb "pdbGet Silicon Boron Int D"


pdbSetDoubleArray Silicon Boron Int D {     
								0 {[Arr  5555 6666]}
								1 {[Arr  7777 8888]}
							}
puts_pdb "pdbGet Silicon Boron Int D"

#note: missing {}
#pdbSet Silicon Boron Int D {     
#								0 {[Arr  1 2]}
#								1 {[Arr  2 3]}
#							}

############################################
puts "4.0 DiffLimit"
puts_pdb "DiffLimit Silicon Vac 0.0"

 
############################################
puts "5.0 Dopant/Defect Like"

puts_pdb "pdbGet Silicon Boron DiffModel"
pdbSet Silicon Dopant DiffModel Constant
puts_pdb "pdbGet Silicon Boron DiffModel"

# note: Silicon Boron Like Dopant 
# note: Silicon Boron Like Defect

#Dopant DiffModel CharegedPair
#Dopant     D     {0 1 ....}

#Boron Like Dopant/Defect
#Boron D {0 2 ....}

#Arsenic Like Dopant
#Arsenic D {0 3 ....}

############################################
puts "6.0 Interface"

puts_pdb "pdbGet Gas_Silicon Boundary BoundaryCondition"
puts_pdb "pdbGet Gas_Silicon Boundary BoundaryCondition"
pdbSet Gas_Oxide Boundary BoundaryCondition Dirichlet
 

# Note: using pdbSet/pdbGet instand of pdbSet*/pdbGet*

############################################
puts "7.0 Like and New Material"
pdbLike Silicon MyBoron Boron
#pdbSetDoubleArray Silicon MyBoron Int D {     
#								0 {[Arr  5555 6666]}
#								1 {[Arr  7777 8888]}
#							}
mater add name= NEWOxide new.like= Oxide
# TEOS ...GATEOX....

#datexcodes.txt(sdevice)