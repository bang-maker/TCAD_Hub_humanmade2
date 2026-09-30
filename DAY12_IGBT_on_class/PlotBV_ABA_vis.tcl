#setdep @previous@
#----------------------------------------------------------------------#
#set BVi_ABA   x
#----------------------------------------------------------------------#
load_library extract
lib::SetInfoDef 1
#----------------------------------------------------------------------#

set N     @node@
set i     @node:index@
set Temp  300

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

#- IcVc plotting
#----------------------------------------------------------------------#
load_file @plot@ -name PLT($N)

if {[lsearch [list_plots] Plot_IcVc] == -1} {
	create_plot -1d -name Plot_IcVc
	set_plot_prop -title "Breakdown Characteristics" -title_font_size 20
	set_axis_prop -axis x -title {Collector Voltage [V]} \
		-title_font_size 16 -scale_font_size 14 -type linear
	set_axis_prop -axis y -title {Collector Current [A/um]} \
		-title_font_size 16 -scale_font_size 14 -type log	
	set_legend_prop -font_size 12 -location top_left -font_att bold	
}
select_plots Plot_IcVc

create_curve -name IcVc($N) -dataset PLT($N) \
	-axisX "Collector InnerVoltage" -axisY "Collector TotalCurrent"
set_curve_prop IcVc($N) -label "IcVc Temp= $Temp" \
	-color $color -line_style solid -line_width 3

#- Extraction
#----------------------------------------------------------------------#
set Vcs [get_variable_data "Collector InnerVoltage" -dataset PLT($N)]
set Ics [get_variable_data "Collector TotalCurrent" -dataset PLT($N)]

ext::ExtractExtremum -out BVi_ABA  -name "BVi_ABA"  -x $Vcs -y $Vcs  -type "max"  
echo "BVi is [format %.3e $BVi_ABA] V"
