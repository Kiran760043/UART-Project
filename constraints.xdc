# Clock
set_property PACKAGE_PIN Y9 [get_ports clk]
create_clock -period 100.000 -name CLK -waveform {0.000 50.000} [get_ports clk]
# Voltage settings
set_property IOSTANDARD LVCMOS33 [get_ports clk]


# Reset
set_property PACKAGE_PIN P16 [get_ports rst]
# Voltage settings
set_property IOSTANDARD LVCMOS33 [get_ports rst]
#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]]

#Pmod Pin Tx
set_property IOSTANDARD LVCMOS33 [get_ports din]
set_property PACKAGE_PIN Y10 [get_ports din]

#Pmod Pin Rx
set_property PACKAGE_PIN AA11 [get_ports Tx]
set_property IOSTANDARD LVCMOS33 [get_ports Tx]


#LED
set_property IOSTANDARD LVTTL [get_ports {d_out[0]}]
set_property PACKAGE_PIN T22 [get_ports {d_out[0]}]


set_property IOSTANDARD LVTTL [get_ports {d_out[1]}]
set_property PACKAGE_PIN T21 [get_ports {d_out[1]}]


set_property IOSTANDARD LVTTL [get_ports {d_out[2]}]
set_property PACKAGE_PIN U22 [get_ports {d_out[2]}]


set_property IOSTANDARD LVTTL [get_ports {d_out[3]}]
set_property PACKAGE_PIN U21 [get_ports {d_out[3]}]


set_property IOSTANDARD LVTTL [get_ports {d_out[4]}]
set_property PACKAGE_PIN V22 [get_ports {d_out[4]}]


set_property IOSTANDARD LVTTL [get_ports {d_out[5]}]
set_property PACKAGE_PIN W22 [get_ports {d_out[5]}]


set_property IOSTANDARD LVTTL [get_ports {d_out[6]}]
set_property PACKAGE_PIN U19 [get_ports {d_out[6]}]


set_property IOSTANDARD LVTTL [get_ports {d_out[7]}]
set_property PACKAGE_PIN U14 [get_ports {d_out[7]}]


