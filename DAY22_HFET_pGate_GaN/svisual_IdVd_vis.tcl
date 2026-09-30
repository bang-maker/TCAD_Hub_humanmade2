# Load params
set Vg @Vg@
set N @node@
# Load data
load_file n@previous@_des.plt -name PLT($N)

# Create and display Ids vs. Vds curve

if {[lsearch [list_plots] Plot_IdVd] == -1} {
	create_plot -1d -name Plot_IdVd
}

create_curve -name Ids($N) -dataset PLT($N) -axisX  "drain OuterVoltage" -axisY "drain TotalCurrent"

set COLORS [list red green blue red green blue]
set color [lindex $COLORS @<@previous:index@-1>@]

# Format curve and axes

set_curve_prop Ids($N) -label "Vg = $Vg V" \
  -color $color -line_style solid -line_width 3

set_axis_prop -axis x  -title {Vds (V)} -title_font_size 12 -type linear 
set_axis_prop -axis y  -title {Ids (A/mm)} -title_font_size 12 -type linear

