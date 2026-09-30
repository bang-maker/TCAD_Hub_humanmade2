load_file ./IdVg_n16_des.plt -name dataset_IV
create_plot -1d -name plot_IV
select_plots {plot_IV}   

create_curve -plot plot_IV -dataset {dataset_IV} -axisX {gate OuterVoltage} -axisY {drain TotalCurrent} -name curve_IV

set_axis_prop -plot plot_IV -axis y -type log
set_curve_prop -plot plot_IV {curve_IV} -line_width 5
set_curve_prop -plot plot_IV {curve_IV} -label I<sub>d</sub>V<sub>g</sub>

set_axis_prop -plot plot_IV -axis x -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis x -title "Gate Voltage, V<sub>GS</sub> \[V\]"

set_axis_prop -plot plot_IV -axis y -title_font_family arial -title_font_size 13 -title_font_color #000000 -title_font_att normal
set_axis_prop -plot plot_IV -axis y -title "Drain Current, V<sub>DS</sub> \[A/<greek>m</greek>m\]"

set_plot_prop -plot {plot_IV} -title "PMOS I<sub>DS</sub>V<sub>GS</sub> Curve"

