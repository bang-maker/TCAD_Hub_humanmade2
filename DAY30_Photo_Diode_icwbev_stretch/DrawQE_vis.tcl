#setdep  @previous@


# dataset 
load_file ./PhotoWavelength_n@node|PhotoWavelength@_des.plt -name  dataset_QE_n@node@


# plot
if { [lsearch [list_plots] plot_QE ]== -1} {
	create_plot -1d -name plot_QE
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


 

select_plots {plot_QE}

# create absIds variable


set W1 [expr @Ymax@-@Ymin@]
set W2 @W@
set area [expr $W1*1e-4*$W2*1e-4]
set Intensity @intensity@

set alpha_length [expr $area*$Intensity/1.24] 

create_variable -dataset dataset_QE_n@node@ -function "{100*<N TotalCurrent:dataset_QE_n@node@>/$alpha_length/<Device=,File=CommandFile/Physics,DefaultRegionPhysics,ModelParameter=Optics/Excitation/Wavelength:dataset_QE_n@node@>}" -name QE


# create a curve 
create_curve -plot plot_QE -dataset {dataset_QE_n@node@} -axisX Device=,File=CommandFile/Physics,DefaultRegionPhysics,ModelParameter=Optics/Excitation/Wavelength -axisY {QE} -name curve_QE_n@node@

 

set_curve_prop -plot plot_QE {curve_QE_n@node@} -label "$legend_text_curve"
# set_axis_prop -plot plot_QE -axis y -type log

 
set_curve_prop -plot plot_QE { curve_QE_n@node@} -color $color_now  -show_markers  -line_width 3
 

# axis - text 
set_axis_prop -plot plot_QE -axis x -title "Wavelangth, <greek>l</greek> \[<greek>m</greek>m\]"
set_axis_prop -plot plot_QE -axis y -title "Quantum Efficiency, QE \[%\]"
 

# title text 
set_plot_prop -plot {plot_QE} -title " QE Curve $common_text_curve"
set_axis_prop -plot plot_QE -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_QE -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_QE -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal

set_axis_prop -plot plot_QE -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_QE -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_QE -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal

set_plot_prop -plot {plot_QE} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal

set QE0 [probe_curve {curve_QE_n@node@} -plot plot_QE -valueX @wavelength@]
puts "DOE: QE [format %.3f $QE0]" 














