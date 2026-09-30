# this code was created by Lanxiaomu
# load RF extraction Library
load_library rfx
load_library extract

# load file
rfx::Load -file "CV_n@node|AC_gm@_ac_des.plt" -dataset dataset_ac_n@node@  \
	-port1 g -port2 d -biasport "v(g)"
 
# convert the matrix to Y matrix
rfx::CreateDataset -dataset AC_Y_bias_n@node@ -xaxis "bias" -rfmatrix "Y" 
  

if {[lsearch [list_plots] Plot_gm] == -1} {
	create_plot -1d -name Plot_gm
	link_plots [list_plots] -unlink
	set_plot_prop -title "g<sub>m</sub>-V<sub>gs</sub> curves (Lg=@Lgate@ <greek>m</greek>m)" \
		-title_font_size 20 -show_legend -show_grid
	set_axis_prop -axis x -title {Gate Voltage [V]} \
		-title_font_size 16 -scale_font_size 14	
	set_axis_prop -axis y -title {g<sub>m</sub> [S]} \
		-scale_format scientific -scale_precision 0 \
		-title_font_size 16 -scale_font_size 14 	
}
select_plots Plot_gm       
# gm-Vgs curve at freq= 1e11
set targetFreq 1e11
# get the freqPoint nearrest to targetFreq
rfx::GetNearestIndex -out i_freq  -target $targetFreq  -list $rfx::freq 
set freq [lindex $rfx::freq $i_freq ]
create_curve -dataset AC_Y_bias_n@node@ -axisX "{frequency_${i_freq} bias}" -axisY "{frequency_${i_freq} y21_Abs}" -name curve_gm_${i_freq}_n@node@ 
set_curve_prop curve_gm_${i_freq}_n@node@ -label "G<sub>m</sub> Freq=[format %.2e $freq] V" \
	  -line_style solid -line_width 3

#get the data in the curve 

set Vgs [get_curve_data curve_gm_${i_freq}_n@node@ -axisX ]
set gm  [get_curve_data curve_gm_${i_freq}_n@node@ -axisY ]

ext::AbsList -out gm_abs -x $gm
# get maximum gm
ext::ExtractExtremum -out gmPeak -name "gmPeak" -x $Vgs -y $gm_abs 
# 
ext::ExtractValue -out VgmPeak -x  $gm_abs -y $Vgs -xo $gmPeak

# get the index of the VgmPeak  in the rfx::bias list
rfx::GetNearestIndex -out i_bias -target $VgmPeak -list $rfx::bias

######################################## 
## Current Gain vs Freq ################
######################################## 


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

# convert the matrix to H matrix
rfx::CreateDataset -dataset AC_H_freq_n@node@ -xaxis "frequency" -rfmatrix "H" -dB 20
set bias [lindex $rfx::bias $i_bias]
create_curve -dataset AC_H_freq_n@node@ -axisX "{bias_${i_bias} frequency}" -axisY "{bias_${i_bias} h21_Abs_20dB}" -name curve_CurrentGain_${i_bias}_n@node@ 
set_curve_prop curve_CurrentGain_${i_bias}_n@node@ -label "A<sub>I</sub> Bias=[format %.2e $bias] V" \
	  -line_style solid -line_width 3
set_axis_prop -plot Plot_Gain -axis x -type log

#####  plot Voltage Gain 
rfx::CreateDataset -dataset AC_Y_freq_n@node@ -xaxis "frequency" -rfmatrix "Y" -dB 20
##AC_Y_bias_n@node@
create_curve -dataset AC_Y_freq_n@node@ -axisX "{bias_${i_bias} frequency}" -axisY "{bias_${i_bias} y21_Abs_20dB}" -name curve_y21_${i_bias}_n@node@ 
create_curve -dataset AC_Y_freq_n@node@ -axisX "{bias_${i_bias} frequency}" -axisY "{bias_${i_bias} y22_Abs_20dB}" -name curve_y22_${i_bias}_n@node@ 
create_curve -name curve_voltageGain_${i_bias}_n@node@  -function  (<curve_y21_${i_bias}_n@node@>-<curve_y22_${i_bias}_n@node@>)
remove_curves "curve_y21_${i_bias}_n@node@  curve_y22_${i_bias}_n@node@ "
set_curve_prop curve_voltageGain_${i_bias}_n@node@ -label "A<sub>V</sub> Bias=[format %.2e $bias] V" \
	  -line_style solid -line_width 3
set_axis_prop -plot Plot_Gain -axis x -type log


######################################## 
## Plot Zds  vs Freq    ################
######################################## 
if {[lsearch [list_plots] Plot_Zds] == -1} {
	create_plot -1d -name Plot_Zds
	link_plots [list_plots] -unlink
	set_plot_prop -title "Gain vs freq curves (Lg=@Lgate@ <greek>m</greek>m)" \
		-title_font_size 20 -show_legend -show_grid
	set_axis_prop -axis x -title {Gate Voltage [V]} \
		-title_font_size 16 -scale_font_size 14	
	set_axis_prop -axis y -title {Source-Drain Ouput Z [ohm]} \
		-scale_format scientific -scale_precision 0 \
		-title_font_size 16 -scale_font_size 14 	
	set_axis_prop -axis y2 -title {Phase [degree]} \
		-scale_format scientific -scale_precision 0 \
		-title_font_size 16 -scale_font_size 14 
}
select_plots Plot_Zds

rfx::CreateDataset -dataset AC_Z_freq_n@node@ -xaxis "frequency" -rfmatrix "Z"  

set bias [lindex $rfx::bias $i_bias]
create_curve -dataset AC_Z_freq_n@node@ -axisX "{bias_${i_bias} frequency}" -axisY "{bias_${i_bias} z22_Abs}" -name curve_Zds_${i_bias}_n@node@ 

create_curve -dataset AC_Z_freq_n@node@ -axisX "{bias_${i_bias} frequency}" -axisY2 "{bias_${i_bias} z22_Phase}" -name curve_Zds_phase_${i_bias}_n@node@ 
set_curve_prop "curve_Zds_${i_bias}_n@node@ curve_Zds_phase_${i_bias}_n@node@" -label "A<sub>I</sub> Bias=[format %.2e $bias] V" \
	  -line_style solid -line_width 3
set_curve_prop "curve_Zds_phase_${i_bias}_n@node@" -label "<greek>f</greek> Bias=[format %.2e $bias] V" \
	  -line_style solid -line_width 3
set_axis_prop -plot Plot_Zds -axis x -type log
