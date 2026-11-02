`timescale 1ns/1ps
module tb;
    reg clk=0,rst=1,sck=0,cs_n=1,mosi=0;
    wire [7:0] rx_data; wire rx_valid;
    integer valid_count=0;
    spi_slave_rx dut(clk,rst,sck,cs_n,mosi,rx_data,rx_valid);
    always #10 clk=~clk;
    always @(posedge clk) if(rx_valid) valid_count=valid_count+1;
    task send_byte(input [7:0] value); integer i; begin
        cs_n=0; #200;
        for(i=7;i>=0;i=i-1) begin mosi=value[i]; #200; sck=1; #200; sck=0; #200; end
        cs_n=1; #400;
        if(rx_data!==value) $fatal(1,"expected=%02h got=%02h",value,rx_data);
    end endtask
    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0,tb);
        #100; rst=0; #200;
        send_byte(8'h55); send_byte(8'hA5); send_byte(8'h00); send_byte(8'hFF);
        cs_n=1; mosi=1; repeat(4) begin #200;sck=1;#200;sck=0; end
        if(valid_count!=4) $fatal(1,"valid_count=%0d",valid_count);
        $display("PASS SPI SLAVE: 55 A5 00 FF, CS ignore, one valid per byte"); $finish;
    end
endmodule

