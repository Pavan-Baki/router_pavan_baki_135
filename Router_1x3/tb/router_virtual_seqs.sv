class router_virtual_seqs extends uvm_sequence#(uvm_sequence_item);

	`uvm_object_utils(router_virtual_seqs)

	bit[1:0]addr;

	router_src_sequencer src_seqrh[];
	router_dst_sequencer dst_seqrh[];
	router_env_config env_cfg;
	router_virtual_sequencer vseqrh;

	src_small_pkt_seq	spkth;
	src_medium_pkt_seq	mpkth;
	src_large_pkt_seq	lpkth;
	src_random_pkt_seq	rpkth;
	
	nosoft_reset_seq	nsrsth;
	soft_reset_seq		srsth;

	extern function new(string name = "router_virtual_seqs");
	extern task body();
endclass

function router_virtual_seqs::new(string name = "router_virtual_seqs");
	super.new(name);
endfunction

task router_virtual_seqs::body();
$display("jhgjkhkhkjhkjh");
	if(!uvm_config_db#(router_env_config)::get(null,get_full_name,"router_env_config",env_cfg))
		`uvm_fatal(get_type_name(),"config get failed")
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))
		`uvm_fatal(get_type_name(),"config get failed")

        src_seqrh=new[env_cfg.no_of_sagents];
        dst_seqrh=new[env_cfg.no_of_dagents];


	if(!$cast(vseqrh,m_sequencer))
		`uvm_fatal(get_type_name(),"virtual sequencer cast failed")
	
	foreach(src_seqrh[i])
		src_seqrh[i]=vseqrh.src_seqrh[i];	
	foreach(dst_seqrh[i])
		dst_seqrh[i]=vseqrh.dst_seqrh[i];	

	//if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	//	`uvm_fatal(get_type_name(),"Config get failed")
endtask

//Small packet Virtual sequence

class vsmall_pkt_seqs extends router_virtual_seqs ;
	`uvm_object_utils(vsmall_pkt_seqs)

	extern function new(string name = "vsmall_pkt_seqs");
	extern task body();
endclass

function vsmall_pkt_seqs::new(string name = "vsmall_pkt_seqs");
	super.new(name);
endfunction

task vsmall_pkt_seqs::body();
	super.body();
	spkth = src_small_pkt_seq::type_id::create("spkth");
	nsrsth = nosoft_reset_seq::type_id::create("nsrsth");
	fork
		spkth.start(src_seqrh[0]);
		nsrsth.start(dst_seqrh[addr]);	
	join
endtask


//Medium packet Virtual sequence

class vmedium_pkt_seqs extends router_virtual_seqs;
	`uvm_object_utils(vmedium_pkt_seqs)

	extern function new(string name = "vmedium_pkt_seqs");
	extern task body();
endclass

function vmedium_pkt_seqs::new(string name = "vmedium_pkt_seqs");
	super.new(name);
endfunction

task vmedium_pkt_seqs::body();
	super.body();
	mpkth = src_medium_pkt_seq::type_id::create("mpkth");
	nsrsth = nosoft_reset_seq::type_id::create("nsrsth");
	fork
		mpkth.start(src_seqrh[0]);
		nsrsth.start(dst_seqrh[addr]);	
	join

endtask


//Large packet Virtual sequence

class vlarge_pkt_seqs extends router_virtual_seqs;
	`uvm_object_utils(vlarge_pkt_seqs)

	extern function new(string name = "vlarge_pkt_seqs");
	extern task body();
endclass

function vlarge_pkt_seqs::new(string name = "vlarge_pkt_seqs");
	super.new(name);
endfunction

task vlarge_pkt_seqs::body();
	super.body();
	lpkth = src_large_pkt_seq::type_id::create("lpkth");
	nsrsth = nosoft_reset_seq::type_id::create("nsrsth");
	fork
		lpkth.start(src_seqrh[0]);
		nsrsth.start(dst_seqrh[addr]);	
	join

endtask


//Random packet Virtual sequence

class vrandom_pkt_seqs extends router_virtual_seqs ;
	`uvm_object_utils(vrandom_pkt_seqs)

	extern function new(string name = "vrandom_pkt_seqs");
	extern task body();
endclass

function vrandom_pkt_seqs::new(string name = "vrandom_pkt_seqs");
	super.new(name);
endfunction

task vrandom_pkt_seqs::body();
	super.body();
	rpkth = src_random_pkt_seq::type_id::create("rpkth");
	nsrsth = nosoft_reset_seq::type_id::create("nsrsth");
	fork
		rpkth.start(src_seqrh[0]);
		nsrsth.start(dst_seqrh[addr]);	
	join
endtask

//soft reset virtual sequence

class vsoft_reset_pkt_seqs extends router_virtual_seqs ;
	`uvm_object_utils(vsoft_reset_pkt_seqs)

	extern function new(string name = "vsoft_reset_pkt_seqs");
	extern task body();
endclass

function vsoft_reset_pkt_seqs::new(string name = "vsoft_reset_pkt_seqs");
	super.new(name);
endfunction

task vsoft_reset_pkt_seqs::body();
	super.body();
	rpkth = src_random_pkt_seq::type_id::create("rpkth");
	srsth = soft_reset_seq::type_id::create("srsth");
	fork
		rpkth.start(src_seqrh[0]);
		srsth.start(dst_seqrh[addr]);	
	join

endtask



