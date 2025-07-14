class router_env_config extends uvm_object;
	
	`uvm_object_utils(router_env_config)
	
	bit has_sagent;
	bit has_dagent;
	router_src_agent_config src_cfg[];
	router_dst_agent_config dst_cfg[];

	bit has_virtual_sequencer;
	int no_of_sagents;
	int no_of_dagents;
	bit has_scoreboard;
	int no_of_packets;
	
	//condtructor new method
	function new(string name="router_env_config");
		super.new(name);
	endfunction

endclass


