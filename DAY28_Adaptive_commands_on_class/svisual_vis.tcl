#setdep @previous@
 
#create dataset
load_file n@node|sprocess@_postRemesh_fps.tdr -name dataset_VA_n@node@
load_file n@node|sprocess@_preRemesh_fps.tdr -name dataset_VB_n@node@
# if {[lsearch [list_plots] plot_VA] == -1} {
create_plot -1d -name plot_VA_n@node@
# }
select_plots {plot_VA_n@node@}  


create_curve -axisX {X} -axisY {@remesh_field@} -dataset {dataset_VB_n@node@} -plot plot_VA_n@node@ -name curve_VB_n@node@
create_curve -axisX {X} -axisY {@remesh_field@} -dataset {dataset_VA_n@node@} -plot plot_VA_n@node@ -name curve_VA_n@node@
set_plot_prop -plot {plot_VA_n@node@} -show_curve_markers
set_curve_prop {curve_VA_n@node@} -plot plot_VA_n@node@ -color #ff0000
set_curve_prop {curve_VA_n@node@} -plot plot_VA_n@node@ -line_width 1
set_curve_prop {curve_VA_n@node@} -plot plot_VA_n@node@ -markers_size 7
set_curve_prop {curve_VB_n@node@} -plot plot_VA_n@node@ -line_width 3
set_curve_prop {curve_VB_n@node@} -plot plot_VA_n@node@ -color #0000ff
set_curve_prop {curve_VB_n@node@} -plot plot_VA_n@node@ -line_style dash
set_curve_prop {curve_VB_n@node@} -plot plot_VA_n@node@ -hide_markers

set_axis_prop -plot plot_VA_n@node@ -axis x -title "Depth, x \[<greek>m</greek>m\]"
set_axis_prop -plot plot_VA_n@node@ -axis y -title "DopingConcentration, N \[cm<sup>-3</sup>\]"
set_axis_prop -plot plot_VA_n@node@ -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_VA_n@node@ -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_VA_n@node@ -axis y -type log

if {[info exists runVisualizerNodesTogether]} {
	set curveLabel "Doping Profile of @remesh_field@ (post Remsh) ($legend)"
	set common_text_curve $commonParameters
} else {
	set curveLabel "Doping Profile of @remesh_field@ (post Remsh)" 
	set common_text_curve $""
}
set_curve_prop {curve_VA_n@node@} -plot plot_VA_n@node@ -label $curveLabel
set_curve_prop {curve_VB_n@node@} -plot plot_VA_n@node@ -label "Implanted Doping Profile"
if [string match "@mesh_type@" "rel.error"] {
	set_plot_prop -plot {plot_VA_n@node@} -title "$common_text_curve"
} else {
	set_plot_prop -plot {plot_VA_n@node@} -title "$common_text_curve"
}

set_plot_prop -plot {plot_VA_n@node@} -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att normal

set_window_full -on

