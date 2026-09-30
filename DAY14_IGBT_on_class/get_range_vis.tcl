#setdep @node|Transient@

#set maxval x
#set minval x

#get device plot list 

set ProfileFileList [lsort -ascii -increasing [glob -type f profile_n@node|Transient@_*_IGBT_des.tdr]]
puts "find the TDR files:------"
foreach file $ProfileFileList { puts $file }
puts "-------------------------"

set NumOfFile [llength $ProfileFileList]

set Field @Field@

set i 1
set maxval -1e100
set minval  1e100

foreach file $ProfileFileList {
	puts -nonewline "processing: $file ..." 
	load_file $file -name dataset_tdr_$i
	create_plot -dataset dataset_tdr_$i -name plot_tdr_$i
	select_plots "{plot_tdr_$i}"
	set min_in_plot [lindex [calculate_field_value -plot plot_tdr_$i -geom dataset_tdr_$i -field $Field -min] 0]
	set max_in_plot [lindex [calculate_field_value -plot plot_tdr_$i -geom dataset_tdr_$i -field $Field -max] 0]
	puts "-- min($Field):$min_in_plot \t max($Field):$max_in_plot"
	if { $max_in_plot > $maxval} { set maxval $max_in_plot}
	if { $min_in_plot < $minval} { set minval $min_in_plot}
	remove_plots plot_tdr_$i
	remove_datasets dataset_tdr_$i
	incr i
	puts "done!"
}

puts "DOE: maxval $maxval"
puts "DOE: minval $minval"