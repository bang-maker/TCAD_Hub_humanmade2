#setdep  @previous@


# dataset 
load_file ./Gummel_n@node|GummelPlot@_des.plt -name  dataset_GummelPlot_n@node@
# plot
if { [lsearch [list_plots] plot_GummelPlot ]== -1} {
	create_plot -1d -name plot_GummelPlot
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "NPN BJT"
	set common_text_curve "NPN BJT"
}



select_plots {plot_GummelPlot}

 # create curves 
create_curve -plot plot_GummelPlot -dataset {dataset_GummelPlot_n@node@} -axisX {base OuterVoltage} -axisY {collector TotalCurrent} -name curve_Ic_n@node@
 
create_curve -plot plot_GummelPlot -dataset {dataset_GummelPlot_n@node@} -axisX {base OuterVoltage} -axisY {base TotalCurrent} -name curve_Ib_n@node@


set_curve_prop -plot plot_GummelPlot {curve_Ic_n@node@} -label "I<sub>C</sub> $legend_text_curve"
set_curve_prop -plot plot_GummelPlot {curve_Ib_n@node@} -label "I<sub>B</sub> $legend_text_curve"

set_axis_prop -plot plot_GummelPlot -axis y -type log

# compute beta

create_variable -name beta -dataset dataset_GummelPlot_n@node@ -function {<collector TotalCurrent:dataset_GummelPlot_n@node@>/<base TotalCurrent:dataset_GummelPlot_n@node@>}
create_curve -plot plot_GummelPlot -dataset {dataset_GummelPlot_n@node@} -axisX {base OuterVoltage} -axisY2 {beta} -name curve_beta_n@node@
set Beta_Value [get_variable_data "beta" -dataset  dataset_GummelPlot_n@node@ ]
puts $Beta_Value
set Max_Beta [lindex [lsort -decreasing $Beta_Value] 0]
puts "DOE: MaxBeta [format %.2f $Max_Beta]"

set_curve_prop -plot plot_GummelPlot {curve_beta_n@node@} -label "<greek>b</greek> $legend_text_curve"
set_axis_prop -plot plot_GummelPlot -axis y2 -max [expr $Max_Beta*2.0] -max_fixed
set_axis_prop -plot plot_GummelPlot -axis y2 -min 0.0 -min_fixed

# line width 
set_curve_prop -plot plot_GummelPlot {curve_Ic_n@node@ curve_Ib_n@node@ curve_beta_n@node@} -line_width 3
set_curve_prop -plot plot_GummelPlot {curve_Ib_n@node@} -line_style dash
set_curve_prop -plot plot_GummelPlot {curve_beta_n@node@} -line_style dot
# color 
set COLORS  [list green blue red orange magenta violet brown #008000 ] 
set i_experiment @node:index@
set Color_Length [llength $COLORS]
set color_now [lindex $COLORS [expr $i_experiment%$Color_Length]] 

set_curve_prop -plot plot_GummelPlot {curve_Ic_n@node@ curve_Ib_n@node@ curve_beta_n@node@} -color $color_now

# axis - text 
set_axis_prop -plot plot_GummelPlot -axis x -title "Base Voltage, V<sub>BE</sub> \[V\]"
set_axis_prop -plot plot_GummelPlot -axis y -title "Current, I \[A/<greek>m</greek>m\]"
set_axis_prop -plot plot_GummelPlot -axis y2 -title "Beta, <greek>b</greek> \[1\]"


# title text 
set_plot_prop -plot {plot_GummelPlot} -title " Gummel-Plot "
set_axis_prop -plot plot_GummelPlot -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_GummelPlot -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_GummelPlot -axis y2 -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal

set_axis_prop -plot plot_GummelPlot -axis x -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_GummelPlot -axis y -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal
set_axis_prop -plot plot_GummelPlot -axis y2 -scale_font_family arial -scale_font_size 12 -scale_font_color #000000 -scale_font_att normal

set_plot_prop -plot {plot_GummelPlot} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal

set_plot_prop -plot {plot_GummelPlot} -show_grid

load_library extract

 