`timescale 1ns/1ps

module spi_slave_rx(
    input  wire       clk_50mhz,
    input  wire       rst_p,
    input  wire       spi_sck,
    input  wire       spi_cs_n,
    input  wire       spi_mosi,
    output reg  [7:0] rx_data,
    output reg        rx_valid
);
    reg [1:0] sck_sync = 2'b00;
    reg [1:0] cs_sync = 2'b11;
    reg [1:0] mosi_sync = 2'b00;
    reg       sck_prev = 1'b0;
    reg [7:0] shift = 8'h00;
    reg [2:0] bit_count = 3'd0;

    wire sck_rise = sck_sync[1] & ~sck_prev;

    always @(posedge clk_50mhz) begin
        if (rst_p) begin
            sck_sync <= 2'b00; cs_sync <= 2'b11; mosi_sync <= 2'b00;
            sck_prev <= 1'b0; shift <= 8'h00; bit_count <= 3'd0;
            rx_data <= 8'h00; rx_valid <= 1'b0;
        end else begin
            sck_sync <= {sck_sync[0], spi_sck};
            cs_sync <= {cs_sync[0], spi_cs_n};
            mosi_sync <= {mosi_sync[0], spi_mosi};
            sck_prev <= sck_sync[1];
            rx_valid <= 1'b0;
            if (cs_sync[1]) begin
                bit_count <= 3'd0;
            end else if (sck_rise) begin
                shift <= {shift[6:0], mosi_sync[1]};
                if (bit_count == 3'd7) begin
                    rx_data <= {shift[6:0], mosi_sync[1]};
                    rx_valid <= 1'b1;
                    bit_count <= 3'd0;
                end else begin
                    bit_count <= bit_count + 3'd1;
                end
            end
        end
    end
endmodule

module uart_tx #(
    parameter integer CLK_HZ = 50_000_000,
    parameter integer BAUD = 9600
)(
    input wire clk, input wire rst_p, input wire start,
    input wire [7:0] data, output reg txd, output reg busy
);
    localparam integer DIV = CLK_HZ / BAUD;
    reg [31:0] count = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] frame = 10'h3ff;
    always @(posedge clk) begin
        if (rst_p) begin txd<=1'b1; busy<=1'b0; count<=0; bit_index<=0; frame<=10'h3ff; end
        else if (!busy && start) begin frame<={1'b1,data,1'b0}; busy<=1'b1; count<=0; bit_index<=0; txd<=1'b0; end
        else if (busy && count == DIV-1) begin
            count<=0;
            if (bit_index == 9) begin busy<=1'b0; txd<=1'b1; end
            else begin bit_index<=bit_index+1'b1; txd<=frame[bit_index+1'b1]; end
        end else if (busy) count<=count+1'b1;
    end
endmodule

module spi_slave_top(
    input wire clk_50mhz, input wire rst_p,
    input wire spi_sck, input wire spi_cs_n, input wire spi_mosi,
    output wire uart_txd, output wire [7:0] led_out
);
    wire [7:0] rx_data; wire rx_valid; wire uart_busy;
    spi_slave_rx u_rx(clk_50mhz,rst_p,spi_sck,spi_cs_n,spi_mosi,rx_data,rx_valid);
    uart_tx u_uart(clk_50mhz,rst_p,rx_valid && !uart_busy,rx_data,uart_txd,uart_busy);
    assign led_out = rx_data;
endmodule

