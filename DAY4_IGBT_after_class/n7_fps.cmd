
line x location= 0.0      spacing=  1<nm> tag= SiTop       
line x location= 10<nm>   spacing=  2<nm>                 
line x location= 50<nm>   spacing= 10<nm>                  
line x location= 300<nm>  spacing= 20<nm>                  
line x location= 0.5<um>  spacing= 50<nm>                  
line x location= 10.0<um>  spacing= 0.2<um> tag= SiBottom    



region Silicon xlo= SiTop xhi= SiBottom 



init concentration= 0<cm-3> field= Arsenic 
AdvancedCalibration


grid set.min.normal.size= 3<nm> set.normal.growth.ratio.2d= 1.4


 

deposit material= {Oxide} type= isotropic time= 1.0 rate= {0.01}
 


implant Boron energy= 100<keV> dose= 5e13<cm-2> tilt= 7<degree>  rotation= 0<degree>  
implant Boron energy= 200<keV> dose= 5e13<cm-2> tilt= 7<degree>  rotation= 0<degree>  
implant Boron energy= 300<keV> dose= 5e13<cm-2> tilt= 7<degree>  rotation= 0<degree>  
diffuse  temperature= 1030<C> time= 60<min>

strip Oxide

select z= BActive name= BoronActiveConcentration store
SetPlxList {BoronActiveConcentration}
WritePlx   n7_fps.plx

exit


