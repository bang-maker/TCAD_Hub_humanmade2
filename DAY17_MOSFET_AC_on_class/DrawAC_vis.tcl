# this code was created by Lanxiaomu
 
# load RF extraction Library
load_library rfx


# load file
rfx::Load -file "CV_n@node|MOSFET_AC@_ac_des.plt" -dataset dataset_ac_n@node@  \
	-port1 g -port2 d -biasport "v(g)"

#
puts "***********************************************"
puts "The Freq List:"
puts "$rfx::freq"
puts "***********************************************"
puts "The Bias List:"
puts "$rfx::bias"
puts "***********************************************"
puts "The Number of Bias condation:"
puts "$rfx::nbias"
puts "***********************************************"
puts "The Number of Freq condation:"
puts "$rfx::nfreq"
puts "***********************************************"
puts "The Start Number of Freq Index:"
puts "$rfx::i_freqstart"
puts "***********************************************"
puts "The End Number of Freq Index:"
puts "$rfx::i_freqend"
puts "***********************************************"
puts "The End Number of Bias Index:"
puts "$rfx::i_biasstart"
puts "***********************************************"
puts "The End Number of Bias Index:"
puts "$rfx::i_biasend"

puts "***********************************************"
puts "The 3rd Bias is:"
puts [lindex $rfx::bias 2]

puts "***********************************************"
puts "The 4th Bias is:"
puts [lindex $rfx::freq 3]


rfx::CreateDataset -dataset AC_bias_n@node@ -xaxis "bias" -rfmatrix "AC" 

 
if {[lsearch [list_plots] Plot_CV_bias] == -1} {
	create_plot -1d -name Plot_CV_bias
	link_plots [list_plots] -unlink
	set_plot_prop -title "C<sub>gg</sub>-V<sub>gs</sub> curves (Lg=@Lgate@ <greek>m</greek>m)" \
		-title_font_size 20 -show_legend -show_grid
	set_axis_prop -axis x -title {Gate Voltage [V]} \
		-title_font_size 16 -scale_font_size 14	
	set_axis_prop -axis y -title {Capacitance [F]} \
		-scale_format scientific -scale_precision 0 \
		-title_font_size 16 -scale_font_size 14 	
}
select_plots Plot_CV_bias


set index  0
set freq [lindex  $rfx::freq $index]
create_curve -dataset AC_bias_n@node@ -axisX "{frequency_${index} bias}" -axisY "{frequency_${index} c(1,1)}" -name curve_Cgg_${index}_n@node@ 
set_curve_prop curve_Cgg_${index}_n@node@  -label "C<sub>gg</sub> Freq=[format %.2e $freq] Hz" \
	  -line_style solid -line_width 3

	  
set index  $rfx::i_freqend 
set freq [lindex  $rfx::freq $index]
create_curve -dataset AC_bias_n@node@ -axisX "{frequency_${index} bias}" -axisY "{frequency_${index} c(1,1)}" -name curve_Cgg_${index}_n@node@ 
set_curve_prop curve_Cgg_${index}_n@node@  -label "C<sub>gg</sub> Freq=[format %.2e $freq] Hz" \
	  -line_style solid -line_width 3


if {[lsearch [list_plots] Plot_CV_bias_all] == -1} {
	create_plot -1d -name Plot_CV_bias_all
	link_plots [list_plots] -unlink
	set_plot_prop -title "C<sub>gg</sub>-V<sub>gs</sub> curves (Lg=@Lgate@ <greek>m</greek>m)" \
		-title_font_size 20 -show_legend -show_grid
	set_axis_prop -axis x -title {Gate Voltage [V]} \
		-title_font_size 16 -scale_font_size 14	
	set_axis_prop -axis y -title {Capacitance [F]} \
		-scale_format scientific -scale_precision 0 \
		-title_font_size 16 -scale_font_size 14 	
}
select_plots Plot_CV_bias_all	  

for { set index $rfx::i_freqstart} { $index<= $rfx::i_freqend } { incr index } {
	set freq [lindex  $rfx::freq $index]
	create_curve -dataset AC_bias_n@node@ -axisX "{frequency_${index} bias}" -axisY "{frequency_${index} c(1,1)}" -name curve_Cgg_all_${index}_n@node@ 
	set_curve_prop curve_Cgg_all_${index}_n@node@  -label "C<sub>gg</sub> Freq=[format %.2e $freq] Hz" \
		  -line_style solid -line_width 3
}



##### C-Freq at xxx bias (Vg = -2.0 / 2.0 0 )
	  
# create dataset 
rfx::CreateDataset -dataset AC_freq_n@node@ -xaxis "frequency" -rfmatrix "AC" 

if {[lsearch [list_plots] Plot_CV_freq] == -1} {
	create_plot -1d -name Plot_CV_freq
	link_plots [list_plots] -unlink
	set_plot_prop -title "C<sub>gg</sub>-freq curves (Lg=@Lgate@ <greek>m</greek>m)" \
		-title_font_size 20 -show_legend -show_grid
	set_axis_prop -axis x -title {Gate Voltage [V]} \
		-title_font_size 16 -scale_font_size 14	
	set_axis_prop -axis y -title {Capacitance [F]} \
		-scale_format scientific -scale_precision 0 \
		-title_font_size 16 -scale_font_size 14 	
}
select_plots Plot_CV_freq


set index  0
set bias [lindex  $rfx::bias $index]
create_curve -dataset AC_freq_n@node@ -axisX "{bias_${index} frequency}" -axisY "{bias_${index} c(1,1)}" -name curve_Cgg_Cfreq_${index}_n@node@ 
set_curve_prop curve_Cgg_Cfreq_${index}_n@node@  -label "C<sub>gg</sub> Bias=[format %.2f $bias] V" \
	  -line_style solid -line_width 3


set index  $rfx::i_biasend
set bias [lindex  $rfx::bias $index]
create_curve -dataset AC_freq_n@node@ -axisX "{bias_${index} frequency}" -axisY "{bias_${index} c(1,1)}" -name curve_Cgg_Cfreq_${index}_n@node@ 
set_curve_prop curve_Cgg_Cfreq_${index}_n@node@  -label "C<sub>gg</sub> Bias=[format %.2f $bias] V" \
	  -line_style solid -line_width 3
set_axis_prop -plot Plot_CV_freq -axis x -type log



