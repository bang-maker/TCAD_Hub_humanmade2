#setdep @node|CV@

## Plot CV characteristics of the MOSCAP device

set N @node@

if {[lsearch [list_plots] Plot_CV] == -1} {
	create_plot -1d -name Plot_CV
}
select_plots Plot_CV
load_file CV_cv_n@node|-1@_ac_des.plt -name PLT_CV($N)

create_curve -name CV($N) -dataset PLT_CV($N) \
	-axisX "v(g)" -axisY "c(g,g)"
	
set_curve_prop CV($N) -label "CV" \
	-line_style solid -line_width 3 -hide_legend
	
set_axis_prop -plot Plot_CV -axis x -title {Vg [V]} \
		      -title_font_size 16 -scale_font_size 16 \
		      # -title_font_att bold
		      
set_axis_prop -plot Plot_CV -axis y -title {Cgg [F]} \
		      -title_font_size 16 -scale_font_size 16 