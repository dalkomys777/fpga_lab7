# FPGA board clock and reset (verified in LAB6)
set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_50mhz]
create_clock -period 20.000 -name sys_clk [get_ports clk_50mhz]

set_property PACKAGE_PIN K4 [get_ports rst_p]
set_property IOSTANDARD LVCMOS33 [get_ports rst_p]

# PORT A / BreadBoard I/O
# PORT A pin 1 = BDIO_00 = F8 : SPI SCK
# PORT A pin 2 = BDIO_01 = E8 : SPI MOSI
# PORT A pin 3 = BDIO_02 = A7 : SPI CS_N
set_property PACKAGE_PIN F8 [get_ports spi_sck]
set_property PACKAGE_PIN E8 [get_ports spi_mosi]
set_property PACKAGE_PIN A7 [get_ports spi_cs_n]
set_property IOSTANDARD LVCMOS33 [get_ports {spi_sck spi_mosi spi_cs_n}]

# On-board RS232 transmitter (manual pin table: UART_TXD = A3)
set_property PACKAGE_PIN A3 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]

# On-board LEDs LED1..LED8 = led_out[7]..led_out[0]
set_property PACKAGE_PIN L4 [get_ports {led_out[7]}]
set_property PACKAGE_PIN M4 [get_ports {led_out[6]}]
set_property PACKAGE_PIN M2 [get_ports {led_out[5]}]
set_property PACKAGE_PIN N7 [get_ports {led_out[4]}]
set_property PACKAGE_PIN M7 [get_ports {led_out[3]}]
set_property PACKAGE_PIN M3 [get_ports {led_out[2]}]
set_property PACKAGE_PIN M1 [get_ports {led_out[1]}]
set_property PACKAGE_PIN N5 [get_ports {led_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[*]}]
