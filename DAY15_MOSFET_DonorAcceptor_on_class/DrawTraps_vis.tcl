#created by Lanxiaomu
#setdep  @previous@


set coord "Pos(0.0000,0.0020)"

set TrapList { Donor0 Donor1 Acceptor0 Acceptor1  }
set NameList { "Doner Tail" "Doner DeepLevel" "Acceptor Tail" "Acceptor DeepLevel"  }

# dataset 
load_file ./n@node|IdVg@_trap_des.plt -name  dataset_trap_n@node@
# plot
if { [lsearch [list_plots] plot_trap ]== -1} {
	create_plot -1d -name plot_trap
}

if [info exists runVisualizerNodesTogether] {
	set legend_text_curve $legend
	set common_text_curve $commonParameters
}  else  {
	set legend_text_curve "@type@"
	set common_text_curve "@type@"
}


foreach trap $TrapList name $NameList {
	puts "{$trap$coord Energy}"
	create_curve -plot plot_trap -dataset dataset_trap_n@node@ -axisX "{$trap$coord Energy}" -axisY "{$trap$coord TrapDensity}" -name curve_${trap}_n@node@
	if [string match "*Donor*" $trap] {
		set color #800080
	} else { 
		set color red
	}
	create_curve -plot plot_trap -dataset dataset_trap_n@node@ -axisX "{$trap$coord Energy}" -axisY "{$trap$coord TrappedChargeDensity}" -name curve_${trap}_tcd_n@node@
	
	set_curve_prop -plot plot_trap "curve_${trap}_tcd_n@node@" -line_width 3 -color $color -line_style dash
	set_curve_prop -plot plot_trap "{curve_${trap}_n@node@}" -line_width 3 -color $color 
	set_axis_prop -plot plot_trap -axis y -type log
	set_axis_prop -plot plot_trap -axis y -min 1e+10 -min_fixed
	
	set_curve_prop -plot plot_trap curve_${trap}_n@node@ -label "$name :Trap Density"
	set_curve_prop -plot plot_trap curve_${trap}_tcd_n@node@ -label "$name :Trapped Charge Density"
}


set EvRect [draw_rectangle -plot plot_trap -p1 {0.0 1e10} -p2 {-0.099 2e+19}]
set EcRect [draw_rectangle -plot plot_trap -p1 {1.103 1e10} -p2 {1.2 2e+19}]

set EvText [draw_textbox -plot plot_trap -at {-0.0790503 1.75926e+14} -label "E<sub>V</sub>"]
set_textbox_prop $EvText -plot plot_trap -pos {-0.0790503 1.75926e+14}  -font_family arial -font_size 14 -font_att normal -font_color #000000
set EcText [draw_textbox -plot plot_trap -at {1.11685 1.09525e+14} -label "E<sub>C</sub>"]
set_textbox_prop $EcText -plot plot_trap -pos {1.11685 1.09525e+14}  -font_family arial -font_size 14 -font_att normal -font_color #000000


# set EvLine [draw_line -plot plot_trap -p1 {0 1e+10} -p2 {0 1e+20}]
# set EcLine [draw_line -plot plot_trap -p1 {1.103 1e+10} -p2 {1.103 1e+20}]

# set_line_prop $EvLine -plot plot_trap -line_style solid -line_width 5 -line_color #a0a0a4
# set_line_prop $EcLine -plot plot_trap -line_style solid -line_width 5 -line_color #a0a0a4

set_rectangle_prop $EvRect -plot plot_trap -fill_color #ffff00  -line_color #ffffff
set_rectangle_prop $EcRect -plot plot_trap -fill_color #ffff00  -line_color #ffffff
 

create_curve -plot plot_trap -dataset dataset_trap_n@node@ -axisX "{hQF$coord Energy}" -axisY2 "{hQF$coord QuasiFermi}" -name curve_hQF_n@node@
set_curve_prop -plot plot_trap curve_hQF_n@node@ -line_width 3 -color blue -line_style solid

create_curve -plot plot_trap -dataset dataset_trap_n@node@ -axisX "{eQF$coord Energy}" -axisY2 "{eQF$coord QuasiFermi}" -name curve_eQF_n@node@
set_curve_prop -plot plot_trap curve_eQF_n@node@ -line_width 3 -color green -line_style solid

set_curve_prop -plot plot_trap curve_eQF_n@node@ -label "E<sub>F,n</sub>"
set_curve_prop -plot plot_trap curve_hQF_n@node@ -label "E<sub>F,p</sub>"

set_axis_prop -plot plot_trap -axis y2 -min 0 -min_fixed
set_axis_prop -plot plot_trap -axis y2 -max 1 -max_fixed
set_axis_prop -plot plot_trap -axis x -max 1.2 -max_fixed
set_axis_prop -plot plot_trap -axis x -min -0.1 -max_fixed

set_axis_prop -plot plot_trap -axis x -title "Energy (eV)"
set_axis_prop -plot plot_trap -axis y -title "Trap/TrappedCharge Density (cm<sup>-3</sup>)"
set_axis_prop -plot plot_trap -axis y2 -hide_title -hide_ticks -hide_scale


set_axis_prop -plot plot_trap -axis x -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_trap -axis y -title_font_family arial -title_font_size 14 -title_font_color #000000 -title_font_att normal
set_plot_prop -plot {plot_trap} -title "Traps Plot"   
set_plot_prop -plot {plot_trap} -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att bold
set_plot_prop -plot {plot_trap} -hide_legend 
set_window_full -on
export_view ./graph/n@node:index@.png -plots {plot_trap} -format png -overwrite
