class dst_xtn extends uvm_sequence_item;

	`uvm_object_utils(dst_xtn)

	//coonstructor new method
	function new(string name="dst_xtn");
		super.new(name);
	endfunction
	
	//properties
	bit[7:0]header;
	bit[7:0]payload[];
	bit[7:0]parity;
	rand bit[4:0]no_of_cycles;//using for soft_reset
		
	function void do_print(uvm_printer printer);
		printer.print_field("header",this.header,64,UVM_DEC);
		foreach(payload[i])
		printer.print_field($sformatf("payload[%0d]",i),this.payload[i],64,UVM_DEC);
		printer.print_field("parity",this.parity,8,UVM_DEC);
		printer.print_field("no_of_cycles",this.no_of_cycles,5,UVM_DEC);
	endfunction

endclass
