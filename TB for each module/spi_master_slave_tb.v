module spi_master_slave_tb ();
reg clk;
reg rstn;
reg start;
reg [9:0] tx_data;
reg [80:0]counter;

wire tx_interrupt;
wire rx_interrupt;
wire [7:0] rx_data;

spi_master_slave DUT(
	.clk(clk),
	.rstn(rstn),
	.start(start),
	.tx_data(tx_data),
	.tx_interrupt(tx_interrupt),
	.rx_interrupt(rx_interrupt),
	.rx_data(rx_data)
	);

always #5 clk=~clk;

	always @(posedge clk) begin
	counter <= counter+1;
	end

initial begin
	clk=0;
	rstn=0;
	start=0;
	counter=0;
	@(negedge clk);
	rstn=1;
	start=1;

	//write data
	tx_data=10'b0011001101;
	repeat(100)begin
		@(negedge clk);
	end

	//write address
	tx_data=10'b0110110011;
	repeat(100) begin
		@(negedge clk);
	end


	//read address
	tx_data=10'b1011001101;
	repeat(100) begin
		@(negedge clk);
	end


	//read data
	tx_data=10'b1100110011;
	repeat(100) begin
		@(negedge clk);
	end

	//write address
	tx_data=10'b0010110011;
	repeat(100) begin
		@(negedge clk);
	end

	
	repeat(100) begin
		@(posedge clk);
	end
	repeat(100) begin
		@(negedge clk);
	end
	$stop;
end
endmodule

