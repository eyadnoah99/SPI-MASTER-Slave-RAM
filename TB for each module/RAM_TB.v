module RAM_tb ();
parameter addr_width=8;
parameter data_width=8;
parameter mem_depth=256;

reg clk,rstn,rx_valid;
reg [data_width+1:0] din;
wire tx_valid;
wire [data_width-1:0] dout;

RAM DUT (
	.clk(clk),
	.rstn(rstn),
	.rx_valid(rx_valid),
	.din(din),
	.tx_valid(tx_valid),
	.dout(dout)
	);

always #5 clk=~clk;

initial begin
	clk = 0;
	rstn = 0;
	rx_valid = 0;
	din = 0;
	#20
	rstn = 1;
	din = 10'b0111001100;
	rx_valid = 1;
	#20
	din = 10'b1011001100;
	#20
	din = 10'b1111001100;
	#20
	din = 10'b0111001100;
	#50
	$stop;
end

initial begin
	$monitor("rstn=%0b  rx_valid=%0b  din=%0b  tx_valid=%0b dout=%0b", rstn , rx_valid , din , tx_valid , dout);
end


endmodule