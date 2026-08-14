module master (clk,rstn,miso,mosi,cs_n,sclk,tx_interrupt,rx_interrupt,tx_data,rx_data,start);
parameter [1:0] idle = 2'b00;
parameter [1:0] load = 2'b01;
parameter [1:0] transfer = 2'b10;
parameter [1:0] finish = 2'b11;
reg [1:0] cs,ns;

parameter data_width=8;

input clk,rstn,miso,start;
input [data_width+1:0] tx_data;
output reg tx_interrupt,rx_interrupt,cs_n,mosi,sclk;
output reg [data_width-1:0] rx_data;

reg flag_counter;  // wil be 1 when counter counts to 10
reg [3:0] posedge_clk_counter;  //count in posedge
reg [3:0] posedge_sclk_counter; //count in posedge
reg [3:0] negedge_clk_counter;  //count in negedge
reg [3:0] negedge_sclk_counter; //count in negedge
reg [data_width+1:0] tx_shift;
reg [data_width-1:0] rx_shift;

always @(posedge clk or negedge rstn) begin
	if (~rstn) begin
		cs <= idle;
	end

	else  begin
		cs <= ns;
	end
end

always @(*) begin
	case (cs)
	idle:begin
		if (start) ns = load;
		else ns = idle;
	end

	load:begin
		if (~cs_n) ns = transfer;
		else ns = load;
	end

	transfer:begin
		if (flag_counter) ns=finish;
		else ns=transfer;
	end

	finish:begin
		ns = idle;
	end
	endcase
end

always @(posedge clk or negedge rstn) begin
	if (~rstn) begin
		cs_n <= 1;
		rx_interrupt <= 0;
		tx_interrupt <= 0;
		flag_counter <= 0;
		posedge_clk_counter <= 0;
		posedge_sclk_counter <= 0;
		sclk <= 0;
		rx_shift <= 0;
	end

	else begin
		case (cs)
			load:begin
				cs_n <= 0;
				posedge_sclk_counter <= 0;
				posedge_clk_counter <= 0;
			end
			transfer:begin
				if (posedge_clk_counter < 9) begin
					posedge_clk_counter <= posedge_clk_counter+1;
					if (posedge_clk_counter == 4) begin
						sclk <= ~sclk;
					end
				end

				if (posedge_sclk_counter == 9 && posedge_clk_counter == 5) begin
					cs_n <= 1;
				end

				else if (posedge_clk_counter == 9) begin
				posedge_clk_counter <= 0;
				sclk <= ~sclk;

				if(posedge_sclk_counter < 8) begin
					posedge_sclk_counter <= posedge_sclk_counter+1;
					rx_shift [7-posedge_sclk_counter] <= miso;
				end
				else if (posedge_sclk_counter == 8)begin
					posedge_sclk_counter <= posedge_sclk_counter+1;
					rx_data <= rx_shift;
				end
				else if (posedge_sclk_counter == 9) begin
					posedge_sclk_counter <= posedge_sclk_counter+1;
				end
				else begin
					posedge_sclk_counter <= 0;
					posedge_clk_counter <= 0;
					tx_interrupt <= 1;
					rx_interrupt <= 1;
					flag_counter <= 1;
				end
				end
			end
			finish:begin
				cs_n <= 1;
			end
			default:begin
				rx_interrupt <= 0;
				tx_interrupt <= 0;
				flag_counter <= 0;
				posedge_sclk_counter <= 0;
				posedge_clk_counter <= 0;
				sclk <= 0;
			end
		endcase
	end
end	

always @(negedge clk or negedge rstn) begin
	if (~rstn) begin
		negedge_clk_counter <= 0;
		negedge_sclk_counter <= 0;
		tx_shift <= 0;
	end

	else begin
		case (cs) 
			load:begin
				mosi <= tx_data[9];
				tx_shift <= tx_data << 1;
				negedge_sclk_counter <= 0;
			end
			transfer:begin
				if(negedge_clk_counter < 9) begin
					negedge_clk_counter <= negedge_clk_counter+1;
				end
				else if (negedge_clk_counter == 9) begin
					negedge_clk_counter <= 0;
					if (negedge_sclk_counter < 9) begin
						negedge_sclk_counter <= negedge_sclk_counter+1;
						mosi <= tx_shift[9];
						tx_shift <=  tx_shift << 1;
					end
					else begin
						mosi <= tx_shift[9];
						tx_shift <= tx_shift << 1;
						negedge_sclk_counter <= 0;
						negedge_clk_counter <= 0;
					end
				end
			end
		endcase
	end
end
endmodule