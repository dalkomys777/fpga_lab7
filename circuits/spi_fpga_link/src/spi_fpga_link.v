`timescale 1ns/1ps
module spi_master_core #(parameter integer SCK_DIV=25, GAP_CYCLES=50_000_000)(
    input wire clk,input wire rst,output reg sck,output reg cs_n,output reg mosi,output reg [7:0] tx_data,output reg done);
    reg [31:0] div_count=0,gap_count=0; reg [3:0] edges=0; reg busy=0;
    always @(posedge clk) begin
        if(rst) begin sck<=0;cs_n<=1;mosi<=0;tx_data<=8'h55;done<=0;div_count<=0;gap_count<=0;edges<=0;busy<=0; end
        else begin done<=0;
            if(!busy) begin sck<=0;cs_n<=1;div_count<=0;
                if(gap_count==GAP_CYCLES-1) begin gap_count<=0;busy<=1;cs_n<=0;mosi<=tx_data[7];edges<=0; end
                else gap_count<=gap_count+1;
            end else if(div_count==SCK_DIV-1) begin div_count<=0;
                if(!sck) begin sck<=1;edges<=edges+1; end
                else begin sck<=0;
                    if(edges==8) begin cs_n<=1;busy<=0;done<=1;tx_data<=(tx_data==8'h55)?8'hA5:8'h55; end
                    else mosi<=tx_data[7-edges];
                end
            end else div_count<=div_count+1;
        end
    end
endmodule

module spi_slave_core(input wire clk,input wire rst,input wire sck_in,input wire cs_n_in,input wire mosi_in,
                      output reg [7:0] rx_data,output reg rx_valid);
    reg [1:0] ss=0,cs=3,ms=0; reg prev=0; reg [7:0] shift=0; reg [2:0] count=0;
    wire rise=ss[1]&~prev;
    always @(posedge clk) begin
        if(rst) begin ss<=0;cs<=3;ms<=0;prev<=0;shift<=0;count<=0;rx_data<=0;rx_valid<=0; end
        else begin ss<={ss[0],sck_in};cs<={cs[0],cs_n_in};ms<={ms[0],mosi_in};prev<=ss[1];rx_valid<=0;
            if(cs[1]) count<=0;
            else if(rise) begin shift<={shift[6:0],ms[1]};
                if(count==7) begin rx_data<={shift[6:0],ms[1]};rx_valid<=1;count<=0; end
                else count<=count+1;
            end
        end
    end
endmodule

module spi_fpga_link #(parameter integer SCK_DIV=25,GAP_CYCLES=50_000_000)(
    input wire clk_50mhz,input wire rst_p,output wire spi_sck,output wire spi_cs_n,output wire spi_mosi,
    output wire [7:0] tx_data,output wire [7:0] rx_data,output wire rx_valid,output wire done);
    spi_master_core #(.SCK_DIV(SCK_DIV),.GAP_CYCLES(GAP_CYCLES)) master(clk_50mhz,rst_p,spi_sck,spi_cs_n,spi_mosi,tx_data,done);
    spi_slave_core slave(clk_50mhz,rst_p,spi_sck,spi_cs_n,spi_mosi,rx_data,rx_valid);
endmodule

