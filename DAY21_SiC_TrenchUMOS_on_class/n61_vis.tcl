

load_library extract
lib::SetInfoDef 1

set N     61
set i     1

set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]


load_file UIS_nmos_n35_des.plt -name PLT($N)

if {[lsearch [list_plots] Plot_UIS] == -1} {
	create_plot -1d -name Plot_UIS
}
select_plots Plot_UIS

set Vds [get_variable_data "drain InnerVoltage" -dataset PLT($N)]
set Ids [get_variable_data "drain TotalCurrent" -dataset PLT($N)]
set Temps [get_variable_data "Tmax" -dataset PLT($N)]
set Time  [get_variable_data "time" -dataset PLT($N)]
ext::AbsList -out absIds -x $Ids

create_variable -name absId -dataset PLT($N) -values $absIds

create_curve -plot Plot_UIS -name DrainVoltage($N) -dataset PLT($N) \
	-axisX "time" -axisY "drain InnerVoltage"
create_curve -plot Plot_UIS -name DrainCurrent($N) -dataset PLT($N) \
	-axisX "time" -axisY "absId"
create_curve -plot Plot_UIS -name TempMax($N) -dataset PLT($N) \
	-axisX "time" -axisY2 "Tmax"	
			
set_curve_prop DrainVoltage($N) -label "VDrain" -color red -line_style solid -line_width 3
set_curve_prop DrainCurrent($N) -label "IDrain" -color blue -line_style solid -line_width 3
set_curve_prop TempMax($N)      -label "Tmax" -color black -line_style solid -line_width 3
	 
set_plot_prop -title "UIS Pulse" -title_font_size 16 -show_legend
set_axis_prop -axis x -title {Time [sec]} \
	-title_font_size 16 -scale_font_size 14 -type linear 
set_axis_prop -axis y -title {Voltage (V), Current (A)} \
	-title_font_size 16 -scale_font_size 14 -type linear
set_axis_prop -axis y2 -title {Temperature (K)} \
	-title_font_size 16 -scale_font_size 14 -type linear
		
set_legend_prop -font_size 12 -location bottom_right -font_att bold


ext::ExtractExtremum -out Tmax   -name Tmax 	  -x $Time -y $Temps  -extremum max
ext::ExtractExtremum -out Vdrain -name Vmax_drain -x $Time -y $Vds 	  -extremum max
ext::ExtractExtremum -out Idrain -name Imax_drain -x $Time -y $absIds -extremum max



