/*module router_reg(data_in,clk,rst,fifo_full,rst_int_reg,detec_add,ld_state,laf_state,full_state,lfd_state,pkt_valid,parity_done,low_pkt_valid,err,dout);
input clk,rst,fifo_full,rst_int_reg,detec_add,ld_state,laf_state,full_state,lfd_state,pkt_valid;
output reg parity_done,low_pkt_valid,err;
output reg [7:0]dout;
input [7:0]data_in;
reg [7:0]Header_byte;
reg [7:0]Internal_parity;
reg [7:0]packet_parity;
reg [7:0]fifo_full_state_byte;
always@(posedge clk)
begin
if(rst)
dout<=0;
else if(lfd_state)
dout<=Header_byte;
else if(ld_state && ~fifo_full)
dout<=data_in;
else if(laf_state)
dout<=fifo_full_state_byte;
else
dout<=dout;
end

always@(posedge clk)
begin
if(rst)
{Header_byte,fifo_full_state_byte}<=0;
else
begin
if(pkt_valid && detec_add)
Header_byte<=data_in;
else if(ld_state && fifo_full)
fifo_full_state_byte<=data_in;
end
end
always@(posedge clk)
begin
if(rst)
low_pkt_valid<=0;
else
begin
if(rst_int_reg)
low_pkt_valid<=0;
if(~pkt_valid && ld_state)
low_pkt_valid<=1'b1;
end
end

always@(posedge clk)
begin
if(rst)
packet_parity<=0;
else if((ld_state && ~pkt_valid && ~fifo_full) ||(laf_state && low_pkt_valid && ~parity_done))
packet_parity<=data_in;
else if(~pkt_valid && rst_int_reg)
packet_parity<=0;
else
begin
if(detec_add)
packet_parity<=0;
end
end

always@(posedge clk)
begin
if(rst)
Internal_parity<=8'b0;
else if(detec_add)
Internal_parity<=8'b0;
else if(lfd_state)
Internal_parity<=Header_byte;
else if(ld_state && pkt_valid && ~full_state)
Internal_parity<=Internal_parity^data_in;
else if(~pkt_valid && rst_int_reg)
Internal_parity<=0;
end

always@(posedge clk)
begin
if(rst)
err<=0;
else
begin
if(parity_done==1'b1 && (Internal_parity!= packet_parity))
err<=1'b1;
else
err<=0;
end
end
endmodule*/
module router_reg(clock , resetn , pkt_valid , data_in , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state , parity_done , low_pkt_valid , err , dout);

input clock , resetn , pkt_valid , fifo_full , rst_int_reg , detect_add , ld_state , laf_state , full_state , lfd_state;
output reg parity_done , low_pkt_valid , err ;
output reg [7:0] dout;
input  [7:0] data_in;

reg [7:0] hold_header_byte , fifo_full_byte , internal_parity_byte , packet_parity_byte;

// HHB and FFB
always@(posedge clock)
begin
	if(!resetn)
	{hold_header_byte , fifo_full_byte} <= 16'b0;
	else
	begin
		if(detect_add && pkt_valid)
		hold_header_byte <= data_in;
		else if(ld_state && fifo_full)
		fifo_full_byte <= data_in;
		else
		{hold_header_byte , fifo_full_byte} <= {hold_header_byte , fifo_full_byte};
	end
end

//Data out logic
always@(posedge clock)
begin
	if(!resetn)
	dout <= 8'b0;
	else if(lfd_state)
	dout <= hold_header_byte;
	else if(ld_state && (~fifo_full))
	dout <= data_in;
	else if(laf_state)
	dout <= fifo_full_byte;
	else
	dout <= dout;
end

//Low packet valid logic
always@(posedge clock)
begin
	if(!resetn || rst_int_reg)
	low_pkt_valid <= 1'b0;
	else if(ld_state && (!pkt_valid))
	low_pkt_valid <= 1'b1;
	else
	low_pkt_valid <= low_pkt_valid;
end

//Parity done signal logic
always@(posedge clock)
begin
	if(!resetn || detect_add)
	parity_done <= 1'b0;
	else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_pkt_valid && !parity_done))
	parity_done <= 1'b1;
	else
	parity_done <= parity_done;
end

//Packet Parity
always@(posedge clock)
begin
	if(!resetn || detect_add)
	packet_parity_byte <= 8'b0;
	else if(!pkt_valid)
	packet_parity_byte <= data_in;
	else
	packet_parity_byte <= packet_parity_byte;
end

//Internal Parity logic
always@(posedge clock)
begin
	if(!resetn || detect_add)
	internal_parity_byte <= 8'b0;
	else if(pkt_valid && !fifo_full)
	internal_parity_byte <= internal_parity_byte ^ data_in;
	else
	internal_parity_byte <= internal_parity_byte;
end

//Error signal
always@(posedge clock)
begin
	if(!resetn)
	err <= 1'b0;
	else if(!pkt_valid && rst_int_reg)
	begin
		if(internal_parity_byte !== packet_parity_byte)
		err <= 1'b1;
		else
		err <= 1'b0;
	end
	else
	err <= err;
end

endmodule
