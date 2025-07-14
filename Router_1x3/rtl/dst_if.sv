interface dst_if (input bit clock);
	
	logic[7:0]data_in;
	logic[7:0]data_out;
	logic reset,error,busy,read_enb,vld_out;
	logic pkt_valid;

	clocking dst_drv_cb@(posedge clock);
		default input #1 output #1;
		output read_enb;
                input vld_out;
	endclocking

	clocking dst_mon_cb@(posedge clock);
		default input #1 output #1;
		input read_enb;
		input data_out;
		input vld_out;

	endclocking

	modport DDR_MP(clocking dst_drv_cb);
	modport DMON_MP(clocking dst_mon_cb);
endinterface	


