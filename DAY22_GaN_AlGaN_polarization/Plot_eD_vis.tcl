#setdep @node|-1:all@
## Make sure all the previous nodes are done before executing this node
#if @plot-eD@ == 0
#noexec
#endif


set N @node@
load_library extract
lib::SetInfoDef 1

set tbarr [list @t_barrier:all@]
set xbarr [list @x_barrier:all@]
set pz    [list @pz:all@]
set eDens [list @ns:all@]

#if 1
if {[lsearch [list_plots] Plot_Thickness] == -1} {
	create_plot -1d -name Plot_Thickness
	set_plot_prop -hide_title
}
select_plots Plot_Thickness

## eDensity vs. Barrier Layer Thickness
set Conditions(Target,1) 0.25
set Conditions(Values,1) $xbarr	

set Conditions(Target,2) 1
set Conditions(Values,2) $pz	


ext::FilterTable -out VtbeD -x $tbarr -y $eDens -conditions Conditions -ncond 2
create_variable -name Thickness -dataset tbeD($N) -values $VtbeD(X)
create_variable -name eD -dataset tbeD($N) -values $VtbeD(Y)
create_curve -name eDens_tb($N) -dataset tbeD($N) -axisX "Thickness" -axisY "eD"
set_curve_prop eDens_tb($N) -label "xMole= 0.25" \
	-color green -line_style solid -line_width 3 -show_markers -markers_size 7

set_axis_prop -axis x -title {Thickness (<greek>m</greek>m)} \
	-title_font_size 14 -scale_font_size 12
set_axis_prop -axis y -title {Sheet carrier density (cm<sup>-2</sup>)} \
	-title_font_size 14 -scale_font_size 12 
	
	
#endif	

if {[lsearch [list_plots] Plot_xMole] == -1} {
	create_plot -1d -name Plot_xMole
	set_plot_prop -hide_title
}
select_plots Plot_xMole

## eDensity vs. Barrier Layer Thickness
set Conditions(Target,1) 0.030
set Conditions(Values,1) $tbarr	

## set Conditions(Target,2) 1
## set Conditions(Values,2) $pz	


ext::FilterTable -out VxbeD -x $xbarr -y $eDens -conditions Conditions -ncond 1
create_variable -name xMole -dataset xbeD($N) -values $VxbeD(X)
create_variable -name eD -dataset xbeD($N) -values $VxbeD(Y)
create_curve -name eDens_xb($N) -dataset xbeD($N) -axisX "xMole" -axisY "eD"
set_curve_prop eDens_xb($N) -label "Thickness= 30 nm" \
	-color blue -line_style solid -line_width 3 -show_markers -markers_size 7
	
set_axis_prop -axis x -title {xMoleFraction} \
	-title_font_size 14 -scale_font_size 12
set_axis_prop -axis y -title {Sheet carrier density (cm<sup>-2</sup>)} \
	-title_font_size 14 -scale_font_size 12 -type log -min 1e12 -max 1e14
	
## Load reference data
load_file fromgraph.csv 
create_curve -name ref($N) -plot Plot_xMole -dataset {fromgraph} -axisX xMole -axisY ns
set_curve_prop -plot Plot_xMole ref($N) -label "Reference" -color #ff0000 -show_markers -hide_line -markers_size 13 -markers_type diamondf
set_axis_prop -axis y -min 1e12 -max 1e14
	



