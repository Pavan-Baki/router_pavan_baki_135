class router_dst_agt_top extends uvm_env;
	`uvm_component_utils(router_dst_agt_top)
	
	router_env_config env_cfg;
 	router_dst_agent dst_agt[];
//	dst_config dst_cfg[];
	function new(string name="router_dst_agt_top",uvm_component parent);
		super.new(name,parent);	
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
				`uvm_fatal(get_type_name(),"NOT GETTING ENV COFIG")
	
		dst_agt=new[env_cfg.no_of_dagents];
	//	dst_cfg=new[env_cfg.no_of_dagents];

		foreach(dst_agt[i])
	
			begin
		//	dst_cfg[i]=dst_config::type_id::create($sformatf("dst_cfg[%0d]",i));
		//	dst_cfg[i]=env_cfg.dst_cfg[i];
			dst_agt[i]=router_dst_agent::type_id::create($sformatf("dst_agt[%0d]",i),this);
			uvm_config_db #(router_dst_agent_config)::set(this,$sformatf("dst_agt[%0d]*",i),"router_dst_agent_config",env_cfg.dst_cfg[i]);
			
			end
	endfunction

endclass


