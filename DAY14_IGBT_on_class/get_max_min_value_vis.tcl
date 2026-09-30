#setdep @node|Transient@
#set maxval x
#set minval x

# step 1 get the file list 
set FileList [lsort -ascii -increasing [glob -type f "profile_n@node|Transient@_*_IGBT_des.tdr"]]
puts "Find the TDR files:-----------"
foreach file $FileList { puts "$file" }
 
# step 2 start movie
set i 1

set maxval -1e200 
set minval 1e200

foreach file $FileList {
	puts -nonewline "processing file:  $file ..."
	#load file
	load_file $file -name dataset_tdr_$i
	create_plot -dataset dataset_tdr_$i -name plot_tdr_$i
	select_plots "{plot_tdr_$i}" 
	#find max/min value 
	set min_value_in_tdr [lindex [calculate_field_value -plot plot_tdr_$i -geom dataset_tdr_$i -field @Field@ -min] 0]
	set max_value_in_tdr [lindex [calculate_field_value -plot plot_tdr_$i -geom dataset_tdr_$i -field @Field@ -max] 0]
 	if { $maxval<$max_value_in_tdr } { set maxval $max_value_in_tdr }
	if { $minval>$min_value_in_tdr } { set minval $min_value_in_tdr }
	#unload file
	remove_plots plot_tdr_$i
	remove_datasets dataset_tdr_$i
	# next i
	incr i
	puts "done!"
}
 
puts "DOE: maxval $maxval"
puts "DOE: minval $minval"

