# this code was created by Lanxiaomu
# load RF extraction Library
load_library rfx
load_library extract

# load file
rfx::Load -file "CV_n@node|AC_gm@_ac_des.plt" -dataset dataset_ac_n@node@  \
	-port1 g -port2 d -biasport "v(g)"
  
######################################## 
## Current Gain vs Freq ################
######################################## 
rfx::CreateDataset -dataset AC_H_freq_n@node@ -xaxis "frequency" -rfmatrix "H"  -dB 20

if {[lsearch [list_plots] Plot_Gain] == -1} {
	create_plot -1d -name Plot_Gain
	link_plots [list_plots] -unlink
	set_plot_prop -title "Gain vs freq curves (Lg=@Lgate@ <greek>m</greek>m)" \
		-title_font_size 20 -show_legend -show_grid
	set_axis_prop -axis x -title {Gate Voltage [V]} \
		-title_font_size 16 -scale_font_size 14	
	set_axis_prop -axis y -title {Gain [dB]} \
		-scale_format scientific -scale_precision 0 \
		-title_font_size 16 -scale_font_size 14 	
}
select_plots Plot_Gain  

for {set i_bias $rfx::i_biasstart} { $i_bias <= $rfx::i_biasend } { incr i_bias }  {
	# convert the matrix to H matrix
	set bias [lindex $rfx::bias $i_bias]
	if {$bias > 0.0} {
		create_curve -dataset AC_H_freq_n@node@ -axisX "{bias_${i_bias} frequency}" -axisY "{bias_${i_bias} h21_Abs_20dB}" -name curve_CurrentGain_${i_bias}_n@node@ 
		set_curve_prop curve_CurrentGain_${i_bias}_n@node@ -label "A<sub>I</sub> Bias=[format %.2e $bias] V" \
		  -line_style solid -line_width 3
	}
}
set_axis_prop -plot Plot_Gain -axis x -type log

#draw 0 dB line

set y_0dB [list]
set x_0dB $rfx::freq

foreach f $rfx::freq {
	lappend y_0dB 0.0
}

create_variable -name "0dB" -dataset "UnityGain" -values $y_0dB
create_variable -name "x_0dB" -dataset "UnityGain" -values $x_0dB

create_curve -name 0dBline -dataset "UnityGain" -axisX "x_0dB" -axisY "0dB" 
set_curve_prop 0dBline -label "0 dB line" -color black -line_style dash -line_width 3


#################### plot ft vs Vgs ################
rfx::GetFt  -out Ft0 -method "unit-gain-point" -scale 1e9 -xscale "log"  -dataset "ft0_bias_n@node@"

# Creating plot for ft Vs bias
if {[lsearch [list_plots] Plot_fts] == -1} {
	create_plot -1d -name Plot_fts
	link_plots [list_plots] -unlink
	set_plot_prop -title "f<sub>t</sub> Vs V<sub>gs</sub>" -title_font_size 20 -show_legend -show_grid
	set_axis_prop -axis x -title {Gate Voltage [V]} \
		-title_font_size 16 -scale_font_size 14 -type linear
	set_axis_prop -axis y -title {f<sub>t</sub> [GHz]} \
		-title_font_size 16 -scale_font_size 14 -type linear
	set_legend_prop -font_size 12 -font_att bold 
 
}
select_plots Plot_fts

create_curve -name curve_ft0_n@node@ -dataset ft0_bias_n@node@ -axisX bias -axisY ft
set_curve_prop curve_ft0_n@node@ -label "unit-gain-point" \
	-color blue -line_style solid -line_width 3  \
	-show_markers -markers_size 10 -markers_type circle
 