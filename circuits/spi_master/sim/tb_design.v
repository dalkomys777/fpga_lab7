`timescale 1ns/1ps
module tb;
    reg clk=0,rst=1; wire sck,cs_n,mosi; wire [7:0] tx_data; wire done;
    reg [7:0] received=0; integer bits=0,frames=0;
    spi_master_tx #(.SCK_DIV(2),.GAP_CYCLES(8)) dut(clk,rst,sck,cs_n,mosi,tx_data,done);
    always #10 clk=~clk;
    always @(posedge sck) if(!cs_n) begin received={received[6:0],mosi}; bits=bits+1; end
    always @(posedge cs_n) if(bits!=0) begin
        if(bits!=8) $fatal(1,"bits=%0d",bits);
        if(frames==0 && received!==8'h55) $fatal(1,"first=%02h",received);
        if(frames==1 && received!==8'hA5) $fatal(1,"second=%02h",received);
        frames=frames+1;bits=0;received=0;
        if(frames==2) begin $display("PASS SPI MASTER: Mode0 55 A5, 8 clocks, <=1MHz parameterized"); $finish; end
    end
    initial begin $dumpfile("wave.vcd");$dumpvars(0,tb);#100;rst=0;#100000;$fatal(1,"timeout");end
endmodule

