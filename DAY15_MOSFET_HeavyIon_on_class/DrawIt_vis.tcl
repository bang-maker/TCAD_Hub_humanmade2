# created by Lanxiaomu
#setdep  @previous@


# dataset 
load_file ./HeavyIon_n@node|HeavyIon@_des.plt -name  dataset_It_n@node@
# plot
if { [lsearch [list_plots] plot_It ]== -1} {
	create_plot -1d -name plot_It
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "@type@"
	set common_text_curve "@type@"
}



select_plots {plot_It}

 
create_curve -plot plot_It -dataset {dataset_It_n@node@} -axisX {time} -axisY {drain TotalCurrent} -name curve_It_n@node@
set_curve_prop -plot plot_It {curve_It_n@node@} -label "I-t :$legend_text_curve"
set_axis_prop -plot plot_It -axis y -type log



# line width 
set_curve_prop -plot plot_It {curve_It_n@node@} -line_width 3


# color 
set COLORS  [list green blue red orange magenta violet brown #008000 ] 
set i_experiment @node:index@
set Color_Length [llength $COLORS]
set color_now [lindex $COLORS [expr $i_experiment%$Color_Length]] 

set_curve_prop -plot plot_It {curve_It_n@node@} -color $color_now
 

# axis - text 
set_axis_prop -plot plot_It -axis x -title "Time, t \[s\]"
set_axis_prop -plot plot_It -axis y -title "Drain Current, I<sub>DS</sub> \[A/<greek>m</greek>m\]"
 


# title text 
set_plot_prop -plot {plot_It} -title " I-t Curve $common_text_curve"
set_axis_prop -plot plot_It -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_It -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
 
set_axis_prop -plot plot_It -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_It -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
 
set_plot_prop -plot {plot_It} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
