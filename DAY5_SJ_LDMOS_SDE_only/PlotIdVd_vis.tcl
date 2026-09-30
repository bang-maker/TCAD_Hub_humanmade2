set N     @node@
set Vdd   @Vds@

#----------------------------------------------------------------------#
load_library extract
lib::SetInfoDef 1
#----------------------------------------------------------------------#

#set RonA x

echo "##############################"
echo "plotting Id-Vd curves"
echo "##############################"
if {[lsearch [list_plots] Plot_IdVd] == -1} {
	create_plot -1d -name Plot_IdVd
	set_plot_prop -title "I<sub>d</sub>-V<sub>ds</sub> Curve" -title_font_size 20 
	set_axis_prop -axis x -title {Drain Voltage [V]} \
		-title_font_size 16 -scale_font_size 14 -type linear 
	set_axis_prop -axis y -title {Drain Current [A]} \
		-title_font_size 16 -scale_font_size 14 -type linear
	set_legend_prop -label_font_size 12 -location top_left -label_font_att bold	
}
select_plots Plot_IdVd

load_file IdVd_@plot@ -name PLT($N) 

set NAME IdVd_${N}
create_curve -name ${NAME}_tmp -dataset PLT($N) \
	-axisX "drain OuterVoltage" -axisY "drain TotalCurrent"
create_curve -name $NAME -function "abs(<${NAME}_tmp>)"	
remove_curves ${NAME}_tmp
set_curve_prop $NAME -label "IdVd at Vgs=8.0 V" \
	-color blue -line_style solid -line_width 3



#- Extraction
#----------------------------------------------------------------------#

set Vds [get_curve_data $NAME -plot Plot_IdVd -axisX]
set Ids [get_curve_data $NAME -plot Plot_IdVd -axisY]

ext::ExtractRdiff -out Ron -name out -v $Vds -i $Ids -vo [expr 0.1*$Vdd]

##Area in cm2
set A [expr (@Wdev@*@Ldev@*1e-8)]
set R [expr $A*$Ron]
puts "DOE:RonA [format %.3e $R]"


