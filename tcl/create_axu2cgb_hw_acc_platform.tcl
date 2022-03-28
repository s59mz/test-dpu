start_gui
create_project axu2cgb_2021_2-vivado ./axu2cgb_2021_2-vivado -part xczu2cg-sfvc784-1-e
set_property platform.extensible true [current_project]

create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0
endgroup

# ZYNQ Block Configuration

set_property -dict [list CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} CONFIG.PSU__GEM__TSU__ENABLE {0} CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {0} CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0} CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0} CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 32 .. 33} CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_IO {MIO 37} CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO {MIO 37} CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk1} CONFIG.PSU__PCIE__DEVICE_PORT_TYPE {Root Port} CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x04} CONFIG.SUBPRESET1 {DDR4_MICRON_MT40A256M16GE_083E} CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} CONFIG.PSU__SD0__SLOT_TYPE {eMMC} CONFIG.PSU__SD0__RESET__ENABLE {1} CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} CONFIG.PSU__SD1__GRP_CD__ENABLE {1} CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 24 .. 25} CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} CONFIG.PSU__USB0__RESET__ENABLE {1} CONFIG.PSU__USB0__RESET__IO {MIO 44} CONFIG.PSU__USB__RESET__MODE {Shared MIO Pin} CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane1} CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {APLL} CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {IOPLL} CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL}] [get_bd_cells zynq_ultra_ps_e_0]

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
set_property pfm_name {ailinx:axu2cgb:axu2cgb-platform:0.0} [get_files -all {design_1.bd}]
set_property platform.name {axu2cgb-platform} [current_project]
set_property platform.board_id {axu2cgb} [current_project]
set_property platform.vendor {ailinx} [current_project]

# validate_bd_design -force

