# this code was created by Lanxiaomu

#setdep @previous@
load_file ./CV_n@node|CV@_ac_des.plt -name dataset_CV_n@node@

if { [lsearch [list_plots] plot_CV] == -1} {
	create_plot -1d -name plot_CV
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
	set common_label "CV"
}

select_plots {plot_CV}   


create_variable -name Cgs -dataset dataset_CV_n@node@ -function {abs(<c(g,s):dataset_CV_n@node@>)}
create_variable -name Cgd -dataset dataset_CV_n@node@ -function {abs(<c(g,d):dataset_CV_n@node@>)}
create_variable -name Cgb -dataset dataset_CV_n@node@ -function {abs(<c(g,b):dataset_CV_n@node@>)}


create_curve -plot plot_CV -dataset {dataset_CV_n@node@} -axisX {v(g)} -axisY {c(g,g)} -name curve_Cgg_n@node@
create_curve -plot plot_CV -dataset {dataset_CV_n@node@} -axisX {v(g)} -axisY {Cgs} -name curve_Cgs_n@node@
create_curve -plot plot_CV -dataset {dataset_CV_n@node@} -axisX {v(g)} -axisY {Cgd} -name curve_Cgd_n@node@
create_curve -plot plot_CV -dataset {dataset_CV_n@node@} -axisX {v(g)} -axisY {Cgb} -name curve_Cgb_n@node@
create_curve -function "<curve_Cgs_n@node@>+<curve_Cgd_n@node@>" -name curve_Ccg_n@node@

 
set_curve_prop -plot plot_CV {curve_Cgg_n@node@ curve_Cgs_n@node@ curve_Cgd_n@node@ curve_Cgb_n@node@ curve_Ccg_n@node@} -line_width 3
set_curve_prop -plot plot_CV {curve_Cgg_n@node@} -label "C<sub>gg</sub>:$curve_label"    -line_style solid
set_curve_prop -plot plot_CV {curve_Cgs_n@node@} -label "C<sub>gs</sub>:$curve_label"    -line_style dash 
set_curve_prop -plot plot_CV {curve_Cgd_n@node@} -label "C<sub>gd</sub>:$curve_label"    -line_style dot
set_curve_prop -plot plot_CV {curve_Cgb_n@node@} -label "C<sub>gb</sub>:$curve_label"    -line_style dot
set_curve_prop -plot plot_CV {curve_Ccg_n@node@} -label "C<sub>gs</sub> + C<sub>gd</sub>:$curve_label"   -line_style dashdot

set_axis_prop -plot plot_CV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_CV -axis x -title "Gate Voltage, V<sub>GS</sub> \[V\]"

set_axis_prop -plot plot_CV -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_CV -axis y -title "Capacitance, C \[F/<greek>m</greek>m\]"

set_plot_prop -plot {plot_CV} -title "@type@ CV Curve ($common_label)"
 

 