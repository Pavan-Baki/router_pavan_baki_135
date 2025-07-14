module top;
		import router_test_pkg::*;
		import uvm_pkg::*;
	`include "uvm_macros.svh"

	bit clock=0;
	always #5 clock=~clock;

	
	src_if in(clock);
	dst_if in0(clock);
	dst_if in1(clock);
	dst_if in2(clock);




//	router_top DUT(.clk(clock),.rst(in.reset),.read_0(in0.read_enb),.read_1(in1.read_enb),.read_2(in2.read_enb),.pkt_valid(in.pkt_valid),
	    	//	.data_in(in.data_in),.data_out_0(in0.data_out),.data_out_1(in1.data_out),.data_out_2(in2.data_out),
    		//	.valid_0(in0.vld_out),.valid_1(in1.vld_out),.valid_2(in2.vld_out),.err(in.error),.busy(in.busy));
	router_1x3 DUV(.clock(in.clock),
			.resetn(in.reset),
			.pkt_valid(in.pkt_valid),
			.data_in(in.data_in),
			.busy(in.busy),
			.error(in.error),
			.read_enb_0(in0.read_enb),
			.valid_out_0(in0.vld_out),
			.data_out_0(in0.data_out),
			.read_enb_1(in1.read_enb),
			.valid_out_1(in1.vld_out),
			.data_out_1(in1.data_out),
			.read_enb_2(in2.read_enb),
			.valid_out_2(in2.vld_out),
			.data_out_2(in2.data_out));




	initial 
		begin

		`ifdef VCS
		 $fsdbDumpvars(0,top);
		`endif

		uvm_config_db #(virtual src_if)::set(null,"*","svif",in);
		uvm_config_db #(virtual dst_if)::set(null,"*","dvif_0",in0);
		uvm_config_db #(virtual dst_if)::set(null,"*","dvif_1",in1);
		uvm_config_db #(virtual dst_if)::set(null,"*","dvif_2",in2);
		run_test();

		end
endmodule

