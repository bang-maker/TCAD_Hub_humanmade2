#setdep @node|SC@
## Tool: S-Visual
## Plot SC Characteristics


set N     @node|SC@
set i     @node:index@

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting SC curve : Breakdown voltage characteristics"
echo "#########################################"
if {[lsearch [list_plots] Plot_SC] == -1} {
	create_plot -1d -name Plot_SC
}
select_plots Plot_SC
load_file SC_n@node|SC@_mos1_des.plt -name PLT_SC($N)

create_curve -name Ids($N) -dataset PLT_SC($N) \
	-axisX "time" -axisY "drain TotalCurrent"
create_curve -name Vds($N) -dataset PLT_SC($N) \
	-axisX "time" -axisY2 "drain OuterVoltage" 
# create_curve -name Tmax($N) -dataset PLT_SC($N) \
#	-axisX "time" -axisY2 "Tmax" 
	
set_curve_prop Ids($N) -label "Ids: G@VgMax@-D@Vx1@-T@tw@" \
	 -line_style solid -line_width 3
set_curve_prop Vds($N) -label "Vds: G@VgMax@-D@Vx1@-T@tw@" \
	 -line_style dash -line_width 2
# set_curve_prop Tmax($N) -label "(n$N): Tmax" \
#	-color red -line_style solid -line_width 3

set_axis_prop -plot Plot_SC -axis x -title "time (sec.)" \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold
		      
set_axis_prop -plot Plot_SC -axis y -title "Id(A)"  \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold -scale_format fixed

set_axis_prop -plot Plot_SC -axis y2 -title "Vd(V), Temp(K)"  \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold -scale_format fixed

## S-Visual Window Settings
set_window_size 900x700
set_window_full on

set_legend_prop -plot Plot_SC -label_font_family arial -label_font_size 12 -label_font_color #000000 -label_font_att bold -location bottom_right
set_plot_prop -plot Plot_SC -title "Short circuit" -title_font_family arial -title_font_size 16 -title_font_color #000000 -title_font_att bold

## To Export into an PNG file
## export_view Fig_n@node@_SC.png -plots Plot_SC -format png -overwrite   

