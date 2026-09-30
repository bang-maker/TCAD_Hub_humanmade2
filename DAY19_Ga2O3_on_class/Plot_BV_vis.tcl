#setdep @node|BV@
## Tool: S-Visual
## Plot BV Characteristics
#----------------------------------------------------------------------#
load_library extract
lib::SetInfoDef 1
#----------------------------------------------------------------------#
set N     @node@
set i     @node:index@
#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Ic-Vc curve : Breakdown voltage characteristics"
echo "#########################################"
if {[lsearch [list_plots] Plot_BV] == -1} {
	create_plot -1d -name Plot_BV
}
select_plots Plot_BV
load_file BV_n@node|-1@_des.plt -name PLT_BV($N)
set Vcs [get_variable_data "drain InnerVoltage" -dataset PLT_BV($N)]
set Ics [get_variable_data "drain TotalCurrent" -dataset PLT_BV($N)]

create_curve -name BV($N) -dataset PLT_BV($N) \
	-axisX "drain InnerVoltage" -axisY "drain TotalCurrent"
	
set_curve_prop BV($N) -label "Vg=@Vgmin@" \
	-color $color -line_style solid -line_width 3
set_axis_prop -plot Plot_BV -axis x -title {Vd [V]} \
		      -title_font_size 16 -scale_font_size 16
		      
set_axis_prop -plot Plot_BV -axis y -title {Id [V]} -type log \
		      -title_font_size 16 -scale_font_size 16

#if 1
#----------------------------------------------------------------------#
echo "#########################################"
echo "BV Extraction"
echo "#########################################"
#----------------------------------------------------------------------#
## Breakdown voltage at which Ic reaches 1.0 pA
set Io 1.0e-08
ext::ExtractBVi out= BV    name= "BV" v= $Vcs i= $Ics  io= $Io 
echo "BV (Vc at Io= [format %.3e $Io] A) is [format %.3f $BV] V"
#endif
#----------------------------------------------------------------------#
set_legend_prop -plot Plot_BV -label_font_family arial -label_font_size 12 -label_font_color #000000 -label_font_att bold
set_plot_prop -plot Plot_BV -title "BV" -title_font_family arial -title_font_size 12 -title_font_color #000000 -title_font_att bold

