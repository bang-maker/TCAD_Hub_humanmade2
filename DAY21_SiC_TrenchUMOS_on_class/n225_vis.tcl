

set N     225
set i     2


if {[info exists runVisualizerNodesTogether]} {
	set curveLabel "$legend"
} else {
	set curveLabel "DTMOS" 
}

set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

echo "#########################################"
echo "Plotting Qg curve : Dynamic input characteristics"
echo "#########################################"
if {[lsearch [list_plots] Plot_Qg] == -1} {
	create_plot -1d -name Plot_Qg
}
select_plots Plot_Qg
load_file QG_MOS1_n224_des.plt -name PLT_Qg($N)

create_curve -name Qg($N) -dataset PLT_Qg($N) \
	-axisX "gate Charge" -axisY "gate OuterVoltage"
	
set_curve_prop Qg($N) -label "$curveLabel" \
	-color $color -line_style solid -line_width 3

set_axis_prop -plot Plot_Qg -axis x -title { Qg [C] } \
		      -title_font_size 18 -scale_font_size 16 -title_font_att bold \
		      -manual_precision -scale_precision 0 -scale_format scientific
		      
set_axis_prop -plot Plot_Qg -axis y -title { Vgs [V] } \
		      -title_font_size 18 -scale_font_size 16 -title_font_att bold \
		      -manual_precision -scale_precision 0 -scale_format fixed

set_window_size 900x700
set_window_full on

set_legend_prop -plot Plot_Qg -label_font_family arial -label_font_size 12 -label_font_color #000000 -label_font_att bold
set_plot_prop -plot Plot_Qg -title "Dynamic input characteristics" -title_font_family arial -title_font_size 16 -title_font_color #000000 -title_font_att bold


set_axis_prop -plot Plot_Qg -axis y -max 20 -max_fixed

