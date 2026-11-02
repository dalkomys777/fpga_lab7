set root [file normalize [file dirname [info script]]]
foreach spec {
    {spi_slave spi_slave_top}
    {spi_master spi_master_top}
    {spi_fpga_link spi_fpga_link}
} {
    lassign $spec name top
    set dir [file join $root $name]
    create_project $name $dir -part xc7s75fgga484-1 -force
    add_files [glob -nocomplain [file join $dir src *.v]]
    add_files -fileset sim_1 [glob -nocomplain [file join $dir sim *.v]]
    set_property top $top [current_fileset]
    set_property top tb [get_filesets sim_1]
    set_property target_simulator XSim [current_project]
    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
    close_project
}
exit

