#setdep @previous@
load_file ./Recovery_n@node|Recovery@_sys_des.plt -name dataset_Rec_n@node@

if { [lsearch [list_plots] plot_IV] == -1} {
	create_plot -1d -name plot_IV
}

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set i @node:index@
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]
 

if [info exists runVisualizerNodesTogether] {
	set curve_label $legend
	set common_label $commonParameters
} else {
	set curve_label "IV"
	set common_label "IV"
}

select_plots {plot_IV}   


 
if { [lsearch [list_curves] curve_RecV] == -1 } {
	create_curve -plot plot_IV -dataset {dataset_Rec_n@node@} -axisX {time} -axisY {v(2)} -name curve_RecV
	set_curve_prop -plot plot_IV {curve_RecV} -line_width 5
	set_curve_prop -plot plot_IV {curve_RecV} -label "Power" -color black 
}

create_curve -plot plot_IV -dataset {dataset_Rec_n@node@} -axisX {time} -axisY2  {i(pn,0)} -name curve_RecI_n@node@
create_curve -plot plot_IV -dataset {dataset_Rec_n@node@} -axisX {time} -axisY  {v(1)} -name curve_RecV_n@node@

set_axis_prop -plot plot_IV -axis y -type linear
set_axis_prop -plot plot_IV -axis y2 -type linear
set_curve_prop -plot plot_IV {curve_RecI_n@node@ curve_RecV_n@node@} -line_width 4
set_curve_prop -plot plot_IV {curve_RecV_n@node@} -line_width 2
set_curve_prop -plot plot_IV {curve_RecI_n@node@}  -label "I<sub>P</sub> $curve_label" -color $color  
set_curve_prop -plot plot_IV {curve_RecV_n@node@} -label "V<sub>P</sub> $curve_label" -color $color  
set_curve_prop -plot plot_IV {curve_RecI_n@node@} -line_style dashdot
set_curve_prop -plot plot_IV {curve_RecV_n@node@} -line_style dash 

set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis x -title "Time, t \[s\]"

set_axis_prop -plot plot_IV -axis y2 -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y2 -title "P electrode Current, I<sub>P</sub> \[A\]"

set_axis_prop -plot plot_IV -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y -title "P electrode Voltage, V<sub>P</sub> \[V\]"

set_plot_prop -plot {plot_IV} -title " Recovery Curve ($common_label)"

set_axis_prop -plot plot_IV -axis x -max 2.15e-7 -max_fixed
set_axis_prop -plot plot_IV -axis x -min 1.95e-7 -min_fixed

set_legend_prop -plot plot_IV -label_font_family arial -label_font_size 13 -label_font_color #000000 -label_font_att {normal bold}
set_axis_prop -plot plot_IV -axis y2 -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att bold
set_axis_prop -plot plot_IV -axis y  -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att bold
set_axis_prop -plot plot_IV -axis x  -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att bold
set_plot_prop -plot {plot_IV} -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att bold
set_axis_prop -plot plot_IV -axis x -scale_format scientific
set_axis_prop -plot plot_IV -axis x -scale_font_family arial -scale_font_size 14 -scale_font_color #000000 -scale_font_att bold
set_axis_prop -plot plot_IV -axis y -scale_font_family arial -scale_font_size 14 -scale_font_color #000000 -scale_font_att bold
set_axis_prop -plot plot_IV -axis y2 -scale_font_family arial -scale_font_size 14 -scale_font_color #000000 -scale_font_att bold
 
 
 

 