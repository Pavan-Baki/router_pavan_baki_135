class router_dst_seqs extends uvm_sequence#(dst_xtn);
	
	`uvm_object_utils(router_dst_seqs)
	
	//constructor new method	
	function new(string name="router_dst_seqs");
		super.new(name);
	endfunction

	//task body
/*	task body();
		repeat(1)
		begin
			req=dst_xtn::type_id::create("req");
			
			start_item(req);
			assert(req.randomize());
			finish_item(req);
			
		end
	endtask*/

endclass

//No soft reset sequence

class nosoft_reset_seq extends  router_dst_seqs;
`uvm_object_utils(nosoft_reset_seq)

extern function new(string name="nosoft_reset_seq");
extern task body();
endclass

function nosoft_reset_seq::new(string name="nosoft_reset_seq");
	super.new(name);
endfunction

task nosoft_reset_seq::body();
	super.body();
	req=dst_xtn::type_id::create("req");
//	repeat(env_cfg.no_of_packets)
	begin
		start_item(req);
		assert(req.randomize with {no_of_cycles inside{[1:28]};});
		finish_item(req);
	end
endtask


//soft reset sequence

class soft_reset_seq extends  router_dst_seqs;
	`uvm_object_utils(soft_reset_seq)

	extern function new(string name="soft_reset_seq");
	extern task body();
endclass

function soft_reset_seq::new(string name="soft_reset_seq");
	super.new(name);
endfunction

task soft_reset_seq::body();
	super.body();
	req=dst_xtn::type_id::create("req");
//	repeat(env_cfg.no_of_packets)
	begin
		start_item(req);
		assert(req.randomize with {no_of_cycles > 28;});
		finish_item(req);
	end
endtask




