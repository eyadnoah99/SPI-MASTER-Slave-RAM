/*
Author: Eyad Khaled Mabrouk Noah
Module: spi_Slave
Modelling: RTL
Date: 4/8/2026
*/

module slave (sclk,rstn,ss_n,miso,mosi,rx_data,rx_valid,tx_data,tx_valid);
parameter [2:0] idle=3'b000;
parameter [2:0] check=3'b001;
parameter [2:0] write=3'b010;
parameter [2:0] read_addr=3'b011;
parameter [2:0] read_data=3'b100;
reg [2:0] cs,ns;


parameter data_width=8;

input mosi,sclk,rstn,ss_n,tx_valid;
input [data_width-1:0] tx_data;
output reg miso,rx_valid;
output reg [data_width+1:0] rx_data;

reg [3:0] counter;
reg [3:0] counter_4_read_data;
reg read_addr_flag;  //will be 1 when RAM read 
reg send_data_flag;  //will be 1 when slave send data to master 


always @(posedge sclk or negedge rstn) begin
	if(~rstn) begin
		cs = idle;
	end

	else begin
		cs = ns;
	end
end

always @(*)begin
	case (cs)
	idle:begin
		if(ss_n) ns=idle;
		else ns=check;
	end
	check:begin
		if(ss_n) ns=idle;
		else begin
			if (~mosi) ns = write;

			else if (mosi) begin
				if (read_addr_flag) ns=read_data;
				else begin 
					ns=read_addr;
				end
			end
		end
		end
	write:begin
		if(ss_n) ns=idle;
		else ns=write;
	end
	read_data:begin
		if(ss_n) ns=idle;
		else ns=read_data;
	end
	read_addr:begin
		if(ss_n) ns=idle;
		else ns=read_addr;
	end
	default: ns=idle;
	endcase
end


always @(posedge sclk or negedge rstn) begin
	if (~rstn) begin
		read_addr_flag <= 0;
		rx_valid <= 0;
		rx_data <= 0;
		counter <= 0;
		send_data_flag <= 0;
	end

	else if (ss_n) begin
		counter <= 0;
		rx_valid <= 0;
	end

	else begin
		if(cs == check)begin
			rx_data [9] <= mosi;
			counter  <= counter + 1;
		end
		else if(cs == write)begin
            if (counter < 9) begin
            	rx_data[9 - counter] <= mosi;
                counter  <= counter + 1;
                rx_valid <= 0;
            end 
        else begin 
				rx_data[9 - counter] <= mosi;
                counter  <= 0; 
                rx_valid <= 1;
            end
        end
		else if(cs == read_addr) begin
            if (counter < 9) begin
                rx_data[9 - counter] <= mosi;
                counter  <= counter + 1;
                rx_valid <= 0;
            end 
            else begin
			rx_data[9 - counter] <= mosi;	 
            counter <= 0;
            rx_valid <= 1; 
            end
            read_addr_flag <= 1;
        end
		if(cs == read_data)begin
			if (counter < 9) begin
				rx_data[9 - counter] <= mosi;
				counter <= counter + 1;
				rx_valid <= 0;
			end
			else begin 
				rx_data[9 - counter] <= mosi;
				counter <= 0;
				rx_valid <= 1;
				read_addr_flag <= 0;
				send_data_flag <= 1;
			end
		end
    end
end

always @(*) begin
    if (~ss_n && send_data_flag  && counter_4_read_data < 8) begin
        miso = tx_data[7 - counter_4_read_data];
    end
    else begin
        miso = 0;
    end
end

always @(negedge sclk or negedge rstn) begin
	if (~rstn) begin
		counter_4_read_data <= 0;
	end
	else if (ss_n) begin
		counter_4_read_data <= 0;
	end
	else if (send_data_flag && counter_4_read_data < 8) begin
		counter_4_read_data <= counter_4_read_data + 1;
	end 
	else if (counter_4_read_data == 8) begin
		counter_4_read_data <= 0;            
	end
end
endmodule