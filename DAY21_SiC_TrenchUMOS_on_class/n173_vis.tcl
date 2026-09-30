

set N     171
set i     5

set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

echo "#########################################"
echo "Plotting SC curve : Breakdown voltage characteristics"
echo "#########################################"
if {[lsearch [list_plots] Plot_SC] == -1} {
	create_plot -1d -name Plot_SC
}
select_plots Plot_SC
load_file SC_n171_mos1_des.plt -name PLT_SC($N)

create_curve -name Ids($N) -dataset PLT_SC($N) \
	-axisX "time" -axisY "drain TotalCurrent"
create_curve -name Vds($N) -dataset PLT_SC($N) \
	-axisX "time" -axisY2 "drain OuterVoltage" 
	
set_curve_prop Ids($N) -label "Ids: G10-D100-T20e-6" \
	 -line_style solid -line_width 3
set_curve_prop Vds($N) -label "Vds: G10-D100-T20e-6" \
	 -line_style dash -line_width 2

set_axis_prop -plot Plot_SC -axis x -title "time (sec.)" \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold
		      
set_axis_prop -plot Plot_SC -axis y -title "Id(A)"  \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold -scale_format fixed

set_axis_prop -plot Plot_SC -axis y2 -title "Vd(V), Temp(K)"  \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold -scale_format fixed

set_window_size 900x700
set_window_full on

set_legend_prop -plot Plot_SC -label_font_family arial -label_font_size 12 -label_font_color #000000 -label_font_att bold -location bottom_right
set_plot_prop -plot Plot_SC -title "Short circuit" -title_font_family arial -title_font_size 16 -title_font_color #000000 -title_font_att bold



