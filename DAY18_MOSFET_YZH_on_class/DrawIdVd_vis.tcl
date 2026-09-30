#setdep @previous@
load_file ./IdVd_Vg1_n@node|IdVd@_des.plt -name dataset_IV1_n@node@
load_file ./IdVd_Vg2_n@node|IdVd@_des.plt -name dataset_IV2_n@node@
load_file ./IdVd_Vg3_n@node|IdVd@_des.plt -name dataset_IV3_n@node@

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
	set curve_label "@type@"
	set common_label "IdVg"
}

select_plots {plot_IV}   

 

create_curve -plot plot_IV -dataset {dataset_IV1_n@node@} -axisX {drain OuterVoltage} \ 
-axisY {drain TotalCurrent} -name curve_IV1_n@node@
create_curve -plot plot_IV -dataset {dataset_IV2_n@node@} -axisX {drain OuterVoltage} \
-axisY {drain TotalCurrent} -name curve_IV2_n@node@
create_curve -plot plot_IV -dataset {dataset_IV3_n@node@} -axisX {drain OuterVoltage} \
-axisY {drain TotalCurrent} -name curve_IV3_n@node@


 
set_curve_prop -plot plot_IV {curve_IV1_n@node@ curve_IV2_n@node@ curve_IV3_n@node@} -line_width 5
set_curve_prop -plot plot_IV {curve_IV1_n@node@} -label "V<sub>GS</sub>= 0.50V:$curve_label" -color $color    -line_style dash
set_curve_prop -plot plot_IV {curve_IV2_n@node@} -label "V<sub>GS</sub>= 0.75V:$curve_label" -color $color    -line_style dot
set_curve_prop -plot plot_IV {curve_IV3_n@node@} -label "V<sub>GS</sub>= 1.00V:$curve_label" -color $color  

set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis x -title "Drain Voltage, V<sub>DS</sub> \[V\]"

set_axis_prop -plot plot_IV -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y -title "Drain Current, I<sub>DS</sub> \[A/<greek>m</greek>m\]"

set_plot_prop -plot {plot_IV} -title "@type@ I<sub>DS</sub>V<sub>DS</sub> Curve ($common_label)"

 
set_window_full -on
 
 