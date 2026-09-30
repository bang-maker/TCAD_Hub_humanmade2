#setdep  @previous@


# dataset 
load_file ./IcVce_n@node|IcVce@_des.plt -name  dataset_IcVce_n@node@
# plot
if { [lsearch [list_plots] plot_IcVce ]== -1} {
	create_plot -1d -name plot_IcVce
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "NPN BJT"
	set common_text_curve "NPN BJT"
}



select_plots {plot_IcVce}

 # create curves 
create_curve -plot plot_IcVce -dataset {dataset_IcVce_n@node@} -axisX {collector OuterVoltage} -axisY {collector TotalCurrent} -name curve_Ic_n@node@
 
 

set_curve_prop -plot plot_IcVce {curve_Ic_n@node@} -label "$legend_text_curve"
# set_curve_prop -plot plot_IcVce {curve_Ib_n@node@} -label "I<sub>B</sub> $legend_text_curve"
 



# line width 
set_curve_prop -plot plot_IcVce {curve_Ic_n@node@} -line_width 3
 

# color 
set COLORS  [list green blue red orange magenta violet brown #008000 ] 
set i_experiment @node:index@
set Color_Length [llength $COLORS]
set color_now [lindex $COLORS [expr $i_experiment%$Color_Length]] 

set_curve_prop -plot plot_IcVce {curve_Ic_n@node@  } -color $color_now
 

# axis - text 
set_axis_prop -plot plot_IcVce -axis x -title "Collector-Emitter Voltage, V<sub>CE</sub> \[V\]"
set_axis_prop -plot plot_IcVce -axis y -title "Collector Current, I<sub>C</sub> \[A/<greek>m</greek>m\]"
# set_axis_prop -plot plot_IcVce -axis y2 -title "Transconductance, G<sub>m</sub> \[S\]"


# title text 
set_plot_prop -plot {plot_IcVce} -title " Ic-Vce Curve "
set_axis_prop -plot plot_IcVce -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IcVce -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IcVce -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal

set_axis_prop -plot plot_IcVce -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IcVce -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IcVce -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal

set_plot_prop -plot {plot_IcVce} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal


load_library extract

 