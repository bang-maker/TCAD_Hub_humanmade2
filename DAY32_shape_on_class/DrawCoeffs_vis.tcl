#setdep @node|etch@

#if [string match "x" "@A0@"]
	#noexec
#endif



set num 100
set PI 3.1415926
set angle_start -90
set angle_end    90

set y_coeffs [list]
set x_angles [list]
set d_angle  [expr 1.0*($angle_end-$angle_start)/$num] 

for {set i 0 } { $i<= $num} { incr i } {
		set angle [expr $angle_start+ $i*$d_angle]	
		puts "angle $angle"
		set theta [expr $angle/180.0*$PI]
		set cost [expr cos($theta)]
		set coeff [expr 1.0*@A0@+1.0*@A1@*$cost+1.0*@A2@*$cost*$cost]
		lappend y_coeffs $coeff
		lappend x_angles $angle
}

puts $x_angles
puts $y_coeffs

if { [lsearch [list_plots] plot_coeffs] == -1} {
	create_plot -1d -name plot_coeffs
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
	set curve_label "IV"
	set common_label "IV"
}

select_plots {plot_coeffs}   

create_variable -dataset datasets_coeffs_n@node@ -name Y -values $y_coeffs
create_variable -dataset datasets_coeffs_n@node@ -name X -values $x_angles
 
create_curve -dataset datasets_coeffs_n@node@ -plot plot_coeffs  -axisX X -axisY Y -name curve_coeffs_n@node@

set_curve_prop -plot plot_coeffs {curve_coeffs_n@node@} -line_width 5
set_axis_prop -plot plot_coeffs -axis y -min 0 -min_fixed
set_curve_prop -plot plot_coeffs {curve_coeffs_n@node@} -show_markers
set_plot_prop -plot {plot_coeffs} -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att bold
set_plot_prop -plot {plot_coeffs} -title "Etching Rate ~ <greek>q</greek>"
set_axis_prop -plot plot_coeffs -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_coeffs -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_legend_prop -plot plot_coeffs -label_font_family arial -label_font_size 14 -label_font_color #000000 -label_font_att bold
set_curve_prop -plot plot_coeffs {curve_coeffs_n@node@} -label "coeffs = @A0@+@A1@cos<greek>q</greek>+@A2@cos<sup>2</sup><greek>q</greek>"
set_axis_prop -plot plot_coeffs -axis y -title "Etching Rate, r \[um/min\]"
set_axis_prop -plot plot_coeffs -axis x -title "Angle, <greek>q</greek> \[um/min\]"
set_axis_prop -plot plot_coeffs -axis x -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att {italic bold}
set_axis_prop -plot plot_coeffs -axis y -title_font_family arial -title_font_size 15 -title_font_color #000000 -title_font_att {italic bold}