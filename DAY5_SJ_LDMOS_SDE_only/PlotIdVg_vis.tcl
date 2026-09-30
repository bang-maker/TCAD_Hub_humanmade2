#set Vti x

#----------------------------------------------------------------------#
load_library extract
lib::SetInfoDef 1
#----------------------------------------------------------------------#

set N     @node@
set i     @node:index@
set Vd    @Vd@
set Vg    @Vgs@

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

#- Plotting IdVg
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Id-Vg curve"
echo "#########################################"

load_file IdVg_@plot@ -name PLT($N)

if {[lsearch [list_plots] Plot_IdVg] == -1} {
	create_plot -1d -name Plot_IdVg
}
select_plots Plot_IdVg

set Vgs [get_variable_data "gate OuterVoltage" -dataset PLT($N)]
set Ids [get_variable_data "drain TotalCurrent" -dataset PLT($N)]
ext::AbsList -out absIds -x $Ids ;# Compute absolute value of drain currents
create_variable -name absId -dataset PLT($N) -values $absIds

create_curve -name IdVg($N) -dataset PLT($N) \
	-axisX "gate OuterVoltage" -axisY "absId"
	
set_curve_prop IdVg($N) -label "IdVg ( Vd=$Vd)" \
	-color $color -line_style solid -line_width 3


## Axis	 Modification
set_plot_prop -title "I<sub>d</sub>-V<sub>gs</sub> Curve" -title_font_size 16 -show_legend
set_axis_prop -axis x -title {Gate Voltage [V]} \
	-title_font_size 16 -scale_font_size 14 -type linear 
set_axis_prop -axis y -title {Drain Current [A]} \
	-title_font_size 16 -scale_font_size 14 -type log
set_legend_prop -label_font_size 12 -location bottom_right -label_font_att bold

#- Extraction
#----------------------------------------------------------------------#
echo "#########################################"
echo "Extracting parameters from Id-Vg curve"
echo "#########################################"

#- Defining current level for Vti extraction
#----------------------------------------------------------------------#
set Io    1e-10 ; # [A]

ext::ExtractVti 	 -out Vti 	-name "Vti"    -v $Vgs -i $absIds -io $Io
ext::ExtractExtremum -out Idmax -name "Idmax" -x $Vgs -y $absIds -extremum "max"
echo "Vti (Vg at Io= [format %.3e $Io] A) is [format %.3f $Vti] V"


