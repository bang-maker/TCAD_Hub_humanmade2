# loop 

set ABClist [list A B C D E F G]
set NUMlist [list 1 2 3 4 5 6 7]

# type 1
puts "-----foreach-----"
foreach abc $ABClist num $NUMlist {
	puts "${num}_$abc"
}


# type 2 
# incr : increase : c i++
puts "-----  for  -----"
for {set i 0} { $i< [llength $ABClist] } { incr i } {
	puts "[lindex $NUMlist $i]_[lindex $ABClist $i]"

}

# type 3
puts "-----while-----"
set i 0
while {$i<[llength $ABClist]} {
	puts "[lindex $NUMlist $i]_[lindex $ABClist $i]"
	incr i
}


# if-else
puts "-----if-----"
set val 0.0 
set val2 0

if {$val==0} {
	puts "val is zero"
} else {
	puts "val:$val"
}

if { [string equal $val $val2] } {
	puts "val = val2"
} else {
	puts "val != val2"
}
 

#format 

set pi [expr 2.0*asin(1.0)]
puts "pi=$pi"
puts "pi=[format %.3f $pi]"

#output 
set node @node@

puts "DOE: NODE $node"
puts "DOE: name lan.xiaomu"
puts "DOE: pi $pi"
puts "DOE: pi2 [format %.3f $pi]"


# function 
proc ADD { a { b 1.0 } } {
	set c [expr $a+$b]
	return $c
}


puts [ADD 1.0 2.5]
puts [ADD 1.0]

# file 

set filelist [glob "IdVg*des.plt"]
puts "there are [llength $filelist] IdVg plt files"
foreach file $filelist {
	puts $file 
}
