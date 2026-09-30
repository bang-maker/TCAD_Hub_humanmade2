#setdep @previous@

# step 1 get the file list 

set FileList [lsort -ascii -increasing [glob -type f "profile_n@node|Transient@_*_IGBT_des.tdr"]]
puts "Find the TDR files:-----------"
foreach file $FileList { puts "$file" }




# step 2 start movie
set i 1

start_movie 

set FrameList [list]

set tStart 0
set tFinal 3e-6

set NumOfFiles [llength $FileList]

set dt [expr 1.0*($tFinal-$tStart)/($NumOfFiles-1)]

foreach file $FileList {
	puts -nonewline "processing file:  $file ..."
	#load file
	load_file $file -name dataset_tdr_$i
	create_plot -dataset dataset_tdr_$i -name plot_tdr_$i
	select_plots "{plot_tdr_$i}" 
 
	# add frame
	#- prepare my device 			# geom = dataset 
	set_field_prop -plot plot_tdr_$i -geom dataset_tdr_$i @Field@ -show_bands
	set_field_prop -plot plot_tdr_$i -geom dataset_tdr_$i @Field@ -max @maxval@ -max_fixed
	set_field_prop -plot plot_tdr_$i -geom dataset_tdr_$i @Field@ -min @minval@ -min_fixed
	set t0 [expr ($i-1)*$dt+$tStart]
	if { $t0<1.2e-6 && $t0>2e-7 } {
		set OnOffStatus "ON"
	} else {
		set OnOffStatus "OFF"
	}
	set_plot_prop -plot "{plot_tdr_$i}" -title "t= [format %.2f [expr $t0*1e6]]us ($OnOffStatus)"
	zoom_plot -plot plot_tdr_$i -window {8.14806 13.9461 -1.98341 -2.18156}
	set_material_prop {DepletionRegion} -plot plot_tdr_$i -geom dataset_tdr_$i -off
	set_field_prop -plot plot_tdr_$i -geom dataset_tdr_$i LatticeTemperature -levels 99
	
	
	#- add frame 
	add_frame -plot plot_tdr_$i -name Frame$i	
	lappend FrameList Frame$i
	
	#unload file
	remove_plots plot_tdr_$i
	remove_datasets dataset_tdr_$i
	# next i
	incr i
	puts "done!"
}

export_movie -filename ./my_gifs/n@node@_@Field@.gif -frames $FrameList -frame_duration 5 -overwrite
stop_movie