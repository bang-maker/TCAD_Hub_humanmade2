#setdep @node|UIS@
## Tool: S-Visual
## Plot UIS Characteristics


set N     @node|UIS@
set i     @node:index@

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting UIS curve : Breakdown voltage characteristics"
echo "#########################################"
if {[lsearch [list_plots] Plot_UIS] == -1} {
	create_plot -1d -name Plot_UIS
}
select_plots Plot_UIS
load_file Transient_BE_MOS1_n@node|-1@_des.plt -name PLT_Sw($N)

create_curve -name Id($N) -dataset PLT_Sw($N) \
	-axisX "time" -axisY "drain TotalCurrent"
	
set_curve_prop Id($N) -label "($N):Id" \
	-color $color  -line_style solid -line_width 3
#if 1

create_curve -name Tmax($N) -dataset PLT_Sw($N) \
	-axisX "time" -axisY2 "Tmax"
create_curve -name Vd($N) -dataset PLT_Sw($N) \
	-axisX "time" -axisY "drain OuterVoltage"

set_curve_prop Tmax($N) -label "($N):Tmax" \
	-color $color -line_style solid -line_width 2 -hide_markers

set_curve_prop Vd($N) -label "($N):Vd" \
	-color $color -line_style dash -line_width 1
#endif

set_axis_prop -plot Plot_UIS -axis x -title "time (sec)" \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold
		      
set_axis_prop -plot Plot_UIS -axis y -title "Id (A)/Vd (V)" \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold

set_axis_prop -plot Plot_UIS -axis y2 -title "Tmax (K)" \
		      -title_font_size 20 -scale_font_size 18 -title_font_att bold
