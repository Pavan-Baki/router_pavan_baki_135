class router_src_agt_top extends uvm_env;

	`uvm_component_utils(router_src_agt_top)
	
	router_env_config env_cfg;

 	router_src_agent src_agt[];
	
	//constructor new method
	function new(string name="router_src_agt_top",uvm_component parent);
		super.new(name,parent);	
	endfunction
	
	//build_phase
	virtual function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
				`uvm_fatal(get_type_name(),"NOT GETTING ENV COFIG")
	
		src_agt=new[env_cfg.no_of_sagents];

		foreach(src_agt[i])
	
			begin
				src_agt[i]=router_src_agent::type_id::create($sformatf("src_agt[%0d]",i),this);
				uvm_config_db #(router_src_agent_config)::set(this,$sformatf("src_agt[%0d]*",i),"router_src_agent_config",env_cfg.src_cfg[i]);
			end
	endfunction

endclass
			
	
	
	

