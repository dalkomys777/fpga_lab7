`timescale 1ns/1ps
module spi_master_tx #(
    parameter integer SCK_DIV=25,
    parameter integer GAP_CYCLES=50_000_000
)(
    input wire clk_50mhz, input wire rst_p,
    output reg spi_sck, output reg spi_cs_n, output reg spi_mosi,
    output reg [7:0] tx_data, output reg done
);
    reg [31:0] div_count=0, gap_count=0;
    reg [3:0] edge_count=0;
    reg busy=0;
    always @(posedge clk_50mhz) begin
        if(rst_p) begin spi_sck<=0;spi_cs_n<=1;spi_mosi<=0;tx_data<=8'h55;done<=0;div_count<=0;gap_count<=0;edge_count<=0;busy<=0; end
        else begin
            done<=0;
            if(!busy) begin
                spi_sck<=0;spi_cs_n<=1;div_count<=0;
                if(gap_count==GAP_CYCLES-1) begin gap_count<=0;busy<=1;spi_cs_n<=0;spi_mosi<=tx_data[7];edge_count<=0; end
                else gap_count<=gap_count+1;
            end else if(div_count==SCK_DIV-1) begin
                div_count<=0;
                if(!spi_sck) begin spi_sck<=1; edge_count<=edge_count+1; end
                else begin
                    spi_sck<=0;
                    if(edge_count==8) begin spi_cs_n<=1;busy<=0;done<=1;tx_data<=(tx_data==8'h55)?8'hA5:8'h55; end
                    else spi_mosi<=tx_data[7-edge_count];
                end
            end else div_count<=div_count+1;
        end
    end
endmodule

module spi_master_top(input wire clk_50mhz,input wire rst_p,output wire spi_sck,output wire spi_cs_n,output wire spi_mosi);
    wire [7:0] tx_data; wire done;
    spi_master_tx u_tx(clk_50mhz,rst_p,spi_sck,spi_cs_n,spi_mosi,tx_data,done);
endmodule

