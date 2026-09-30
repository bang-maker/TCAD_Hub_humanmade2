#setdep @previous@
 
#create dataset
load_file n@previous@_PostDiffuse_fps.tdr -name dataset_diffuse_n@node@
if {[lsearch [list_plots] plot_diffuse] == -1} {
create_plot -1d -name plot_diffuse
}
select_plots {plot_diffuse}  

set field @tool_label@

set N     @node@
set i     @node:index@
#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

set STYLES [list Solid Dash Dot Dashdot Dashdotdot]
set NSTYLES [llength $STYLES]
set style   [lindex  $STYLES [expr int(1.0*$i/$NCOLORS)%$NSTYLES]]


 
create_curve -axisX {X} -axisY "{$field}" -dataset {dataset_diffuse_n@node@} -plot plot_diffuse -name curve_diffuse_n@node@
set_curve_prop {curve_diffuse_n@node@} -plot plot_diffuse -line_style $style -color $color
set_curve_prop {curve_diffuse_n@node@} -plot plot_diffuse -line_width 5
set_axis_prop -plot plot_diffuse -axis x -title "Depth, x \[<greek>m</greek>m\]"
set_axis_prop -plot plot_diffuse -axis y -title "$field  Concentration, N \[cm<sup>-3</sup>\]"
set_axis_prop -plot plot_diffuse -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_diffuse -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_diffuse -axis y -type log
set_axis_prop -plot plot_diffuse -axis x -min 0   -min_fixed
set_axis_prop -plot plot_diffuse -axis x -max 1.0 -max_fixed
set_axis_prop -plot plot_diffuse -axis y -min 1e15 -min_fixed
set_axis_prop -plot plot_diffuse -axis y -max 5e19 -max_fixed
if {[info exists runVisualizerNodesTogether]} {
	set curveLabel "$legend"
} else {
	set curveLabel " $field  " 
}
set_curve_prop {curve_diffuse_n@node@} -plot plot_diffuse -label $curveLabel
 
 
set_plot_prop -plot {plot_diffuse} -title "$field Concentration"
 

set_plot_prop -plot {plot_diffuse} -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att normal

set_window_full -on
zoom_plot -plot plot_diffuse -reset
