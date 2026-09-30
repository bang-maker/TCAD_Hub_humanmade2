# this was created by Lanxiaomu
#setdep  @previous@


# dataset 
load_file ./IdVg_PostTID_n@node|TID2@_des.plt -name  dataset_IdVg_n@node@
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

# create absIds variable
create_variable -name absIds -dataset dataset_IdVg_n@node@ -function {abs(<drain TotalCurrent:dataset_IdVg_n@node@>)}
# create a curve 
create_curve -plot plot_IdVg -dataset {dataset_IdVg_n@node@} -axisX {gate OuterVoltage} -axisY {absIds} -name curve_IdVg_n@node@

# compute Gm
create_variable -name Gm -dataset dataset_IdVg_n@node@ -function {abs(diff(<drain TotalCurrent:dataset_IdVg_n@node@>,<gate OuterVoltage:dataset_IdVg_n@node@>))}
create_curve -plot plot_IdVg -dataset {dataset_IdVg_n@node@} -axisX {gate OuterVoltage} -axisY2 {Gm} -name curve_Gm_n@node@


set_curve_prop -plot plot_IdVg {curve_IdVg_n@node@} -label "I<sub>DS</sub>V<sub>GS</sub>:$legend_text_curve"
set_curve_prop -plot plot_IdVg {curve_Gm_n@node@} -label "G<sub>m</sub>:$legend_text_curve"
set_axis_prop -plot plot_IdVg -axis y -type log



# line width 
set_curve_prop -plot plot_IdVg {curve_IdVg_n@node@} -line_width 3
set_curve_prop -plot plot_IdVg {curve_Gm_n@node@} -line_width 3 
set_curve_prop -plot plot_IdVg {curve_Gm_n@node@} -line_style dash

# color 
set COLORS  [list green blue red orange magenta violet brown #008000 ] 
set i_experiment @node:index@
set Color_Length [llength $COLORS]
set color_now [lindex $COLORS [expr $i_experiment%$Color_Length]] 

set_curve_prop -plot plot_IdVg {curve_Gm_n@node@ curve_IdVg_n@node@} -color $color_now
 

# axis - text 
set_axis_prop -plot plot_IdVg -axis x -title "Gate Voltage, V<sub>GS</sub> \[V\]"
set_axis_prop -plot plot_IdVg -axis y -title "Drain Current, I<sub>DS</sub> \[A/<greek>m</greek>m\]"
set_axis_prop -plot plot_IdVg -axis y2 -title "Transconductance, G<sub>m</sub> \[S\]"


# title text 
set_plot_prop -plot {plot_IdVg} -title " I<sub>DS</sub>V<sub>GS</sub> Curve $common_text_curve"
set_axis_prop -plot plot_IdVg -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IdVg -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IdVg -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal

set_axis_prop -plot plot_IdVg -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IdVg -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_IdVg -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal

set_plot_prop -plot {plot_IdVg} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
