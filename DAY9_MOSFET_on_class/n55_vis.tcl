load_file ./IdVg_n15_des.plt -name dataset_IV_n55
create_plot -1d -name plot_IV_n55
select_plots {plot_IV_n55}   

create_curve -plot plot_IV_n55 -dataset {dataset_IV_n55} -axisX {gate OuterVoltage} -axisY {drain TotalCurrent} -name curve_IV_n55

set_axis_prop -plot plot_IV_n55 -axis y -type log
set_curve_prop -plot plot_IV_n55 {curve_IV_n55} -line_width 5
set_curve_prop -plot plot_IV_n55 {curve_IV_n55} -label I<sub>d</sub>V<sub>g</sub>

set_axis_prop -plot plot_IV_n55 -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV_n55 -axis x -title "Gate Voltage, V<sub>GS</sub> \[V\]"

set_axis_prop -plot plot_IV_n55 -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV_n55 -axis y -title "Drain Current, V<sub>DS</sub> \[A/<greek>m</greek>m\]"

set_plot_prop -plot {plot_IV_n55} -title "NMOS I<sub>DS</sub>V<sub>GS</sub> Curve"

