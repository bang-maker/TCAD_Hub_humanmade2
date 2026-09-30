#setdep  @previous@


# dataset 
load_file ./IdVg_Lin_n@node|IdVg@_des.plt -name  dataset_TCAD_Lin_n@node@
load_file ./IdVg_Sat_n@node|IdVg@_des.plt -name  dataset_TCAD_Sat_n@node@
load_file ./EXP_DATA/IdVgVds1.5.plt -name  dataset_EXP_Sat_n@node@
load_file ./EXP_DATA/IdVgVds0.1.plt -name  dataset_EXP_Lin_n@node@
# plot
if { [lsearch [list_plots] plot_IdVg ]== -1} {
	create_plot -1d -name plot_IdVg
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "@type@"
	set common_text_curve "@type@"
}



select_plots {plot_IdVg}

 
# create a curve 
create_curve -plot plot_IdVg -dataset {dataset_TCAD_Lin_n@node@} -axisX {gate OuterVoltage} -axisY {drain TotalCurrent} -name curve_TCAD_Lin_n@node@
create_curve -plot plot_IdVg -dataset {dataset_TCAD_Sat_n@node@} -axisX {gate OuterVoltage} -axisY {drain TotalCurrent} -name curve_TCAD_Sat_n@node@

create_curve -plot plot_IdVg -dataset {dataset_EXP_Lin_n@node@} -axisX {Vgs} -axisY {Ids} -name curve_EXP_Lin_n@node@
create_curve -plot plot_IdVg -dataset {dataset_EXP_Sat_n@node@} -axisX {Vgs} -axisY {Ids} -name curve_EXP_Sat_n@node@

set_curve_prop -plot plot_IdVg {curve_TCAD_Sat_n@node@} -label "TCAD V<sub>DS</sub>=1.5 V $legend_text_curve"
set_curve_prop -plot plot_IdVg {curve_EXP_Sat_n@node@} -label "EXP V<sub>DS</sub>=1.5 V $legend_text_curve"
set_curve_prop -plot plot_IdVg {curve_TCAD_Lin_n@node@} -label "TCAD V<sub>DS</sub>=0.1 V $legend_text_curve"
set_curve_prop -plot plot_IdVg {curve_EXP_Lin_n@node@} -label "EXP V<sub>DS</sub>=0.1 V $legend_text_curve"

set_curve_prop -plot plot_IdVg {curve_EXP_Sat_n@node@ curve_EXP_Lin_n@node@} -markers_type squaref  -hide_line


# line width 
set_curve_prop -plot plot_IdVg {curve_TCAD_Lin_n@node@ curve_TCAD_Sat_n@node@} -line_width 3
set_curve_prop -plot plot_IdVg {curve_EXP_Lin_n@node@ curve_EXP_Sat_n@node@}  -line_width 3 
set_curve_prop -plot plot_IdVg {curve_TCAD_Lin_n@node@ } -line_style solid
set_curve_prop -plot plot_IdVg {curve_TCAD_Sat_n@node@} -line_style dash

# color 
set COLORS  [list green blue red orange magenta violet brown #008000 ] 
set i_experiment @node:index@
set Color_Length [llength $COLORS]
set color_now [lindex $COLORS [expr $i_experiment%$Color_Length]] 

set_curve_prop -plot plot_IdVg {curve_EXP_Sat_n@node@} -color green
set_curve_prop -plot plot_IdVg {curve_EXP_Lin_n@node@} -color green
set_curve_prop -plot plot_IdVg {curve_TCAD_Sat_n@node@} -color $color_now
set_curve_prop -plot plot_IdVg {curve_TCAD_Lin_n@node@} -color $color_now
# axis - text 
set_axis_prop -plot plot_IdVg -axis x -title "Gate Voltage, V<sub>GS</sub> \[V\]"
set_axis_prop -plot plot_IdVg -axis y -title "Drain Current, I<sub>DS</sub> \[A/<greek>m</greek>m\]"
 


# title text 
set_plot_prop -plot {plot_IdVg} -title " I<sub>DS</sub>V<sub>GS</sub> Curve $common_text_curve"
set_axis_prop -plot plot_IdVg -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IdVg -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IdVg -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal

set_axis_prop -plot plot_IdVg -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IdVg -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IdVg -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal

set_plot_prop -plot {plot_IdVg} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
 