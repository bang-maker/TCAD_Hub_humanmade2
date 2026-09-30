#setdep  @previous@


# dataset 
load_file ./BV_n@node|BV@_des.plt -name  dataset_BV_n@node@
# plot
if { [lsearch [list_plots] plot_BV ]== -1} {
	create_plot -1d -name plot_BV
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "@domain@"
	set common_text_curve "@domain@"
}



select_plots {plot_BV}

# create absIds variable
create_variable -name absIds -dataset dataset_BV_n@node@ -function {abs(<N TotalCurrent:dataset_BV_n@node@>)}
# create a curve 
create_curve -plot plot_BV -dataset {dataset_BV_n@node@} -axisX {N InnerVoltage} -axisY {absIds} -name curve_BV_n@node@

 

set_curve_prop -plot plot_BV {curve_BV_n@node@} -label "$legend_text_curve"
set_axis_prop -plot plot_BV -axis y -type log



# line width 
set_curve_prop -plot plot_BV {curve_BV_n@node@} -line_width 3
 
# color 
set COLORS  [list green blue red orange magenta violet brown #008000 ] 
set i_experiment @node:index@
set Color_Length [llength $COLORS]
set color_now [lindex $COLORS [expr $i_experiment%$Color_Length]] 

set_curve_prop -plot plot_BV { curve_BV_n@node@} -color $color_now
 

# axis - text 
set_axis_prop -plot plot_BV -axis x -title "Diode Voltage, V \[V\]"
set_axis_prop -plot plot_BV -axis y -title "Diode Current, I \[A\]"
 

# title text 
set_plot_prop -plot {plot_BV} -title " BV Curve $common_text_curve"
set_axis_prop -plot plot_BV -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_BV -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_BV -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal

set_axis_prop -plot plot_BV -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_BV -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_BV -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal

set_plot_prop -plot {plot_BV} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal


 

