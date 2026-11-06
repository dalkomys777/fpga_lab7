# FPGA board clock and reset (verified in LAB6)
set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_50mhz]
create_clock -period 20.000 -name sys_clk [get_ports clk_50mhz]

set_property PACKAGE_PIN K4 [get_ports rst_p]
set_property IOSTANDARD LVCMOS33 [get_ports rst_p]

# PORT A / BreadBoard I/O. Use the same order at the receiving FPGA.
# PORT A pin 1 = BDIO_00 = F8 : SPI SCK
# PORT A pin 2 = BDIO_01 = E8 : SPI MOSI
# PORT A pin 3 = BDIO_02 = A7 : SPI CS_N
set_property PACKAGE_PIN F8 [get_ports spi_sck]
set_property PACKAGE_PIN E8 [get_ports spi_mosi]
set_property PACKAGE_PIN A7 [get_ports spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_sck spi_mosi spi_cs_n}]

# Received byte on the eight on-board LEDs.
set_property PACKAGE_PIN L4 [get_ports {rx_data[7]}]
set_property PACKAGE_PIN M4 [get_ports {rx_data[6]}]
set_property PACKAGE_PIN M2 [get_ports {rx_data[5]}]
set_property PACKAGE_PIN N7 [get_ports {rx_data[4]}]
set_property PACKAGE_PIN M7 [get_ports {rx_data[3]}]
set_property PACKAGE_PIN M3 [get_ports {rx_data[2]}]
set_property PACKAGE_PIN M1 [get_ports {rx_data[1]}]
set_property PACKAGE_PIN N5 [get_ports {rx_data[0]}]

# Debug outputs on unused expansion pins EXT1..EXT10.
set_property PACKAGE_PIN G10 [get_ports {tx_data[7]}]
set_property PACKAGE_PIN C10 [get_ports {tx_data[6]}]
set_property PACKAGE_PIN F11 [get_ports {tx_data[5]}]
set_property PACKAGE_PIN D11 [get_ports {tx_data[4]}]
set_property PACKAGE_PIN A11 [get_ports {tx_data[3]}]
set_property PACKAGE_PIN E12 [get_ports {tx_data[2]}]
set_property PACKAGE_PIN A12 [get_ports {tx_data[1]}]
set_property PACKAGE_PIN F13 [get_ports {tx_data[0]}]
set_property PACKAGE_PIN C13 [get_ports rx_valid]
set_property PACKAGE_PIN A13 [get_ports done]
set_property IOSTANDARD LVCMOS33 [get_ports {rx_data[*] tx_data[*] rx_valid done}]
