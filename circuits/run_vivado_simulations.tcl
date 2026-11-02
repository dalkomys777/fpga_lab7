set root [file normalize [file dirname [info script]]]
foreach name {spi_slave spi_master spi_fpga_link} {
    puts "=== VIVADO SIM $name ==="
    open_project [file join $root $name ${name}.xpr]
    launch_simulation
    run all
    close_sim
    close_project
}
exit
