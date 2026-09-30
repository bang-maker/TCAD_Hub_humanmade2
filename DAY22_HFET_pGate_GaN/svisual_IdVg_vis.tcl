# Load data
set N @node@
load_file Fn@previous@_des.plt -name FnPLT($N) 
load_file Rn@previous@_des.plt -name RnPLT($N) 

if {[lsearch [list_plots] Plot_IdVg] == -1} {
	create_plot -1d -name Plot_IdVg
}

# Create and display Ids vs. Vgs curve
# Join together R and F data  
set IdF [get_variable_data -dataset FnPLT($N)  "drain TotalCurrent"]
set IdR [get_variable_data -dataset RnPLT($N)  -varname "drain TotalCurrent"]
set Id [concat [lreverse $IdR] $IdF]


set VgF [get_variable_data -dataset FnPLT($N)  "gate OuterVoltage"]
set VgR [get_variable_data -dataset RnPLT($N)  -varname "gate OuterVoltage"]
set Vg [concat [lreverse $VgR] $VgF]

create_variable -name Id -dataset FullCurve($N)  -values $Id
create_variable -name Vg -dataset FullCurve($N)  -values $Vg

create_curve -name Id -dataset FullCurve($N) -axisX Vg -axisY Id

# Create and display Ig vs. Vgs curve
set IgF [get_variable_data -dataset FnPLT($N)  "gate TotalCurrent"]
set IgR [get_variable_data -dataset RnPLT($N)  -varname "gate TotalCurrent"]
set Ig [concat [lreverse $IgR] $IgF]

create_variable -name Ig -dataset FullCurve($N)  -values $Ig

create_curve -name Ig -dataset FullCurve($N) -axisX Vg -axisY Ig

# Format curve and axes
set_curve_prop Id -label "Id" \
  -color red -line_style solid -line_width 3

set_curve_prop Ig -label "Ig" \
  -color blue -line_style solid -line_width 3

set_axis_prop -axis x  -title {Vgs (V)} -title_font_size 12 -type linear -min -2 -min_fixed -max 7 -max_fixed
set_axis_prop -axis y  -title {Ids (A/mm)} -title_font_size 12 -type log -min 1e-8 -min_fixed -max 1 -max_fixed

