#setdep @previous@

#----------------------------------------------------------------------#
load_library extract
lib::SetInfoDef 1
#----------------------------------------------------------------------#
#input file
set plt_file "IdVd_n@node|IdVd@_des.plt"

#plot title
set Xaxis_title "Drain Voltage \[V\]"
set Yaxis_title "Drain Current \[A\]"
set plot_title  "IdVd Curve"
#curve_label
if {[info exists runVisualizerNodesTogether]} {
	set curveLabel "$legend"
} else {
	set curveLabel "@type@" 
}
#Ylabel type
set logOrlinear linear

#data 
set factor 1.0
set YDATA "drain TotalCurrent"
set XDATA "drain OuterVoltage"
#extract 
set WithExtract 0 

#----------------------------------------------------------------------#

set N @node@
set i @node:index@

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

if {[lsearch [list_plots] Plot_IRV] == -1} {
	create_plot -1d -name Plot_IRV
	set_axis_prop -axis x -title $Xaxis_title \
		-title_font_size 16 -scale_font_size 14 -type linear 
	set_axis_prop -axis y -title $Yaxis_title \
		-title_font_size 16 -scale_font_size 14 -type linear	
	set_legend_prop -label_font_size 12 -location top_left -label_font_att bold	
}
select_plots Plot_IRV
 
set_plot_prop -plot {Plot_IRV} -title "$plot_title"

load_file $plt_file -name Curve_dataset_n@node@

create_variable -dataset Curve_dataset_n@node@ -function "{${factor}*<${YDATA}:Curve_dataset_n@node@>}" -name new_ydata

create_curve -axisX $XDATA -axisY new_ydata -dataset {Curve_dataset_n@node@} -plot Plot_IRV  -name cuvre_n@node@
# set_axis_prop -plot Plot_IRV -axis y -max 70 -max_fixed
# set_axis_prop -plot Plot_IRV -axis y -min 0 -min_fixed
set_axis_prop -plot Plot_IRV -axis y -type $logOrlinear
# format
set_plot_prop -plot {Plot_IRV} -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att bold
set_curve_prop cuvre_n@node@ -label "$curveLabel" -color $color -line_style solid -line_width 3
set_plot_prop -plot {Plot_IRV} -show_grid




set Xdata [get_variable_data $XDATA    -dataset Curve_dataset_n@node@]  
set Ydata [get_variable_data new_ydata -dataset Curve_dataset_n@node@] 
#- Ron Extraction
#----------------------------------------------------------------------#
echo "#########################################"
echo "Extracting parameters from Id-Vd  curve"
echo "#########################################"
#----------------------------------------------------------------------#
## Ron extraction at Vd= 2.0 V
## set Vo 0.3
## Extraction of Ron at Id= 15 Amps (at Vd= 1.861 V) 


#Vds at 1.0V
set Vo 1.0 

set W  1.0 
set S  [expr  (@Xmax@-@Xmin@)*1.0e-4*@AF@*1.0e-4]
#ext::ExtractRdiff -out Ron -name "noprint" -v $Ydata -i $Xdata -vo $Vo 
ext::ExtractValue -out Io -name "noprint" -y $Ydata -x $Xdata -xo $Vo
set Ron [expr $Vo/$Io]
set Ronsp [expr $Vo/$Io*$S]
# echo "Ron (Vd = $Vo V) is [format %.3f $Ron] Ohm*cm^2"
# echo "Ron is in milli ohms*cm^2"
#"Ronsp unit: mOhm*cm^2"
puts "DOE: Ronsp [format %.1f [expr ($Ronsp*1.00e3)]]"
puts "DOE: Ron [format %.1f [expr $Ron]]"
 
