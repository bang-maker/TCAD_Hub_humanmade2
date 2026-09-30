# tcl : tool command language
# svisual sdevice
# sprocess: modified tcl

##set a 10
##standard tcl
#thickness= [expr $a/2.0]
#modified tcl in sprocess 
#thickness= $a/2.0

#standard tcl
#{ $a }  
#= { $a }
#modified tcl in sprocess 
#{ $a } 
#= "{ $a }" = { [expr $a] }
#{ $a 1.0 2.0 $a/2.0 }

#etch thickness= $a/2.0 
#etch material= { Silicon Oxide }

#energy= 120<keV>

#thickness= 1.0<um> 



#########################################################
## 2018 svisual default:UCS 
math coord.ucs
math numThreads= 4

pdbSet InfoDefault 0

#create simulation region Grid + Region
# Grid 
line x location= 0.0<um> 	spacing= 1.0<nm> tag= SiTop
line x location= 10.0<nm> 	spacing= 10.0<nm>  
line x location= 500.0<nm> 	spacing= 50.0<nm>  
line x location= 1.0<um> 	spacing= 0.1<um>
line x location= 2.0<um> 	spacing= 0.1<um> tag= SiBottom
# Region
region Silicon xlo= SiTop  xhi= SiBottom substrate
# SOI
# line x location= 0.0<um> tag= SiTop
# line x location= 1.0<um> tag= SiOxTop
# line x location= 2.0<um> tag= SiOxBottom
# line x location= 3.0<um> tag= SiBulk

# region Silicon xlo= SiOxBottom  	xhi= SiBulk substrate
# region Silicon xlo= SiOxTop  		xhi= SiOxBottom 
# region Silicon xlo= SiTop  		xhi= SiOxTop 

# init
init concentration= 1.0e15<cm-3> field= Boron
# init resistivity= 0.1 

#AdvCalibration
AdvancedCalibration

# mesh settings 
grid set.min.normal.size= 3<nm> set.normal.growth.ratio.2d= 1.4

#diffuse temperature= 900<C> time= 40<min> O2
#diffuse temperature= 900<C> time= 40<min> H2O
gas_flow name= O2_1_N2_1 pressure= 1<atm> flowO2= 1.2<l/min> flowN2= 1.0<l/min>
diffuse temperature= 900<C> time= 40<min> gas.flow= O2_1_N2_1 info= 1
# extract oxide thickness

select z=1
set layersinfo [layers]
puts $layersinfo
set line1 [lindex $layersinfo 0]
set line2 [lindex $layersinfo 1]
set line3 [lindex $layersinfo 2]
puts $line2
set OxTop [lindex $line2 0]
set OxBottom [lindex $line2 1]
set OxThickness [expr $OxBottom-$OxTop]
puts "DOE: Tox [format %.3f [expr 1.0e3*$OxThickness]]"

#method2 
set Tox2 [interface Oxide thickness]
puts "DOE: Tox2 [format %.3f [expr 1.0e3*$Tox2]]"
 
implant Arsenic energy= 30<keV> dose= 1e14<cm-2> tilt= 0<degree> rotation= 0<degree>

SetPlxList { AsActive BActive AsTotal BTotal }
WritePlx n@node@_pre_anneal.plx 

diffuse temperature= 1000<C> time= 30<min>
set SR [SheetResistance]
set NTYPE_SR [lindex $SR 0]
set id 0
foreach word $NTYPE_SR {
	puts "$id:  $word"
	incr id
}

set Xj [lindex $NTYPE_SR 25]
set sheetR [lindex $NTYPE_SR 9]

puts "DOE: Xj $Xj"
puts "DOE: sheetR $sheetR"
 
strip Oxide

##define contact 
contact name= P bottom 
contact name= N box xlo= 0<um> xhi= 1<um> Silicon adjacent.material= Gas
#left right front back top bottom


SetPlxList { NetActive AsActive BActive AsTotal BTotal }
WritePlx n@node@_final.plx 
 
struct tdr= n@node@ !Gas
 