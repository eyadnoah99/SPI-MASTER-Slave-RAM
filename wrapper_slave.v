/*
Author: Eyad Khaled Mabrouk Noah
Module: spi_Wrepper_Slave
Modelling: RTL
Date: 4/8/2026
*/

module wrapper_slave (mosi, miso, ss_n, sclk, rstn);
parameter mem_depth  = 256;
parameter addr_width = 8;
parameter data_width = 8;

parameter [2:0] idle      = 3'b000;
parameter [2:0] check     = 3'b001;
parameter [2:0] write     = 3'b010;
parameter [2:0] read_addr = 3'b011;
parameter [2:0] read_data = 3'b100;

input mosi,sclk,rstn,ss_n;
output miso;

wire rx_valid, tx_valid;
wire [data_width-1:0] tx_data;
wire [data_width+1:0] rx_data;

slave #(
        .idle(idle),
        .check(check),
        .write(write),
        .read_addr(read_addr),
        .read_data(read_data),
        .data_width(data_width)
) slave1 (
        .mosi(mosi),
        .sclk(sclk),
        .rstn(rstn),
        .ss_n(ss_n),
        .miso(miso),
        .rx_valid(rx_valid),
        .rx_data(rx_data), 
        .tx_data(tx_data),
        .tx_valid(tx_valid)
    );

RAM #(
        .data_width(data_width),
        .addr_width(addr_width),
        .mem_depth(mem_depth)
    ) ram1 (
        .sclk(sclk),
        .rstn(rstn),
        .rx_valid(rx_valid),
        .din(rx_data),
        .tx_valid(tx_valid),
        .dout(tx_data)
    );

endmodule