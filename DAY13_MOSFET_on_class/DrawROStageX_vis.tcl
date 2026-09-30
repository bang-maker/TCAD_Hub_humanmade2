#setdep  @previous@


# dataset
load_file ./RO_n@node|ROStageX@_sys_des.plt -name  dataset_RO_n@node@
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

set stage @stage@
for {set i 1} {$i<= $stage} {incr i} {
	create_curve -plot plot_RO -dataset {dataset_RO_n@node@} -axisX {time} -axisY "{v(out$i)}" -name curve_${i}_n@node@
	set_curve_prop -plot plot_RO "{curve_${i}_n@node@}"   -label "V<sub>OUT$i</sub> $legend_text_curve"
	# line width 
	set_curve_prop -plot plot_RO "{curve_${i}_n@node@}" -line_width 3

}
 


 
# axis - text 
set_axis_prop -plot plot_RO -axis x -title "time, t \[s\]"
set_axis_prop -plot plot_RO -axis y -title "Voltage, V<sub>OUT</sub> \[V\]"
 
# title text 
set_plot_prop -plot {plot_RO} -title "RO(stage=@stage@) Curve"
set_axis_prop -plot plot_RO -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_RO -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_RO -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_plot_prop -plot {plot_RO} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal


 

 
