#Library files are actually not needed for pure RTL linting purpose

set search_path "./"
set link_library " "

#This turns on the lint-checking engine only in Synopsys VC

set_app_var enable_lint true

#This select which rule set or goals to run; lint_rtl means standard
#RTL coding quality check only
configure_lint_setup -goal lint_rtl

#Reads and analyzes all the modules and submodules
analyze -verbose -format verilog { ../rtl/BAUD_GENERATOR.v  ../rtl/SPI_SHIFT_REGISTER.v  ../rtl/APB_SLAVE_INTERFACE.v  ../rtl/SPI_SLAVE_CONTROL_SELECT.v  ../rtl/SPI_TOP.v }

#It builds the actual real hierarchial design from top module 
#to sub-modules which assists lint checking
elaborate SPI_TOP

#This is the actual lint-checking engine startup command, this is where
#all the set goals are checked strictly again the RTL
check_lint

#Saves all the Violations in .txt file
report_lint -verbose -file SPI_report_lint.txt

