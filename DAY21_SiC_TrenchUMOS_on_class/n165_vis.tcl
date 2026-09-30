

set N     93
set i     1

set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

echo "#########################################"
echo "Plotting SW curve : Switching characteristics"
echo "#########################################"
if {[lsearch [list_plots] Plot_SW] == -1} {
	create_plot -1d -name Plot_SW
}
select_plots Plot_SW
load_file SW_n93_mos2_des.plt -name PLT_SW($N)

create_curve -name Ids($N) -dataset PLT_SW($N) \
	-axisX "time" -axisY "drain TotalCurrent"
create_curve -name Vds($N) -dataset PLT_SW($N) \
	-axisX "time" -axisY2 "drain OuterVoltage" 
	
set_curve_prop Ids($N) -label "(n$N): Ids" \
	-color blue -line_style solid -line_width 3
set_curve_prop Vds($N) -label "(n$N): Vds" \
	-color black -line_style solid -line_width 3

set_axis_prop -plot Plot_SW -axis x -title "time (sec.)" \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold
		      
set_axis_prop -plot Plot_SW -axis y -title "Id(A)"  \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold -scale_format fixed

set_axis_prop -plot Plot_SW -axis y2 -title "Vd(V)"  \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold -scale_format fixed

set_window_size 900x700
set_window_full on

set_legend_prop -plot Plot_SW -label_font_family arial -label_font_size 12 -label_font_color #000000 -label_font_att bold -location bottom_right
set_plot_prop -plot Plot_SW -title "Double pulse switching" -title_font_family arial -title_font_size 16 -title_font_color #000000 -title_font_att bold



