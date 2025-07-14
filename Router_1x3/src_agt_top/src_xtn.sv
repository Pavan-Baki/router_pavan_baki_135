class src_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(src_xtn)



	rand bit [7:0]header;
	rand bit [7:0]payload[];
	bit [7:0]parity;
	bit error;

		
	//constructor new method
	function new(string name="src_xtn");
		super.new(name);
	endfunction

	//properties

	//constraint
	constraint a1{header[1:0]!=2'b11;}
	constraint a2{payload.size==header[7:2];}
	constraint a3{payload.size inside{[1:63]};}

	function void post_randomize();
		parity=header^0;
		foreach(payload[i])
			parity=parity^payload[i];
	endfunction

	function void do_print(uvm_printer printer);
		printer.print_field("header",this.header,64,UVM_DEC);
		foreach(payload[i])
		printer.print_field($sformatf("payload[%0d]",i),this.payload[i],64,UVM_DEC);
		printer.print_field("parity",this.parity,8,UVM_DEC);

	endfunction

endclass

	//for error
	class bad_xtn extends src_xtn;
		`uvm_object_utils(bad_xtn)

		function new(string name = "bad_xtn");
			super.new(name);
		endfunction

		function void post_randomize();
			super.post_randomize();
			parity=parity+1;
		endfunction 

	endclass
	
