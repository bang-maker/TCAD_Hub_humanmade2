# Load data
set N @node@
load_file n@previous@_des.plt -name PLT($N)


if {[lsearch [list_plots] Plot_IdVd] == -1} {
	create_plot -1d -name Plot_IdVd
}

# Create and display Ids vs. Vds curve

create_curve -name Ids($N) -dataset PLT($N) -axisX  "drain InnerVoltage" -axisY "drain TotalCurrent"

# Format curve and axes

set_curve_prop Ids($N) -label "Id" \
  -color red -line_style solid -line_width 3

set_axis_prop -axis x  -title {Vds (V)} -title_font_size 12 -type linear 
set_axis_prop -axis y  -title {Ids (A/mm)} -title_font_size 12 -type log -min 1e-9 -max 1e-1

