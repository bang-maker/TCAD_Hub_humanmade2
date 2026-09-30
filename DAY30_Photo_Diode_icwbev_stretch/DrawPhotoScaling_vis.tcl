#setdep  @previous@


# dataset 
load_file ./Intensity_n@node|PhotoIntensityScaling@_des.plt -name  dataset_IV_n@node@


# plot
if { [lsearch [list_plots] plot_IV ]== -1} {
	create_plot -1d -name plot_IV
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "@domain@"
	set common_text_curve "@domain@"
}

# color 
set COLORS  [list green blue red orange magenta violet brown #008000 ] 
set i_experiment @node:index@
set Color_Length [llength $COLORS]
set color_now [lindex $COLORS [expr $i_experiment%$Color_Length]] 


 

select_plots {plot_IV}

# create absIds variable
create_variable -name absIds -dataset dataset_IV_n@node@ -function {<N TotalCurrent:dataset_IV_n@node@>}
create_variable -name intensity -dataset dataset_IV_n@node@  -function {@intensity@*<Device=,File=CommandFile/Physics,DefaultRegionPhysics,ModelParameter=Optics/OpticalGeneration/Scaling:dataset_IV_n@node@>}
 # create a curve 
create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX intensity -axisY {absIds} -name curve_IV_n@node@

 

set_curve_prop -plot plot_IV {curve_IV_n@node@} -label "$legend_text_curve"
# set_axis_prop -plot plot_IV -axis y -type log

 
set_curve_prop -plot plot_IV { curve_IV_n@node@} -color $color_now  -show_markers  -line_width 3
 

# axis - text 
set_axis_prop -plot plot_IV -axis x -title "Intensity, V \[V\]"
set_axis_prop -plot plot_IV -axis y -title "Diode Current, I \[A\]"
 

# title text 
set_plot_prop -plot {plot_IV} -title " IV Curve $common_text_curve"
set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal

set_axis_prop -plot plot_IV -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IV -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IV -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal

set_plot_prop -plot {plot_IV} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal

#Resp 

load_library physicalconstants 
set kB $const::BoltzmannConstant
set h  $const::PlanckConstant
 
set pi $const::Pi
set m0 $const::ElectronMass
set q  $const::ElementaryCharge  

set W1 [expr @Ymax@-@Ymin@] ;# um 
set W2 [expr @W@] ;#um

set area [expr $W1*1e-4*$W2*1e-4] ;# cm

set Intensity @intensity@

set Iphoto_data [get_variable_data "absIds" -dataset dataset_IV_n@node@] 

set Iphoto [lindex $Iphoto_data [expr [llength $Iphoto_data] -1]]

puts "DOE: Iphoto [format %.3e $Iphoto]"

set Resp [expr $Iphoto/(@intensity@*$area)]

puts "DOE: Resp1 [ format %.3f $Resp]"
 