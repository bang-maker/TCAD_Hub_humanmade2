#********this project was created and shared by Lan Xiaomu (wechat:TCAD2017) *********#
#setdep  @previous@


# dataset 
load_file ./IV_n@node|IV@_des.plt -name  dataset_IV_n@node@
# plot
if { [lsearch [list_plots] plot_IV ]== -1} {
	create_plot -1d -name plot_IV
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve " "
	set common_text_curve " "
}



select_plots {plot_IV}

 # create a curve 
create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {top OuterVoltage} -axisY {top TotalCurrent} -name curve_IV_n@node@

 

set_curve_prop -plot plot_IV {curve_IV_n@node@} -label "IV:$legend_text_curve"
# set_axis_prop -plot plot_IV -axis y -type log



# line width 
set_curve_prop -plot plot_IV {curve_IV_n@node@} -line_width 3
 

# color 
set COLORS  [list green blue red orange magenta violet brown #008000 ] 
set i_experiment @node:index@
set Color_Length [llength $COLORS]
set color_now [lindex $COLORS [expr $i_experiment%$Color_Length]] 

set_curve_prop -plot plot_IV {curve_IV_n@node@} -color $color_now
 

# axis - text 
set_axis_prop -plot plot_IV -axis x -title "TOP Voltage, V<sub>TOP</sub> \[V\]"
set_axis_prop -plot plot_IV -axis y -title "TOP Current, I<sub>TOP</sub> \[A/<greek>m</greek>m\]"
 


# title text 
set_plot_prop -plot {plot_IV} -title " IV Curve $common_text_curve"
set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
 
set_axis_prop -plot plot_IV -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IV -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
 
set_plot_prop -plot {plot_IV} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal

 
