###this project was created by lanxiaomu######
#setdep @previous@
load_file ./It_n@node|write_erase@_des.plt -name dataset_IV_n@node@

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


 
create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {time} -axisY {gate TotalCurrent} -name curve_It_n@node@
create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {time} -axisY2 {gate InnerVoltage} -name curve_Vt_n@node@

# set_axis_prop -plot plot_IV -axis y -type log
set_curve_prop -plot plot_IV {curve_Vt_n@node@ curve_It_n@node@} -line_width 5
set_curve_prop -plot plot_IV {curve_Vt_n@node@ } -label "Vt:$curve_label"   
set_curve_prop -plot plot_IV {curve_It_n@node@ } -label "It:$curve_label"  

set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis x -title "Time, t \[s\]"

set_axis_prop -plot plot_IV -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y -title "Gate Current, I<sub>gate</sub> \[A/<greek>m</greek>m\]"

set_plot_prop -plot {plot_IV} -title " Transient Curve ($common_label)"
 

 