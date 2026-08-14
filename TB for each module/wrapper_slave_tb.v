`timescale 1ns / 1ps
module wrapper_slave_tb_new ();
parameter mem_depth  = 256;
parameter addr_width = 8;
parameter data_width = 8;

parameter [2:0] idle      = 3'b000;
parameter [2:0] check     = 3'b001;
parameter [2:0] write     = 3'b010;
parameter [2:0] read_addr = 3'b011;
parameter [2:0] read_data = 3'b100;

reg sclk;
reg rstn;
reg ss_n;
reg mosi;
wire miso;

wrapper_slave_new dut (
        .mosi(mosi),
        .miso(miso),
        .ss_n(ss_n),
        .sclk(sclk),
        .rstn(rstn)
    );
always #5 sclk = ~sclk; 

initial begin
        sclk=0;
        rstn=0;
        mosi=0; 
        repeat(5)
                @(negedge sclk);


        rstn=1;
        // write address
        ss_n=0;
        @(negedge sclk);
        mosi=0;
        @(negedge sclk);
        mosi=0;
        @(negedge sclk);
                mosi=1;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);

        ss_n=1;
        repeat(5)
                @(negedge sclk);


        // write data
        ss_n=0;
        @(negedge sclk);
        mosi=0;
        @(negedge sclk);
        mosi=1;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=1;
        @(negedge sclk);
                mosi=1;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=1;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
                mosi=0;
        @(negedge sclk);
        /* repeat(8) begin
                mosi = $random;
                @(negedge clk);
        end*/
        @(negedge sclk);
        ss_n=1;
        repeat(5)
                @(negedge sclk);

        // read addres
        ss_n=0;
        @(negedge sclk);
        mosi=1;
        @(negedge sclk);
        mosi=0;
                @(negedge sclk);
                mosi=1;
                        @(negedge sclk);
                mosi=0;
                        @(negedge sclk);
                mosi=0;
                        @(negedge sclk);
                mosi=0;
                        @(negedge sclk);
                mosi=0;
                        @(negedge sclk);
                mosi=0;
                        @(negedge sclk);
                mosi=0;
                        @(negedge sclk);
                mosi=0;

        @(negedge sclk);
        ss_n=1;
        repeat(5)
                @(negedge sclk);

        //read data
        ss_n=0;
        @(negedge sclk);
        mosi=1;
        @(negedge sclk);
        mosi=1;
        @(negedge sclk);

        repeat(8) begin
                mosi = $random;
                @(negedge sclk);
        end
        repeat(10) begin
                @(negedge sclk);
        end
        // --------------------------

        @(negedge sclk);
        ss_n=1;
        repeat(5)
                @(negedge sclk)


 
        $stop;
end

initial begin
        $monitor("rstn=%0b  ss_n=%0b  mosi=%0b internal_reg=%0b  rx_data=%0b  rx_valid=%0b  tx_data=%0b  tx_valid=%0b  write_adr=%0b  read_adr=%0b  ", rstn , ss_n , mosi , dut.slave1.internal_register , dut.slave1.rx_data , dut.slave1.rx_valid , dut.slave1.tx_data , dut.slave1.tx_valid , dut.ram1.write_adr , dut.ram1.read_adr);
end
endmodule