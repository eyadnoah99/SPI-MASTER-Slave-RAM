module spi_master_slave (rstn,start,clk,tx_data,rx_data,rx_interrupt,tx_interrupt); 
parameter mem_depth  = 256;
parameter addr_width = 8;
parameter data_width = 8;
parameter [2:0] idle_slave      = 3'b000;
parameter [2:0] check     = 3'b001;
parameter [2:0] write     = 3'b010;
parameter [2:0] read_addr = 3'b011;
parameter [2:0] read_data = 3'b100;


parameter [1:0] idle = 00;
parameter [1:0] load = 01;
parameter [1:0] transfer = 10;
parameter [1:0] finish = 11;

input clk;
input rstn;
input start;
input [data_width+1:0] tx_data;
output tx_interrupt;
output rx_interrupt;
output [data_width-1:0] rx_data;

wire miso,mosi,cs_n_tb,sclk_tb;

wrapper_slave #(
		.mem_depth(mem_depth),
		.addr_width(addr_width),
		.data_width(data_width),
		.idle(idle_slave),
		.check(check),
		.write(write),
		.read_addr(read_addr),
		.read_data(read_data)
) wrapper_slave_1 (
		.miso(miso),
		.mosi(mosi),
		.sclk(sclk_tb),
		.ss_n(cs_n_tb),
		.rstn(rstn)
	);

master #(
		.idle(idle),
		.load(load),
		.transfer(transfer),
		.finish(finish),
		.data_width(data_width)
	) master1 (
		.miso(miso),
		.mosi(mosi),
		.clk(clk),
		.rstn(rstn),
		.start(start),
		.cs_n(cs_n_tb),
		.tx_data(tx_data),
		.rx_data(rx_data),
		.tx_interrupt(tx_interrupt),
		.rx_interrupt(rx_interrupt),
		.sclk(sclk_tb)
	);

endmodule