#setdep @node|sdevice@


set N     "mesh=@t_mesh@"
set ds n$N

load_file n@previous@_des.tdr -name TDR($N)
create_plot -dataset TDR($N) -name plot2D($N)
create_cutline -plot plot2D($N) -type x -at 0.5 -name cut1D($N)
#create_plot -dataset TDR($N) -1d -name plot1D($N)
#select_plots plot1D($N)
if {[lsearch [list_plots] Plot_2DEG] == -1} {
	create_plot -1d -name Plot_2DEG
	set_plot_prop -title "2DEG" -title_font_size 20
	set_axis_prop -axis x -title {Position [<greek>m</greek>m]} \
		-title_font_size 16 -scale_font_size 14 -type linear 
	set_axis_prop -axis y -title {eDensity [1/cm2]} \
		-title_font_size 16 -scale_font_size 14 -type log
	#set_legend_prop -font_size 12 -location bottom_right -font_att bold	
}


create_curve -plot Plot_2DEG -dataset cut1D($N) -axisX Y -axisY eDensity -name "n2DEG($N)"
#set_axis_prop -plot Plot_2DEG -axis x -min -0.31 -max -0.29 
#set_axis_prop -plot Plot_2DEG  -axis y -type log
set_curve_prop -plot Plot_2DEG "n2DEG($N)" -line_width 2 -show_markers -markers_size 7
#windows_style -style max
#set_window_full -on
#set_window_size 700x800

##surface charge calculation...
create_curve -plot Plot_2DEG -name "chargeInt($N)" -function integr(<n2DEG($N)>) -y 2

set surface_charge [calculate_scalar -curves -plot Plot_2DEG  -function vecmax(<chargeInt($N)>)]

## Sheet charge at the barrier/channel interface
puts "DOE: ns [format %.3e [expr $surface_charge*1e-4]]"


