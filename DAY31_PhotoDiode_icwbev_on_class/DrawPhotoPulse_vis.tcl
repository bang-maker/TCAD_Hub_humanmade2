#setdep  @previous@


# dataset 
load_file ./Optical_Pulse_n@node|PhotoPulse@_des.plt -name  dataset_Pulse_n@node@


# plot
if { [lsearch [list_plots] plot_Pulse ]== -1} {
	create_plot -1d -name plot_Pulse
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
 

select_plots {plot_Pulse}

# create absIds variable
 
create_curve -plot plot_Pulse -dataset {dataset_Pulse_n@node@} -axisX {time} -axisY {N TotalCurrent} -name curve_Pulse_n@node@
 


set_curve_prop -plot plot_Pulse {curve_Pulse_n@node@} -label "$legend_text_curve"
# set_axis_prop -plot plot_Pulse -axis y -type log

 
set_curve_prop -plot plot_Pulse { curve_Pulse_n@node@} -color $color_now   -line_width 3
 

# axis - text 
set_axis_prop -plot plot_Pulse -axis x -title "Time, t \[s\]"
set_axis_prop -plot plot_Pulse -axis y -title "Diode Current, I \[A\]"
 

# title text 
set_plot_prop -plot {plot_Pulse} -title " Pulse Curve $common_text_curve"
set_axis_prop -plot plot_Pulse -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_Pulse -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_Pulse -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal

set_axis_prop -plot plot_Pulse -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_Pulse -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_Pulse -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal

set_plot_prop -plot {plot_Pulse} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
 
