class router_src_driver extends uvm_driver#(src_xtn);
	
	`uvm_component_utils(router_src_driver)	

	router_src_agent_config s_cfg;

	virtual src_if.SDR_MP svif;

	//constructor new method
	function new(string name="router_src_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	//build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(router_src_agent_config)::get(this,"","router_src_agent_config",s_cfg))
			`uvm_fatal(get_type_name(),"GETTING THE CONFIG HANDLE FAILED")
	endfunction
	
	//connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		svif=s_cfg.svif;
	endfunction
	
	//run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		@(svif.src_drv_cb);
		svif.src_drv_cb.reset<=1'b0;
		@(svif.src_drv_cb);
		svif.src_drv_cb.reset<=1'b1;
		forever
		begin
		seq_item_port.get_next_item(req);
		drive(req);
		seq_item_port.item_done();
		end
	endtask

	task drive(src_xtn xtn);
		
		`uvm_info(get_type_name(),$sformatf("driving the data \n %s",xtn.sprint()),UVM_LOW)

		@(svif.src_drv_cb);
		while(svif.src_drv_cb.busy)
			@(svif.src_drv_cb);
			svif.src_drv_cb.pkt_valid<=1'b1;
			svif.src_drv_cb.data_in<=xtn.header;
			@(svif.src_drv_cb);
			foreach(xtn.payload[i])
				begin
				while(svif.src_drv_cb.busy)
					@(svif.src_drv_cb);
					svif.src_drv_cb.data_in<=xtn.payload[i];
					@(svif.src_drv_cb);
				end
		while(svif.src_drv_cb.busy)
				@(svif.src_drv_cb);
					svif.src_drv_cb.pkt_valid<=1'b0;
					svif.src_drv_cb.data_in<=xtn.parity;
				repeat(2)
				@(svif.src_drv_cb);
			//increment the drive count
			s_cfg.src_drv_count++;
			//xtn.print();
	endtask

	
endclass

