class router_base_test extends uvm_test;
	
	`uvm_component_utils(router_base_test)
	
	//declarations
	router_tb envh;
	router_env_config env_cfg;
	router_src_agent_config src_m_cfg[];
	router_dst_agent_config dst_m_cfg[];
	int no_of_sagents=1;
	int no_of_dagents=3;
	bit has_scoreboard=1;
	bit has_sagent=1;
	bit has_dagent=1;
	bit has_virtual_sequencer=1;
	int no_of_packets=30;

	bit[1:0]addr;

	//router_seqs declaration
	router_src_seqs src_seqh;
	router_dst_seqs dst_seqh;
	
	//constructor new method
	function new(string name="router_base_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	//build phase
	function void build_phase(uvm_phase phase);
	
		env_cfg=router_env_config::type_id::create("env_cfg");
	
		if(has_sagent)
		begin 
			src_m_cfg=new[no_of_sagents];
			env_cfg.src_cfg=new[no_of_sagents];
		end

		foreach(src_m_cfg[i])
		begin
		src_m_cfg[i]=router_src_agent_config::type_id::create($sformatf("src_m_cfg[%0d]",i));
		if(!uvm_config_db#(virtual src_if)::get(this,"","svif",src_m_cfg[i].svif))
			`uvm_fatal(get_type_name(),"GETTING THE INTERFACE FAILED")
		src_m_cfg[i].is_active=UVM_ACTIVE;
		env_cfg.src_cfg[i]=src_m_cfg[i];
		end
	
	
  		if(has_dagent)

		begin 
			dst_m_cfg=new[no_of_dagents];
			env_cfg.dst_cfg=new[no_of_dagents];
		end

		foreach(dst_m_cfg[i])

		begin
		dst_m_cfg[i]=router_dst_agent_config::type_id::create($sformatf("dst_m_cfg[%0d]",i));
		if(!uvm_config_db#(virtual dst_if)::get(this,"",$sformatf("dvif_%0d",i),dst_m_cfg[i].dvif))
			`uvm_fatal(get_type_name(),"GETTING THE INTERFACE FAILED")

		dst_m_cfg[i].is_active=UVM_ACTIVE; 
		env_cfg.dst_cfg[i]=dst_m_cfg[i];
	
		end
		
		env_cfg.no_of_sagents=no_of_sagents;
		env_cfg.no_of_dagents=no_of_dagents;
		env_cfg.has_scoreboard=has_scoreboard;
		env_cfg.has_sagent=has_sagent;
		env_cfg.has_dagent=has_dagent;
		env_cfg.has_virtual_sequencer=has_virtual_sequencer;
		uvm_config_db #(router_env_config)::set(this,"*","router_env_config",env_cfg);

	//	addr=$urandom_range(0,2);
	//	uvm_config_db#(bit[1:0])::set(this,"*","bit [1:0]",addr);

		super.build_phase(phase);
		envh=router_tb::type_id::create("envh",this);

				
		endfunction:build_phase


	//end of elaboration phase
	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

	//run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		/*src_seqh=router_src_seqs::type_id::create("src_seqh");
		dst_seqh=router_dst_seqs::type_id::create("dst_seqh");
		phase.raise_objection(this);
		repeat(3)
		fork
		src_seqh.start(envh.src_agtop.src_agt[0].seqrh);
		dst_seqh.start(envh.dst_agtop.dst_agt[0].seqrh);
		join
		phase.drop_objection(this);*/
	endtask
	
endclass

/////////////////////////////////////////////////////////////////////////////////////////////////////

class router_small_pkt_test extends router_base_test;
`uvm_component_utils(router_small_pkt_test)

vsmall_pkt_seqs svsh;

extern function new(string name="router_small_pkt_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function router_small_pkt_test::new(string name="router_small_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_small_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task router_small_pkt_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
        phase.raise_objection(this);
        svsh=vsmall_pkt_seqs::type_id::create("svsh");
	repeat(no_of_packets)
	begin
	addr={$random}%3;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	svsh.start(envh.vseqrh);
	end
        phase.drop_objection(this);

endtask


//Medium Packet Test class

class router_medium_pkt_test extends router_base_test;
`uvm_component_utils(router_medium_pkt_test)
vmedium_pkt_seqs  mvsh;

extern function new(string name="router_medium_pkt_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function router_medium_pkt_test::new(string name="router_medium_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_medium_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task router_medium_pkt_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
        phase.raise_objection(this);
        mvsh=vmedium_pkt_seqs::type_id::create("mvsh");
	repeat(no_of_packets)
	begin
	addr={$random}%3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
	mvsh.start(envh.vseqrh);
	end
        phase.drop_objection(this);

endtask


//Large Packet Test class

class router_large_pkt_test extends router_base_test;
`uvm_component_utils(router_large_pkt_test)
vlarge_pkt_seqs lvsh;

extern function new(string name="router_large_pkt_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function router_large_pkt_test::new(string name="router_large_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_large_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task router_large_pkt_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
        phase.raise_objection(this);
        lvsh=vlarge_pkt_seqs::type_id::create("lvsh");
	repeat(no_of_packets)
	begin
	addr={$random}%3;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	lvsh.start(envh.vseqrh);
	end
        phase.drop_objection(this);

endtask


//Random Packet Test class

class router_random_pkt_test extends router_base_test;
`uvm_component_utils(router_random_pkt_test)
vrandom_pkt_seqs  rvsh;

extern function new(string name="router_random_pkt_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function router_random_pkt_test::new(string name="router_random_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_random_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task router_random_pkt_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
        phase.raise_objection(this);
        rvsh=vrandom_pkt_seqs::type_id::create("rvsh");
	repeat(no_of_packets)
	begin 
	addr={$random}%3;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	rvsh.start(envh.vseqrh);
	end

        phase.drop_objection(this);

endtask

//soft_reset_pkt_test
class router_soft_reset_pkt_test extends router_base_test;
`uvm_component_utils(router_soft_reset_pkt_test)
vsoft_reset_pkt_seqs srvsh;
extern function new(string name ="router_soft_reset_pkt_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase );

endclass

function router_soft_reset_pkt_test::new(string name ="router_soft_reset_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_soft_reset_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task router_soft_reset_pkt_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);
	srvsh=vsoft_reset_pkt_seqs::type_id::create("srsvh");
	repeat(no_of_packets)
	begin 
	addr={$random}%3;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	srvsh.start(envh.vseqrh);
	end

	phase.drop_objection(this);
endtask

// error packet test class	
class router_error_pkt_test extends router_base_test;
`uvm_component_utils(router_error_pkt_test)
vrandom_pkt_seqs rvsh;

extern function new(string name="router_error_pkt_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function router_error_pkt_test::new(string name="router_error_pkt_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_error_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	factory.set_type_override_by_type(src_xtn::get_type,bad_xtn::get_type);
endfunction

task router_error_pkt_test::run_phase(uvm_phase phase);
	super.run_phase(phase);
        phase.raise_objection(this);
        rvsh=vrandom_pkt_seqs::type_id::create("rvsh");
	repeat(no_of_packets)
	begin
	addr={$random}%3;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	rvsh.start(envh.vseqrh);
        end
	phase.drop_objection(this);

endtask



	

