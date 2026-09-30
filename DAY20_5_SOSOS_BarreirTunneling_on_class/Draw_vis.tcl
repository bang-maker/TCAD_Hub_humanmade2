#setdep @previous@
load_file ./IV_n@node|IV@_des.plt -name dataset_IV_n@node@

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


 
create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {top InnerVoltage} -axisY {top TotalCurrent} -name curve_IV_n@node@

# set_axis_prop -plot plot_IV -axis y -type log
set_curve_prop -plot plot_IV {curve_IV_n@node@} -line_width 5
set_curve_prop -plot plot_IV {curve_IV_n@node@} -label "IV:$curve_label" -color $color  

set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis x -title "Schottky electrode Voltage, V<sub>P</sub> \[V\]"

set_axis_prop -plot plot_IV -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y -title "Schottky electrode Current, I<sub>P</sub> \[A/<greek>m</greek>m\]"

set_plot_prop -plot {plot_IV} -title " IV Curve ($common_label)"
 

 