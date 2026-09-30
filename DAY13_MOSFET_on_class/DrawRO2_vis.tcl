#setdep  @previous@


# dataset 
load_file ./RO_n@node|RO2@_sys_des.plt -name  dataset_RO_n@node@
# plot
if { [lsearch [list_plots] plot_RO ]== -1} {
	create_plot -1d -name plot_RO
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "@type@"
	set common_text_curve "@type@"
}



select_plots {plot_RO}


# create a curve 
create_curve -plot plot_RO -dataset {dataset_RO_n@node@} -axisX {time} -axisY {v(out1)} -name curve_1_n@node@
create_curve -plot plot_RO -dataset {dataset_RO_n@node@} -axisX {time} -axisY {v(out2)} -name curve_2_n@node@
create_curve -plot plot_RO -dataset {dataset_RO_n@node@} -axisX {time} -axisY {v(out3)} -name curve_3_n@node@


set_curve_prop -plot plot_RO {curve_1_n@node@}   -label "V<sub>OUT1</sub> $legend_text_curve"
set_curve_prop -plot plot_RO {curve_2_n@node@}   -label "V<sub>OUT2</sub> $legend_text_curve"
set_curve_prop -plot plot_RO {curve_3_n@node@}   -label "V<sub>OUT3</sub> $legend_text_curve"
 

# line width 
set_curve_prop -plot plot_RO {curve_1_n@node@ curve_2_n@node@ curve_3_n@node@} -line_width 3
 

 
set_curve_prop -plot plot_RO { curve_1_n@node@ } -color green
set_curve_prop -plot plot_RO { curve_2_n@node@ } -color red
set_curve_prop -plot plot_RO { curve_3_n@node@ } -color blue

# axis - text 
set_axis_prop -plot plot_RO -axis x -title "time, t \[s\]"
set_axis_prop -plot plot_RO -axis y -title "Voltage, V<sub>OUT</sub> \[V\]"
 


# title text 
set_plot_prop -plot {plot_RO} -title "VTC Curve $common_text_curve"
set_axis_prop -plot plot_RO -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_RO -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal 

set_axis_prop -plot plot_RO -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_RO -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_plot_prop -plot {plot_RO} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal


 

 
