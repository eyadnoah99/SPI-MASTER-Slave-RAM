/*
Author: Eyad Khaled Mabrouk Noah
Module: spi_RAM
Modelling: RTL
Date: 4/8/2026
*/

module RAM (sclk,rstn,tx_valid,rx_valid,dout,din);
parameter addr_width=8;
parameter data_width=8;
parameter mem_depth=256;
    
input sclk,rstn,rx_valid;
input [data_width+1:0] din;
output reg tx_valid;
output reg [data_width-1:0] dout;

reg [data_width-1:0] read_adr;
reg [data_width-1:0] write_adr;
reg [data_width-1:0] mem_array [0:mem_depth-1];
reg tx_valid_unstretched;
integer i;

always @(posedge sclk or negedge rstn) begin
    if (~rstn) begin
        for(i=0 ; i<mem_depth ; i=i+1) begin
        	mem_array[i] <= 0;
    	end
        dout <= 0;
        tx_valid_unstretched<= 0; 
        write_adr <= 0;
        read_adr <= 0;
    end

    else begin
       tx_valid_unstretched <= 0;
        if (rx_valid) begin 
            case (din [data_width+1:data_width])
            2'b00: write_adr <= din [data_width-1:0];
            2'b01: begin
                mem_array [write_adr] <= din [data_width-1:0];
            end
            2'b10: read_adr <= din [data_width-1:0];
            2'b11: begin
                dout <= mem_array [read_adr];
                tx_valid_unstretched <= 1;
            end
            endcase
    	end
    end
end
always @(negedge sclk or negedge rstn) begin
    if (~rstn) begin
        tx_valid <= 0;
    end
    else 
    tx_valid <= tx_valid_unstretched;
end
endmodule