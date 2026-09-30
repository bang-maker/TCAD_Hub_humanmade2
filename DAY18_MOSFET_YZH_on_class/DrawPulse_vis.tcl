#setdep @previous@
load_file ./Trans_n@node|GatePulse@_des.plt -name dataset_IV_n@node@

if { [lsearch [list_plots] plot_IV] == -1} {
	create_plot -1d -name plot_IV
}

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set i @node:index@
set COLORS  [list green blue  orange magenta violet brown]
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

#
create_variable -name absIds -dataset dataset_IV_n@node@ -function {abs(<drain TotalCurrent:dataset_IV_n@node@>)}

create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {time} -axisY {absIds} -name curve_IV_n@node@
create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {time} -axisY2 {gate OuterVoltage} -name curve_Vgate_n@node@

set_curve_prop -plot plot_IV {curve_IV_n@node@ curve_Vgate_n@node@} -line_width 3
set_curve_prop -plot plot_IV {curve_IV_n@node@} -label "I<sub>DS</sub> $curve_label" 	-color $color  
set_curve_prop -plot plot_IV {curve_Vgate_n@node@} -label "V<sub>GS</sub> $curve_label" -color red

set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis x -title "Time, t \[s\]"

set_axis_prop -plot plot_IV -axis y  -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y  -title  "Drain Current, I<sub>DS</sub> \[A/<greek>m</greek>m\]"
set_axis_prop -plot plot_IV -axis y2 -title  "Gate Voltage, V<sub>GS</sub> \[V\]"

set_plot_prop -plot {plot_IV} -title "@type@ I-t Curve ($common_label)"
 
set_window_full -on






 