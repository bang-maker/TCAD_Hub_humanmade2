set M     @node@
set Vdd   @Vds@
#----------------------------------------------------------------------#
load_library extract
lib::SetInfoDef 1
#----------------------------------------------------------------------#

echo "##############################"
echo "plotting (BV) curves"
echo "##############################"

load_file BV_@plot@ -name PLT($M)

if {[lsearch [list_plots] Plot_IdVd] == -1} {
	create_plot -1d -name Plot_IdVd
	set_plot_prop -title "I<sub>d</sub>-V<sub>ds</sub> Curve" -title_font_size 20
	set_axis_prop -axis x -title {Drain Voltage [V]} \
		-title_font_size 16 -scale_font_size 14 -type linear 
	set_axis_prop -axis y -title {Drain Current [A/<greek>m</greek>m]} \
		-title_font_size 16 -scale_font_size 14 -type linear
	set_legend_prop -label_font_size 12 -location top_left -label_font_att bold	
}
select_plots Plot_IdVd

set Vds [get_variable_data "drain InnerVoltage" -dataset PLT($M)]
set Ids [get_variable_data "drain TotalCurrent" -dataset PLT($M)]
ext::AbsList -out absIds -x $Ids ;# Compute absolute value of drain currents
create_variable -name absId -dataset PLT($M) -values $absIds

create_curve -name BV($M) -dataset PLT($M) \
	-axisX "drain InnerVoltage" -axisY "absId"
	
set_curve_prop BV($M) -label "IdVd (BV extraction)" \
	-color red -line_style solid -line_width 3

#-- Extraction
set Io 1e-10

ext::ExtractBVi -out BVdss -name out -v $Vds -i $Ids -io $Io
