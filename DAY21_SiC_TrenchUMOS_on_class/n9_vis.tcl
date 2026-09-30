
load_library extract
lib::SetInfoDef 1
set plt_file "IdVg_n7_des.plt"

set Xaxis_title "Gate Voltage \[V\]"
set Yaxis_title "Drain Current \[A\]"
set plot_title  "IdVg Curve"
if {[info exists runVisualizerNodesTogether]} {
	set curveLabel "$legend"
} else {
	set curveLabel "GPMOS" 
}
set logOrlinear log

set factor 1.0
set YDATA "drain TotalCurrent"
set XDATA "gate OuterVoltage"

set N 9
set i 1

set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

if {[lsearch [list_plots] Plot_IRV] == -1} {
	create_plot -1d -name Plot_IRV
	set_axis_prop -axis x -title $Xaxis_title \
		-title_font_size 16 -scale_font_size 14 -type linear 
	set_axis_prop -axis y -title $Yaxis_title \
		-title_font_size 16 -scale_font_size 14 -type linear	
	set_legend_prop -label_font_size 12 -location top_left -label_font_att bold	
}
select_plots Plot_IRV
 
set_plot_prop -plot {Plot_IRV} -title "$plot_title"

load_file $plt_file -name Curve_dataset_n9

create_variable -dataset Curve_dataset_n9 -function "{${factor}*<${YDATA}:Curve_dataset_n9>}" -name new_ydata

create_curve -axisX $XDATA -axisY new_ydata -dataset {Curve_dataset_n9} -plot Plot_IRV  -name cuvre_n9
set_axis_prop -plot Plot_IRV -axis y -type $logOrlinear
set_plot_prop -plot {Plot_IRV} -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att bold
set_curve_prop cuvre_n9 -label "$curveLabel" -color $color -line_style solid -line_width 3
set_plot_prop -plot {Plot_IRV} -show_grid

 
set Xdata [get_variable_data $XDATA    -dataset Curve_dataset_n9]  
set Ydata [get_variable_data new_ydata -dataset Curve_dataset_n9] 
set AF 350877.192982456
ext::ExtractValue -out Vth -name "out" -y $Xdata -x $Ydata -xo [expr $AF*100e-9]
echo "Vth is [format %.3e $Vth] V"
 

