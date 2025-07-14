class router_dst_agent extends uvm_agent;
	`uvm_component_utils(router_dst_agent)

	router_dst_driver drvh;
	router_dst_monitor monh;
	router_dst_sequencer seqrh;
	router_dst_agent_config dst_cfg;
	
	function new(string name="router_dst_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	if(!uvm_config_db #(router_dst_agent_config) ::get(this,"","router_dst_agent_config",dst_cfg))
		`uvm_fatal(get_type_name(),"FAILED GETTING ENV CONFIG")

		monh=router_dst_monitor::type_id::create("monh",this);
			if(dst_cfg.is_active)
			begin
			drvh=router_dst_driver::type_id::create("drvh",this);
			seqrh=router_dst_sequencer::type_id::create("seqrh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(dst_cfg.is_active==UVM_ACTIVE)
		drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction

endclass


