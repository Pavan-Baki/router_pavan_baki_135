class router_src_agent extends uvm_agent;

	`uvm_component_utils(router_src_agent)

	router_src_driver drvh;
	router_src_monitor monh;
	router_src_sequencer seqrh;

	router_src_agent_config src_cfg;
	
	function new(string name="router_src_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",src_cfg))

		`uvm_fatal(get_type_name(),"FAILED GETTING ENV CONFIG")

		monh=router_src_monitor::type_id::create("monh",this);
		if(src_cfg.is_active)
			begin
			drvh=router_src_driver::type_id::create("drvh",this);
			seqrh=router_src_sequencer::type_id::create("seqrh",this);
			end
	endfunction

function void connect_phase(uvm_phase phase);
	if(src_cfg.is_active)
	drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction

endclass



