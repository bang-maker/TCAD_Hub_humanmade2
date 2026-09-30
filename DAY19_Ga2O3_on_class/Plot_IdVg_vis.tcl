#setdep @node|IdVg@
## Tool: S-Visual
## Plot IdVg Characteristics 
## Extract threshold voltage (Vth) 

#----------------------------------------------------------------------#
load_library extract
## lib::SetInfoDef 1
#----------------------------------------------------------------------#
set N     @node@
set i     @node:index@
#- Automatic alternating color assignment tied to node index
#----------------------------------------------------------------------#
set COLORS  [list brown black green blue red violet magenta violet brown]
set NCOLORS [llength $COLORS]
set color   [lindex  $COLORS [expr $i%$NCOLORS]]

#- Plotting IdVg
#----------------------------------------------------------------------#
echo "#########################################"
echo "Plotting Id-Vg curve"
echo "#########################################"
if {[lsearch [list_plots] Plot_IdVg] == -1} {
	create_plot -1d -name Plot_IdVg
}
select_plots Plot_IdVg
load_file IdVg_n@node|-1@_des.plt -name PLT_IdVg($N)

create_curve -name IdVg($N) -dataset PLT_IdVg($N) \
	-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"
	
set_curve_prop IdVg($N) -label "@node|-1@" \
	-color $color -line_style solid -line_width 3
	
set_axis_prop -plot Plot_IdVg -axis x -title {Vg [V]} \
		      -title_font_size 16 -scale_font_size 16 -title_font_att bold
		      
set_axis_prop -plot Plot_IdVg -axis y -title {Id [A]} \
		      -title_font_size 16 -scale_font_size 16 -title_font_att bold

#- Extraction
#if 1
#----------------------------------------------------------------------#
echo "#########################################"
echo "Extracting parameters from Id-Vg  curve"
echo "#########################################"

#- Defining current level for Vti extraction
#----------------------------------------------------------------------#
## Vth extraction using constant current method
set Vgs [get_variable_data "gate OuterVoltage" -dataset PLT_IdVg($N)]
set Ids [get_variable_data "drain TotalCurrent" -dataset PLT_IdVg($N)]
## Extract Vg at Id= Io
set Io 10.0e-6
ext::ExtractVti      out= Vti    name= "Vth" v= $Vgs i= $Ids  io= $Io
echo "Vti (Vg at Io= [format %.3e $Io] A) is [format %.3f $Vti] V"

#endif
## S-Visual Window Settings
set_window_size 900x700
set_window_full on

set_legend_prop -plot Plot_IdVg -label_font_family arial -label_font_size 12 -label_font_color #000000 -label_font_att bold
set_plot_prop -plot Plot_IdVg -title "IdVg" -title_font_family arial -title_font_size 12 -title_font_color #000000 -title_font_att bold

## To Export into an EPS file
## export_view Fig_n@node@_IdVg.eps -plots Plot_IdVg -format eps -overwrite   

