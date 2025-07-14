class router_dst_driver extends uvm_driver#(dst_xtn);
	
	`uvm_component_utils(router_dst_driver)
		
	virtual dst_if.DDR_MP dvif;
	router_dst_agent_config d_cfg;

	//constructor new method
	function new(string name="router_dst_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	//build_phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(router_dst_agent_config)::get(this,"","router_dst_agent_config",d_cfg))
			`uvm_fatal(get_type_name(),"GETTING THE CONFIG HANDLE FAILED")
	endfunction

	//connect_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		dvif=d_cfg.dvif;
	endfunction
	
	//run_phase
	task run_phase(uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();
		end
	endtask

	task drive(dst_xtn xtn);
//	`uvm_info(get_type_name(),$sformatf("driving from rd the data \n %s",xtn.sprint()),UVM_LOW)
		@(dvif.dst_drv_cb);
		while(dvif.dst_drv_cb.vld_out!==1)
			@(dvif.dst_drv_cb);	
			repeat(xtn.no_of_cycles)
				@(dvif.dst_drv_cb);
				dvif.dst_drv_cb.read_enb<=1'b1;
			//	@(dvif.dst_drv_cb);
			while(dvif.dst_drv_cb.vld_out)
			@(dvif.dst_drv_cb);
			dvif.dst_drv_cb.read_enb<=1'b0;
			repeat(2)
			@(dvif.dst_drv_cb);
			`uvm_info(get_type_name(),$sformatf("driving from rd the data \n %s",xtn.sprint()),UVM_LOW)

	endtask	
				
endclass

