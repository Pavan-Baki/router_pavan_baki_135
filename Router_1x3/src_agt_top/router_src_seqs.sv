class router_src_seqs extends uvm_sequence#(src_xtn);

	
	`uvm_object_utils(router_src_seqs)
	
	bit[1:0]addr;


	//constructor new method
	function new(string name="router_src_seqs");
		super.new(name);
	endfunction 

	//task body
	task body;
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	begin
	//	$display("get_full_name=%0s",get_full_name());
		`uvm_fatal(get_type_name(),"not getting")
	end

	/*	repeat(1)
		begin
		req=src_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[1:13]}; header[1:0]==addr;})
		finish_item(req);*/
		
	endtask

endclass

////////////////////////////////////////////////////////////////////////////////////////////

class src_small_pkt_seq extends  router_src_seqs;
`uvm_object_utils(src_small_pkt_seq)

extern function new(string name="src_small_pkt_seq");
extern task body();
endclass

function src_small_pkt_seq::new(string name="src_small_pkt_seq");
	super.new(name);
endfunction

task src_small_pkt_seq::body();
	super.body();
	req=src_xtn::type_id::create("req");
//	repeat(env_cfg.no_of_packets)
	begin
		start_item(req);
		assert(req.randomize with {header[7:2] inside{[1:14]}; header[1:0]==addr;});
		finish_item(req);
	end
endtask
/////////////////////////////////////////////////////////////////////////////////////////////////

class src_medium_pkt_seq extends  router_src_seqs;
`uvm_object_utils(src_medium_pkt_seq)

extern function new(string name="src_medium_pkt_seq");
extern task body();
endclass

function src_medium_pkt_seq::new(string name="src_medium_pkt_seq");
	super.new(name);
endfunction

task src_medium_pkt_seq::body();
	super.body();
	req=src_xtn::type_id::create("req");
	//repeat(env_cfg.no_of_packets)
	begin
		start_item(req);
		assert(req.randomize with {header[7:2] inside{[15:40]}; header[1:0]==addr;});
		finish_item(req);
	end
endtask
///////////////////////////////////////////////////////////////////////////////////////////////////

class src_large_pkt_seq extends  router_src_seqs;
`uvm_object_utils(src_large_pkt_seq)

extern function new(string name="src_large_pkt_seq");
extern task body();
endclass

function src_large_pkt_seq::new(string name="src_large_pkt_seq");
	super.new(name);
endfunction

task src_large_pkt_seq::body();
	super.body();
	req=src_xtn::type_id::create("req");
	//repeat(env_cfg.no_of_packets)
	begin
		start_item(req);
		assert(req.randomize with {header[7:2] inside{[41:63]}; header[1:0]==addr;});
		finish_item(req);
	end
endtask

///////////////////////////////////////////////////////////////////////////////////////////////////

class src_random_pkt_seq extends  router_src_seqs;
`uvm_object_utils(src_random_pkt_seq)

extern function new(string name="src_random_pkt_seq");
extern task body();
endclass

function src_random_pkt_seq::new(string name="src_random_pkt_seq");
	super.new(name);
endfunction

task src_random_pkt_seq::body();
	super.body();
	req=src_xtn::type_id::create("req");
//	repeat(env_cfg.no_of_packets)
	begin
		start_item(req);
		assert(req.randomize with {header[1:0]==addr;});
		finish_item(req);
	end
endtask


