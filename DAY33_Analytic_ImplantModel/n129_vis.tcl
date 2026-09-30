 
load_file n128_fps.tdr -name dataset_implant_n129
if {[lsearch [list_plots] plot_implant] == -1} {
create_plot -1d -name plot_implant
}
select_plots {plot_implant}  


set N     129
set i     3
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

set STYLES [list Solid Dash Dot Dashdot Dashdotdot]
set NSTYLES [llength $STYLES]
set style   [lindex  $STYLES [expr int(1.0*$i/$NCOLORS)%$NSTYLES]]


 
create_curve -axisX {X} -axisY {Phosphorus_Implant} -dataset {dataset_implant_n129} -plot plot_implant -name curve_implant_n129
set_curve_prop {curve_implant_n129} -plot plot_implant -line_style $style -color $color
set_curve_prop {curve_implant_n129} -plot plot_implant -line_width 5
set_axis_prop -plot plot_implant -axis x -title "Depth, x \[<greek>m</greek>m\]"
set_axis_prop -plot plot_implant -axis y -title "Phosphorus Concentration, N \[cm<sup>-3</sup>\]"
set_axis_prop -plot plot_implant -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_implant -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_implant -axis y -type log
set_axis_prop -plot plot_implant -axis x -min 0   -min_fixed
set_axis_prop -plot plot_implant -axis x -max 1.0 -max_fixed
set_axis_prop -plot plot_implant -axis y -min 1e15 -min_fixed
set_axis_prop -plot plot_implant -axis y -max 5e19 -max_fixed
if {[info exists runVisualizerNodesTogether]} {
	set curveLabel " Model= dualpearson Table=Tasch  "
} else {
	set curveLabel "Phosphorus_Implant" 
}
set_curve_prop {curve_implant_n129} -plot plot_implant -label $curveLabel
 
 
set_plot_prop -plot {plot_implant} -title "Phosphorus Concentration"
 

set_plot_prop -plot {plot_implant} -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att normal

set_window_full -on


