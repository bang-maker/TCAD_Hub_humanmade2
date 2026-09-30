#setdep  @previous@


# dataset 
load_file ./switch_n@node|switch@_sys_des.plt -name  dataset_VTC_n@node@
# plot
if { [lsearch [list_plots] plot_VTC ]== -1} {
	create_plot -1d -name plot_VTC
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "@type@"
	set common_text_curve "@type@"
}



select_plots {plot_VTC}


# create a curve 
create_curve -plot plot_VTC -dataset {dataset_VTC_n@node@} -axisX {time} -axisY {v(out)} -name curve_VTC_n@node@
create_curve -plot plot_VTC -dataset {dataset_VTC_n@node@} -axisX {time} -axisY {v(in)} -name curve_VTC_i_n@node@ 

set_curve_prop -plot plot_VTC {curve_VTC_n@node@}   -label "V<sub>OUT<sub> $legend_text_curve"
set_curve_prop -plot plot_VTC {curve_VTC_i_n@node@} -label "V<sub>IN<sub>  $legend_text_curve"
 

# line width 
set_curve_prop -plot plot_VTC {curve_VTC_n@node@} -line_width 3
set_curve_prop -plot plot_VTC {curve_VTC_i_n@node@} -line_width 3 
set_curve_prop -plot plot_VTC {curve_VTC_i_n@node@} -line_style dash

 
set_curve_prop -plot plot_VTC { curve_VTC_n@node@ } -color green
set_curve_prop -plot plot_VTC { curve_VTC_i_n@node@ } -color red

# axis - text 
set_axis_prop -plot plot_VTC -axis x -title "time, t \[s\]"
set_axis_prop -plot plot_VTC -axis y -title "Node Voltage, V \[V\]"

# title text 
set_plot_prop -plot {plot_VTC} -title "V-t Curve $common_text_curve"
set_axis_prop -plot plot_VTC -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_VTC -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_VTC -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal 

set_axis_prop -plot plot_VTC -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_VTC -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_VTC -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal 
set_plot_prop -plot {plot_VTC} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal


 

 
