interface src_if (input bit clock);
	
	logic[7:0]data_in;
	logic[7:0]data_out;
	logic reset,error,busy,read_enb,vld_out;
	bit pkt_valid;
	
	clocking src_drv_cb@(posedge clock);
		default input #1 output #1;
		output data_in;
		output pkt_valid;
		output reset;
		input error;
		input busy;
	endclocking
	
	clocking src_mon_cb@(posedge clock);
		default input #1 output #1;
		input data_in;
		input pkt_valid;
		input reset;
		input error;
		input busy;
	endclocking

	modport SDR_MP(clocking src_drv_cb);
	modport SMON_MP(clocking src_mon_cb);

endinterface	

