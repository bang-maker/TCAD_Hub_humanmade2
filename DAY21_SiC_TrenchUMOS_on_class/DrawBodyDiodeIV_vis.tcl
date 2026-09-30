#setdep @previous@

#----------------------------------------------------------------------#
load_library extract
lib::SetInfoDef 1
#----------------------------------------------------------------------#
#input file
set plt_file "BodyDiodeIV_n@node|BodyDiodeIV@_des.plt"

#plot title
set Xaxis_title "Source-Drain Voltage, Vsd \[V\]"
set Yaxis_title "Drain Current Density,Isd \[A/cm^2\]"
set plot_title  "Body Diode IV Curve"
#curve_label
if {[info exists runVisualizerNodesTogether]} {
	set curveLabel "$legend"
} else {
	set curveLabel "Body Diode Current @type@" 
}

#Ylabel type
set logOrlinear linear

#data 
set factor [expr @<-1.0/((Xmax-Xmin)*AF*0.5)/2e-8>@]
set YDATA "drain TotalCurrent"
set XDATA "gate OuterVoltage"
#----------------------------------------------------------------------#

set N @node@
set i @node:index@

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
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

load_file $plt_file -name Curve_dataset_n@node@

create_variable -dataset Curve_dataset_n@node@ -function "{${factor}*<${YDATA}:Curve_dataset_n@node@>}" -name new_ydata

create_curve -axisX $XDATA -axisY new_ydata -dataset {Curve_dataset_n@node@} -plot Plot_IRV  -name cuvre_n@node@
# set_axis_prop -plot Plot_IRV -axis y -max 70 -max_fixed
# set_axis_prop -plot Plot_IRV -axis y -min 0 -min_fixed
set_axis_prop -plot Plot_IRV -axis y -type $logOrlinear
# format
set_plot_prop -plot {Plot_IRV} -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att bold
set_curve_prop cuvre_n@node@ -label "$curveLabel" -color $color -line_style solid -line_width 3
set_plot_prop -plot {Plot_IRV} -show_grid

set_axis_prop -plot Plot_IRV -axis y -min 0 -min_fixed
set_axis_prop -plot Plot_IRV -axis y -max 200 -max_fixed
 
