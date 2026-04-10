# Create PWF Vivado project
# Run from Vivado Tcl console: source {<path>/PWF/create_project.tcl}
# Or from command line: vivado -mode batch -source create_project.tcl

# Get the directory where this script lives
set script_dir [file dirname [file normalize [info script]]]

# Delete old project file if it exists (but not the source directories)
file delete -force [file join $script_dir PWF.xpr]
file delete -force [file join $script_dir PWF.cache]
file delete -force [file join $script_dir PWF.hw]
file delete -force [file join $script_dir PWF.ip_user_files]
file delete -force [file join $script_dir PWF.runs]
file delete -force [file join $script_dir PWF.sim]
file delete -force [file join $script_dir PWF.srcs]
file delete -force [file join $script_dir PWF.gen]

# Create project (no -force, we cleaned up manually above)
create_project PWF $script_dir -part xc7a100tcsg324-1

# Set project properties
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]

# Add design sources from sources/hdl/
add_files -fileset sources_1 [glob [file join $script_dir sources hdl *.vhd]]

# Add simulation sources from sources/tb/
add_files -fileset sim_1 [glob [file join $script_dir sources tb *.vhd]]

# Add constraints
add_files -fileset constrs_1 [file join $script_dir Nexys_4_DDR_Master.xdc]

# Set top module
set_property top Microprocessor [current_fileset]

# Set top module for simulation
set_property top Microprocessor_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# Update compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "PWF project created successfully at: $script_dir/PWF.xpr"
