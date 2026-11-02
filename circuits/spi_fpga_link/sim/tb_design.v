`timescale 1ns/1ps
module tb;
    reg clk=0,rst=1; wire sck,cs_n,mosi; wire [7:0] tx_data,rx_data; wire rx_valid,done;
    integer received=0;
    spi_fpga_link #(.SCK_DIV(4),.GAP_CYCLES(12)) dut(clk,rst,sck,cs_n,mosi,tx_data,rx_data,rx_valid,done);
    always #10 clk=~clk;
    always @(posedge clk) if(rx_valid) begin
        if(received==0 && rx_data!==8'h55) $fatal(1,"first rx=%02h",rx_data);
        if(received==1 && rx_data!==8'hA5) $fatal(1,"second rx=%02h",rx_data);
        received=received+1;
        if(received==2) begin $display("PASS FPGA SPI LINK: master 55/A5 received by slave");$finish;end
    end
    initial begin $dumpfile("wave.vcd");$dumpvars(0,tb);#100;rst=0;#200000;$fatal(1,"timeout");end
endmodule

