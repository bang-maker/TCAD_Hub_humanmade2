#load RF Extraction Library
load_library rfx
lib::SetInfoDef 0

# load the AC file
# Create AC- and Y-matrix
rfx::Load -dataset dataset_ac_n@node@ -file "IdVg_n@node|FtFmax@_ac_des.plt" -port1 g -port2 d \
	-biasport "v(g)" 
#-devicewidth $W

puts "***********************************"
puts "The Frequency list: "
puts "$rfx::freq"
puts "The Bias list:"
puts "$rfx::bias"
puts "The number of Freqs:" 
puts "$rfx::nfreq"


# create H Matrix
rfx::CreateDataset -dataset "H_dB_freq_n@node@" -xaxis "frequency" -rfmatrix "H" -dB 20



# Creating plot for h21 (dB scale) Vs frequency 
if {[lsearch [list_plots] Plot_h21_dB_Freq] == -1} {
	create_plot -1d -name Plot_h21_dB_Freq
	link_plots [list_plots] -unlink
	# Plotting the 0 dB line only once
	set 0dB [list]
	foreach fq $rfx::freq {
		lappend 0dB 0.0
	}
	create_variable -name "0dB" -dataset "hUnityGain" -values $0dB
	create_variable -name "frequency" -dataset "hUnityGain" -values $rfx::freq
	create_curve -name 0dBline -dataset "hUnityGain" \
			-axisX "frequency" -axisY "0dB"
	set_curve_prop 0dBline -label "0 dB line" -color black -line_style dash -line_width 3	
	set_plot_prop -title "|h<sub>21</sub>| \[dB\] Vs Frequency" -title_font_size 20 -show_legend -show_grid
	set_axis_prop -axis x -title {Frequency [Hz]} \
		-scale_format scientific \
		-title_font_size 16 -scale_font_size 14 -type log 
	set_axis_prop -axis y -title "|h<sub>21</sub>| \[dB\]" \
		-title_font_size 16 -scale_font_size 14 -type linear	
	set_legend_prop -font_size 12 -location top_right -font_att bold	
}
set Ft_List [list]

for { set index $rfx::i_biasstart } { $index <= $rfx::i_biasend} {incr index } {
	set BiasPoint [lindex $rfx::bias $index]
	select_plots Plot_h21_dB_Freq
	create_curve -name Abs_h21_dB_${index}_n@node@ -dataset H_dB_freq_n@node@ \
		-axisX "bias_${index} frequency" -axisY "bias_${index} h21_Abs_20dB"	
	set_curve_prop Abs_h21_dB_${index}_n@node@ -label "V<sub>gs</sub>=[format %.2f $BiasPoint] V" \
		 -line_style solid -line_width 3
	set XDATA [get_variable_data "bias_${index} frequency" -dataset   H_dB_freq_n@node@]
	set YDATA [get_variable_data "bias_${index} h21_Abs_20dB" -dataset   H_dB_freq_n@node@]
	ext::ExtractValue    -out ft_index -name "noprint" -x $YDATA   -y $XDATA -xo 0 -f "%.2f"
	puts "$ft_index"
	lappend Ft_List $ft_index
}


# Creating datasets corresponding to ft Vs bias
rfx::GetFt -out Ft0 -method "unit-gain-point" -scale 1e9 -xscale "log" \
	-dataset "ft0_bias_n@node@"
	

	
#if 0 

###--------------------------------------------------------------------
puts "\n2.5 Arrays"

### 2.6.a
set model(1) Fermi
set model(2) Constant
set model(3) 3Stream
set model(4) 5Stream

for { set i 1 } { $i <= 4 } { incr i } {
  puts "Model #$i is $model($i)"
}
#-> Model #1 is Fermi
#-> Model #2 is Constant
#-> Model #3 is 3Stream
#-> Model #4 is 5Stream

### 2.6.b
set Identifiers [list first second third fourth]
set model(first)  Fermi
set model(second) Constant
set model(third)  3Stream
set model(fourth) 5Stream

foreach i $Identifiers {
  puts "The $i model is $model($i)"
}
#-> The first model is Fermi
#-> The second model is Constant
#-> The third model is 3Stream
#-> The fourth model is 5Stream

#endif 


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

create_curve -name ft0_n@node@ -dataset ft0_bias_n@node@ -axisX bias -axisY ft
set_curve_prop ft0_n@node@ -label "unit-gain-point" \
	-color blue -line_style solid -line_width 3  \
	-show_markers -markers_size 10 -markers_type circle
 
#----------------------------------------------------------------------#
lib::SetInfoDef 1	
#----------------------------------------------------------------------#
ext::ExtractExtremum -out ftPeak0    -name "out" -x $Ft0(bias) -y $Ft0(ft)   -type "max"  -f "%.2f"
ext::ExtractValue    -out Vg_ftPeak0 -name "out" -x $Ft0(ft)   -y $Ft0(bias) -xo $ftPeak0 -f "%.2f"



