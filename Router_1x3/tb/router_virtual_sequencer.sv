class router_virtual_sequencer extends uvm_sequencer;
	
	`uvm_component_utils(router_virtual_sequencer)

	router_src_sequencer src_seqrh[];
	router_dst_sequencer dst_seqrh[];

	router_env_config env_cfg;
	
	//constructor new method
	function new(string name="router_virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",env_cfg))
			`uvm_fatal(get_type_name(),"Config get failed")
		src_seqrh=new[env_cfg.no_of_sagents];
		dst_seqrh=new[env_cfg.no_of_dagents];
	endfunction



endclass 
