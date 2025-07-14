class router_tb extends uvm_env;
	`uvm_component_utils(router_tb)

	router_src_agt_top src_agtop;
	router_dst_agt_top dst_agtop; 
	router_virtual_sequencer vseqrh;
	router_scoreboard sbh;

	router_env_config env_cfg;
	
	//constructor new method	
	function new(string name="router_tb",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	//build phase
	function void build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
			`uvm_fatal(get_type_name(),"NOT GETTING CONGIG IN ENV")

		src_agtop=router_src_agt_top::type_id::create("src_agtop",this);
		dst_agtop=router_dst_agt_top::type_id::create("dst_agtop",this);
		vseqrh=router_virtual_sequencer::type_id::create("vseqrh",this);
		sbh=router_scoreboard::type_id::create("sbh",this);	
		super.build_phase(phase);
	endfunction 
	
	//connect_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(env_cfg.has_scoreboard)
			begin
			for(int i=0;i<env_cfg.no_of_sagents;i++)
			//begin
			src_agtop.src_agt[i].monh.src_ap.connect(sbh.src_fifo[i].analysis_export);	
			end
			begin
			for(int i=0;i<env_cfg.no_of_dagents;i++)
	//		begin
			dst_agtop.dst_agt[i].monh.dst_ap.connect(sbh.dst_fifo[i].analysis_export);	
			end

		if(env_cfg.has_virtual_sequencer)
			begin
			//for(int i=0;i<env_cfg.no_of_sagents;i++)
		//	begin


			foreach(vseqrh.src_seqrh[j])
				vseqrh.src_seqrh[j]=src_agtop.src_agt[j].seqrh;
			end
		//	end
	
		if( env_cfg.has_virtual_sequencer)
			begin
		//	for(int i=0;i<env_cfg.no_of_dagents;i++)
		//	begin
			foreach(vseqrh.dst_seqrh[j])
				vseqrh.dst_seqrh[j]=dst_agtop.dst_agt[j].seqrh;
		//	end
			end

	endfunction



endclass	
		

