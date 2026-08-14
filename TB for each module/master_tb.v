`timescale 1ns / 1ps
module master_tb ();
parameter [1:0] idle = 00;
parameter [1:0] load = 01;
parameter [1:0] transfer = 10;
parameter [1:0] finish = 11;


reg clk,rstn,miso,start;
reg [9:0] tx_data;

wire tx_interrupt,rx_interrupt,cs_n,mosi,sclk;
wire [7:0] rx_data;

master DUT (
	.clk(clk),
	.rstn(rstn),
	.miso(miso),
	.start(start),
	.tx_data(tx_data),
	.tx_interrupt(tx_interrupt),
	.rx_interrupt(rx_interrupt),
	.cs_n(cs_n),
	.mosi(mosi),
	.sclk(sclk),
	.rx_data(rx_data)
	);

always #5 clk = ~clk;

initial begin
	clk=0;
	rstn=0;
	start=0;
	@(posedge clk);


	rstn=1;
	miso=0;
	start=1;
	tx_data = 10'b0011001100;
	repeat(105) begin
		@(posedge clk);
	end

	miso = 0;
	repeat(15)
	@(posedge clk);
	miso =0;
	repeat(15)
	@(posedge clk);
	miso = 1;
	repeat(15)
	@(posedge clk);
	miso = 0;
	repeat(15)
	@(posedge clk);
	miso = 0;
	repeat(15)
	@(posedge clk);
	miso = 1;
	repeat(15)
	@(posedge clk);
	miso = 1;
	repeat(15)
	@(posedge clk);
	miso = 0;
	repeat(15)
	@(posedge clk);
	miso = 0;
	repeat(15)
	@(posedge clk);
	miso = 1;
	repeat(15)
	@(posedge clk)
	repeat(15) begin
	@(posedge clk);
	end
	$stop;
end	

initial begin
	$monitor ("sclk=%0b  tx_interrupt=%0b  rx_interrupt=%0b  cs_n=%0b  rstn=%0b  start=%0b  tx_data=%0b  rx_data=%0b  ", sclk , tx_interrupt , rx_interrupt , cs_n , rstn , start , tx_data , rx_data);
end
endmodule