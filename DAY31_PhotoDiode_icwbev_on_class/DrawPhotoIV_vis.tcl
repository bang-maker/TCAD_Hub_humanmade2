#setdep  @previous@


# dataset 
load_file ./IV_n@node|PhotoIV@_des.plt -name  dataset_IV_n@node@


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


# plot
if { [lsearch [list_datasets] dataset_IVdark_n@node|IV@ ]== -1} {
	# dataset
	load_file ./IV_n@node|IV@_des.plt -name  dataset_IVdark_n@node|IV@
	# create absIds variable
	create_variable -name Idark -dataset dataset_IVdark_n@node|IV@ -function {-1.0*<N TotalCurrent:dataset_IVdark_n@node|IV@>}
	create_variable -name Vdark -dataset dataset_IVdark_n@node|IV@ -function {-1.0*<N OuterVoltage:dataset_IVdark_n@node|IV@>}

	create_curve -plot plot_IV -dataset {dataset_IVdark_n@node|IV@} -axisX {Vdark} -axisY {Idark} -name curve_IVdark_n@node@
	set_curve_prop -plot plot_IV {curve_IVdark_n@node@} -line_width 3   -label "Dark $legend_text_curve" -color $color_now -line_style dash
}


select_plots {plot_IV}

# create absIds variable
create_variable -name absIds -dataset dataset_IV_n@node@ -function {-1.0*<N TotalCurrent:dataset_IV_n@node@>}
create_variable -name PVoltage -dataset dataset_IV_n@node@ -function {-1.0*<N OuterVoltage:dataset_IV_n@node@>}
# create a curve 
create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {PVoltage} -axisY {absIds} -name curve_IV_n@node@

 

set_curve_prop -plot plot_IV {curve_IV_n@node@} -label "$legend_text_curve"
set_axis_prop -plot plot_IV -axis y -type log



# line width 
set_curve_prop -plot plot_IV {curve_IV_n@node@} -line_width 3
 

set_curve_prop -plot plot_IV { curve_IV_n@node@} -color $color_now
 

# axis - text 
set_axis_prop -plot plot_IV -axis x -title "Diode Voltage, V \[V\]"
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


 

