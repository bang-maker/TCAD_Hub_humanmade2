
# this code was created by Lanxiaomu
#setdep @previous@

#set a11 x
#set c11 x
#set a12 x
#set c12 x
#set a21 x
#set c21 x
#set a22 x
#set c22 x


load_file ./n@node|AC@_ac_des.plt -name dataset_n@node@
create_plot -1d -name plot_n@node@
select_plots {plot_n@node@}  

set Port_List {in out}
set Y_Name_List { 1 2}

foreach port1 $Port_List name1 $Y_Name_List {
	foreach port2 $Port_List name2 $Y_Name_List {
		set val_a [get_variable_data a($port1,$port2) -dataset dataset_n@node@ ]
		set val_c [get_variable_data c($port1,$port2) -dataset dataset_n@node@ ]
		puts "DOE: a$name1${name2} [lindex $val_a 0]"
		puts "DOE: c$name1${name2} [lindex $val_c 0]"
	}
}