#Create Project - change PROJECT_NAME 
start_gui
create_project zcu104_2021_2-vivado ./zcu104_2021_2-vivado -part xczu7ev-ffvc1156-2-e

set_property board_part xilinx.com:zcu104:part0:1.1 [current_project]
set_property platform.extensible true [current_project]
create_bd_design "design_1"

update_compile_order -fileset sources_1

create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0

# Zynq Block Automation
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]

# Adding the Clocking Wizard
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0

set_property -dict [list CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT3_USED {true} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {400.000} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.MMCM_CLKOUT1_DIVIDE {6} CONFIG.MMCM_CLKOUT2_DIVIDE {3} CONFIG.NUM_OUT_CLKS {3} CONFIG.RESET_PORT {resetn} CONFIG.CLKOUT2_JITTER {102.086} CONFIG.CLKOUT2_PHASE_ERROR {87.180} CONFIG.CLKOUT3_JITTER {90.074} CONFIG.CLKOUT3_PHASE_ERROR {87.180}] [get_bd_cells clk_wiz_0]

# Adding 3 Processor System Reset IPs
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins clk_wiz_0/clk_in1]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins clk_wiz_0/resetn]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_1/ext_reset_in]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_2/ext_reset_in]

connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]

connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_2/dcm_locked]

regenerate_bd_layout

# platform setup - enable clocks
set_property PFM.CLOCK {clk_out1 {id "1" is_default "false" proc_sys_reset "/proc_sys_reset_0" status "fixed" freq_hz "100000000"}} [get_bd_cells /clk_wiz_0]
set_property PFM.CLOCK {clk_out1 {id "1" is_default "false" proc_sys_reset "/proc_sys_reset_0" status "fixed" freq_hz "100000000"} clk_out2 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_1" status "fixed" freq_hz "200000000"}} [get_bd_cells /clk_wiz_0]
set_property PFM.CLOCK {clk_out1 {id "1" is_default "false" proc_sys_reset "/proc_sys_reset_0" status "fixed" freq_hz "100000000"} clk_out2 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_1" status "fixed" freq_hz "200000000"} clk_out3 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_2" status "fixed" freq_hz "400000000"}} [get_bd_cells /clk_wiz_0]
set_property pfm_name design_1 [get_files {design_1.bd}]
set_property PFM.CLOCK {clk_out1 {id "1" is_default "false" proc_sys_reset "/proc_sys_reset_0" status "fixed" freq_hz "100000000"} clk_out2 {id "2" is_default "true" proc_sys_reset "/proc_sys_reset_1" status "fixed" freq_hz "200000000"} clk_out3 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_2" status "fixed" freq_hz "400000000"}} [get_bd_cells /clk_wiz_0]

# Zynq configuration
set_property -dict [list CONFIG.PSU__USE__M_AXI_GP0 {0} CONFIG.PSU__USE__M_AXI_GP1 {0} CONFIG.PSU__USE__M_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]

delete_bd_objs [get_bd_intf_nets zynq_ultra_ps_e_0_M_AXI_HPM0_FPD]

# Enable interrupts
set_property -dict [list CONFIG.PSU__USE__IRQ0 {1}] [get_bd_cells zynq_ultra_ps_e_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0
set_property -dict [list CONFIG.C_IRQ_CONNECTION {1}] [get_bd_cells axi_intc_0]

apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/clk_wiz_0/clk_out2 (200 MHz)} Clk_slave {/clk_wiz_0/clk_out2 (200 MHz)} Clk_xbar {Auto} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD} Slave {/axi_intc_0/s_axi} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_intc_0/s_axi]

connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]

set_property PFM.IRQ {intr { id 0 range 32 }} [get_bd_cells /axi_intc_0]

# Enable AXI Interfaces in Platform Setup
set_property PFM.AXI_PORT {M_AXI_HPM0_FPD {memport "M_AXI_GP" sptag "" memory "" is_range "false"} M_AXI_HPM1_FPD {memport "M_AXI_GP" sptag "" memory "" is_range "false"} S_AXI_HPC0_FPD {memport "S_AXI_HPC" sptag "HPC0" memory "" is_range "false"} S_AXI_HPC1_FPD {memport "S_AXI_HPC" sptag "HPC1" memory "" is_range "false"} S_AXI_HP0_FPD {memport "S_AXI_HP" sptag "HP0" memory "" is_range "false"} S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "" is_range "false"} S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "" is_range "false"} S_AXI_HP3_FPD {memport "S_AXI_HP" sptag "HP3" memory "" is_range "false"}} [get_bd_cells /zynq_ultra_ps_e_0]

set_property PFM.AXI_PORT {M01_AXI {memport "M_AXI_GP" sptag "" memory "" is_range "false"} M02_AXI {memport "M_AXI_GP" sptag "" memory "" is_range "false"} M03_AXI {memport "M_AXI_GP" sptag "" memory "" is_range "false"} M04_AXI {memport "M_AXI_GP" sptag "" memory "" is_range "false"} M05_AXI {memport "M_AXI_GP" sptag "" memory "" is_range "false"} M06_AXI {memport "M_AXI_GP" sptag "" memory "" is_range "false"} M07_AXI {memport "M_AXI_GP" sptag "" memory "" is_range "false"}} [get_bd_cells /ps8_0_axi_periph]


# update platform name
set_property pfm_name {xilinx:zcu104:zcu104-platform:0.0} [get_files -all {design_1.bd}]
set_property platform.name {zcu104-platform} [current_project]
set_property platform.board_id {zcu104} [current_project]
set_property platform.vendor {xilinx} [current_project]

# save design
save_bd_design

# validate_bd_design -force
