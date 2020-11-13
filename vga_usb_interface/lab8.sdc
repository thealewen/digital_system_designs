#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "10.0 MHz" [get_ports ADC_CLK_10]
create_clock -period "50.0 MHz" [get_ports CLOCK_50]
create_clock -period "50.0 MHz" [get_ports MAX10_CLK2_50]




# SDRAM CLK
#create_generated_clock -source [get_nets { lab_7_soc_sdram_pll_altpll_vg92:sd1:wire_pll7_clk[1] }] \
                      -name sdram_clk 
							 #[get_ports {lab_7_soc_sdram_pll_altpll_vg92:sd1:wire_pll7_clk[1]}]
							 
create_generated_clock -name sdram_clk [get_ports {DRAM_CLK}] -source [get_nets {u0|sdram_pll|sd1|wire_pll7_clk[1]}] 

#lab_7_soc_sdram_pll_altpll_vg92:sd1:wire_pll7_clk[1]
#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
# suppose +- 100 ps skew
# Board Delay (Data) + Propagation Delay - Board Delay (Clock)
# max 5.4(max) +0.4(trace delay) +0.1 = 5.9
# min 2.7(min) +0.4(trace delay) -0.1 = 3.0
set_input_delay -max -clock sdram_clk 5.9 [get_ports DRAM_DQ*]
set_input_delay -min -clock sdram_clk 3.0 [get_ports DRAM_DQ*]
#set_input_delay -max -clock sdram_clk 5.9 [get_ports DRAM_DQM*]
#set_input_delay -min -clock sdram_clk 3.0 [get_ports DRAM_DQM*]




#shift-window
set_multicycle_path -from [get_clocks {sdram_clk}] -to  [get_clocks {u0|sdram_pll|sd1|pll7|clk[0]}]  -setup 2
						  
#**************************************************************
# Set Output Delay
#**************************************************************
# suppose +- 100 ps skew
# max : Board Delay (Data) - Board Delay (Clock) + tsu (External Device)
# min : Board Delay (Data) - Board Delay (Clock) - th (External Device)
# max 1.5+0.1 =1.6
# min -0.8-0.1 = 0.9
set_output_delay -max -clock sdram_clk 1.6  [get_ports {DRAM_DQ* DRAM_DQM*}]
set_output_delay -min -clock sdram_clk -0.9 [get_ports {DRAM_DQ* DRAM_DQM*}]
set_output_delay -max -clock sdram_clk 1.6  [get_ports {DRAM_ADDR* DRAM_BA* DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_CKE DRAM_CS_N}]
set_output_delay -min -clock sdram_clk -0.9 [get_ports {DRAM_ADDR* DRAM_BA* DRAM_RAS_N DRAM_CAS_N DRAM_WE_N DRAM_CKE DRAM_CS_N}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
set_false_path -from * -to [get_ports LED*]
set_false_path -from * -to [get_ports HEX*]
set_false_path -from [get_ports SW*] -to *
set_false_path -from [get_ports KEY*] -to *
set_false_path -from [get_ports altera_reserved_tdi] -to *
set_false_path -from [get_ports altera_reserved_tms] -to *
set_false_path -from * -to [get_ports altera_reserved_tdo]



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



