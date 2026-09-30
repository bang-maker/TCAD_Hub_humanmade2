
# this code was created by Lanxiaomu
#setdep @previous@
load_file ./IdVg_n@node|IdVg@_des.plt -name dataset_IV_n@node@

if { [lsearch [list_plots] plot_IV] == -1} {
	create_plot -1d -name plot_IV
}

#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set i @node:index@
set COLORS  [list green blue red orange magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]
 

if [info exists runVisualizerNodesTogether] {
	set curve_label $legend
	set common_label $commonParameters
} else {
	set curve_label "@type@"
	set common_label "IdVg"
}

select_plots {plot_IV}   


create_variable -name absIds -dataset dataset_IV_n@node@ -function {abs(<drain TotalCurrent:dataset_IV_n@node@>)}

create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {gate OuterVoltage} -axisY {absIds} -name curve_IV_n@node@

set_axis_prop -plot plot_IV -axis y -type log
set_curve_prop -plot plot_IV {curve_IV_n@node@} -line_width 5
set_curve_prop -plot plot_IV {curve_IV_n@node@} -label "I<sub>d</sub>V<sub>g</sub>:$curve_label" -color $color  

set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis x -title "Gate Voltage, V<sub>GS</sub> \[V\]"

set_axis_prop -plot plot_IV -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y -title "Drain Current, I<sub>DS</sub> \[A/<greek>m</greek>m\]"

set_plot_prop -plot {plot_IV} -title "@type@ I<sub>DS</sub>V<sub>GS</sub> Curve ($common_label)"

load_library extract

# probe


#get X Y data

set XDATA [get_curve_data curve_IV_n@node@ -axisX]
set YDATA [get_variable_data "absIds" -dataset dataset_IV_n@node@]
# set YDATA [get_curve_data curve_IV_n@node@ -axisY]


puts $XDATA

set Io 100e-9 ;# 100nA/um
 
#extract Vti 
ext::ExtractVti -out Vti -name "Vti_Lin" -v $XDATA -i $YDATA   -io $Io
ext::ExtractSS  -out SS  -name "SS_Lin"  -v $XDATA -i $YDATA   -vo $Vti
# ext::ExtractSS  -out SS2  -name "noprint"  -v $XDATA -i $YDATA   -vo $Vti
ext::ExtractExtremum -out IdON  -name "IdON"  -x $XDATA -y  $YDATA -type "max"
ext::ExtractExtremum -out IdOFF -name "IdOFF"  -x $XDATA -y $YDATA -type "min"

set OnOffRatio [expr log(abs($IdON/$IdOFF))/log(10)]
puts "DOE: OnOffRatio [format %.3f $OnOffRatio]"


set_legend_prop -plot plot_IV -location top_left

create_variable -name gm -dataset dataset_IV_n@node@ -function {abs(diff(<absIds:dataset_IV_n@node@>,<gate OuterVoltage:dataset_IV_n@node@>))}

create_curve -plot plot_IV -dataset {dataset_IV_n@node@} -axisX {gate OuterVoltage} -axisY2 gm -name curve_mobility_n@node@

set_curve_prop -plot plot_IV {curve_mobility_n@node@} -line_width 5
set_curve_prop -plot plot_IV {curve_mobility_n@node@} -label "G<sub>m</sub>:$curve_label" -color $color -line_style dash

set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis x -title "Gate Voltage, V<sub>GS</sub> \[V\]"

set_axis_prop -plot plot_IV -axis y2 -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y2 -title "TransConductance, G<sub>m</sub> \[S]"

set_window_full -on

#export 
export_curves {curve_IV_n@node@ curve_mobility_n@node@} -plot plot_IV -filename ./exported_data/IdVg/@type@_Lgate@Lgate@_Tox@Tox@.csv -format csv -overwrite
export_view ./exported_data/IdVg/@type@_Lgate@Lgate@_Tox@Tox@.png -plots {plot_IV} -format png -overwrite

 

 