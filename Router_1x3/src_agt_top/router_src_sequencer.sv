class router_src_sequencer extends uvm_sequencer#(src_xtn);

	`uvm_component_utils(router_src_sequencer)

	//constructor new method
	function new(string name="router_src_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

endclass
