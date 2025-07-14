/*module router_sync(detec_add,clk,rst,empty_0,empty_1,empty_2,full_0,full_1,full_2,read_0,read_1,read_2,valid_0,valid_1,valid_2,fifo_full,soft_rst_0,soft_rst_1,soft_rst_2,write_enb,data_in,write_en_reg);
input detec_add,clk,rst,empty_0,empty_1,empty_2,full_0,full_1,full_2,read_0,read_1,read_2,write_en_reg;
input [1:0]data_in;
output reg [2:0]write_enb;
reg [1:0]int_addr_reg;
reg [4:0]timer_0,timer_1,timer_2;
output reg soft_rst_0,soft_rst_1,soft_rst_2;
output reg fifo_full;
output valid_0,valid_1,valid_2;
always@(posedge clk)
begin
if(rst)
int_addr_reg<=0;
else if(detec_add)
int_addr_reg<=data_in;
end
always@(*)
begin
write_enb=3'b000;
if(write_en_reg)
begin
case(int_addr_reg)
2'b00:write_enb=3'b001;
2'b01:write_enb=3'b010;
2'b10:write_enb=3'b100;
default :write_enb=3'b000;
endcase
end
end
always@(*)
begin
case(int_addr_reg)
2'b00:fifo_full=full_0;
2'b01:fifo_full=full_1;
2'b10:fifo_full=full_2;
default :fifo_full=1'b0;
endcase
end
assign valid_0=~empty_0;
assign valid_1=~empty_1;
assign valid_2=~empty_2;
always@(posedge clk)
begin
if(rst)
begin
timer_0<=0;
soft_rst_0<=0;
end
else if(valid_0)
begin
if(!read_0)
begin
if(timer_0==5'd29)
begin
soft_rst_0<=1'b1;
timer_0<=0;
end
else 
begin
soft_rst_0<=0;
timer_0<=timer_0+1'b1;
end
end
end
end
always@(posedge clk)
begin
if(rst)
begin
timer_1<=0;
soft_rst_1<=0;
end
else if(valid_1)
begin
if(!read_1)
begin
if(timer_1==5'd29)
begin
soft_rst_1<=1'b1;
timer_1<=0;
end
else 
begin
soft_rst_1<=0;
timer_1<=timer_1+1'b1;
end
end
end
end
always@(posedge clk)
begin
if(rst)
begin
timer_2<=0;
soft_rst_2<=0;
end
else if(valid_2)
begin
if(!read_2)
begin
if(timer_2==5'd29)
begin
soft_rst_2<=1'b1;
timer_2<=0;
end
else 
begin
soft_rst_2<=0;
timer_2<=timer_2+1'b1;
end
end
end
end
endmodule*/
module router_sync(detect_add , data_in , write_enb_reg , clock , resetn , vld_out_0 , vld_out_1 , vld_out_2 , read_enb_0 , read_enb_1 , read_enb_2 , write_enb , fifo_full , empty_0 , empty_1 , empty_2 , soft_reset_0 , soft_reset_1 , soft_reset_2 , full_0 , full_1 , full_2);

input detect_add ,write_enb_reg , clock , resetn , read_enb_0 , read_enb_1 , read_enb_2 , full_0 , full_1 , full_2 , empty_0 , empty_1 , empty_2;
input [1:0] data_in;
output vld_out_0 , vld_out_1 , vld_out_2 ;
output reg fifo_full , soft_reset_0 , soft_reset_1 , soft_reset_2 ;
output reg [2:0] write_enb;

reg [1:0] int_addr;
reg [4:0] counter_0 , counter_1 , counter_2;

//logic for latching address
always@(posedge clock)
begin
	if(!resetn)
	int_addr <= 2'b11;
	else if(detect_add)
	int_addr <= data_in;
	else
	int_addr <= int_addr;
end

//logic for valid
assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

//logic for write enable
always@(*)
begin
	if(!resetn)
	write_enb = 3'b0;
	else if(write_enb_reg)
	begin
		case(int_addr)
			2'b00 : write_enb = 3'b001;
			2'b01 : write_enb = 3'b010;
			2'b10 : write_enb = 3'b100;
			default: write_enb = 3'b0;
		endcase
	end
	else
	write_enb = 3'b0;
end

//logic for full
always@(*)
begin
	if(!resetn)
	fifo_full = 1'b0;
	else
	begin
		case (int_addr)
		2'b00: fifo_full = full_0;
		2'b01: fifo_full = full_1;
		2'b10: fifo_full = full_2;
		default: fifo_full = 0;
		endcase
	end
end

//logic for soft reset
always@(posedge clock)
begin
	if(!resetn)
	begin
		counter_0<=5'b0;
		counter_1<=5'b0;
		counter_2<=5'b0;
		soft_reset_0 <= 1'b0;
		soft_reset_1 <= 1'b0;
		soft_reset_2 <= 1'b0;
	end
	else
	begin
		case(int_addr)
			2'b00 : begin
						if(vld_out_0)
						begin
							counter_0 <= counter_0 + 5'b1;
							if(read_enb_0)
							begin
								counter_0 <= 5'b0;
								soft_reset_0 <= 1'b0;
							end
							else if(counter_0 === 5'b11101)
							soft_reset_0 <= 1'b1;
						end
						else
						soft_reset_0 <= 0;
					end
			2'b01 : begin
						if(vld_out_1)
						begin
							counter_1 <= counter_1 + 5'b1;
							if(read_enb_1)
							begin
								counter_1 <= 5'b0;
								soft_reset_1 <= 1'b0;
							end
							else if(counter_1 === 5'b11101)
							soft_reset_1 <= 1'b1;
						end
						else
						soft_reset_1 <= 1'b0;
					end
			2'b10 : begin
						if(vld_out_2)
						begin
							counter_2 <= counter_2 + 5'b1;
							if(read_enb_2)
							begin
								counter_2 <= 5'b0;
								soft_reset_2 <= 1'b0;
							end
							else if(counter_2 === 5'b11101)
							soft_reset_2 <= 1'b1;
						end
						else
						soft_reset_2 <= 1'b0;
					end
			default : begin
							soft_reset_0 <= 1'b0;
							soft_reset_1 <= 1'b0;
							soft_reset_2 <= 1'b0;
					  end
			
		endcase
	end
end

endmodule
