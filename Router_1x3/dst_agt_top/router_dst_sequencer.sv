class router_dst_sequencer extends uvm_sequencer#(dst_xtn);

	`uvm_component_utils(router_dst_sequencer)

	//constructor new method
	function new(string name="router_dst_sequencer",uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass

