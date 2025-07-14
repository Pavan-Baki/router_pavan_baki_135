class router_src_agent_config extends uvm_object;

	`uvm_object_utils(router_src_agent_config)
	
	virtual src_if svif;

	uvm_active_passive_enum is_active = UVM_ACTIVE;

	static int src_drv_count;
	static int src_mon_count;
	
	//constructor new method
	function new(string name="router_src_agent_config");
		super.new(name);	
	endfunction

endclass

