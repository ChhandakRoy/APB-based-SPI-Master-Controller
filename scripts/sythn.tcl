################################################################
#Cleanup : wipes off any design currently sitting in DC's memory
###############################################################

remove_design -all

###############################################################
#Library Setup (the path to search for and the exact file inside the path)
#This is where the DC takes the Cells from during mapping
##############################################################

set search_path {../lib}
set target_library {lsi_10k.db}
set link_library "* lsi_10k.db"

##############################################################
#Read, check errors and build the design
##############################################################
analyze -format verilog {../rtl/BAUD_GENERATOR.v ../rtl/SPI_SHIFT_REGISTER.v ../rtl/APB_SLAVE_INTERFACE.v ../rtl/SPI_SLAVE_CONTROL_SELECT.v ../rtl/SPI_TOP.v}
elaborate SPI_TOP
link
check_design > check__design_pre_synth.rpt

#############################################################
# Set the Design context
#############################################################

current_design  SPI_TOP

#############################################################
# Constarints for our design (alwasy before compile_ultra)
# which helps in better  synthesis and optimization
#############################################################

create_clock -name clk -period 20  [get_ports PCLK]
set_input_delay 0.75 -clock clk [get_ports [all_inputs]]
set_output_delay 0.75 -clock clk [get_ports [all_outputs]]

############################################################
#Run Synthesis
############################################################

compile_ultra -no_autoungroup

#############################################################
#Checks for unconnected ports, not used ports etc post synth
#############################################################
check_design > check__design_post_synth.rpt


############################################################
#Generate human-readable reports
############################################################

report_timing > timing.rpt
report_area > area.rpt
report_power > power.rpt
report_constraint -all_violators > violations.rpt

###########################################################
#Save Synthesized Outputs (netlist + synthesized design)
##########################################################

write_file -f verilog -hier -output SPI_synthesized_netlist.v
write -format ddc -hierarchy -output mapped_netlist.db

                                                               