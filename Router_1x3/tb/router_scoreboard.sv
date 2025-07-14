class router_scoreboard extends uvm_scoreboard;
	
	`uvm_component_utils(router_scoreboard)
	
	router_env_config env_cfg;
	
	src_xtn s_xtn;
	dst_xtn d_xtn;
	
	src_xtn s_cov;
	dst_xtn d_cov;


	uvm_tlm_analysis_fifo#(src_xtn) src_fifo[];
	uvm_tlm_analysis_fifo#(dst_xtn) dst_fifo[];

	//constructor new method
	function new(string name="router_scoreboard",uvm_component parent);
		super.new(name,parent);
		srr_cov=new();
		dss_cov=new();
	endfunction

	//build_phase
	function void build_phase(uvm_phase phase);	
		super.build_phase(phase);
		if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",env_cfg))
			`uvm_fatal(get_type_name(),"GETTING THE ENV CONFIG HANDLE FAILED")

		src_fifo=new[env_cfg.no_of_sagents];
		dst_fifo=new[env_cfg.no_of_dagents];

		foreach(src_fifo[i])
		src_fifo[i]=new($sformatf("src_fifo[%0d]",i),this);
		
		foreach(dst_fifo[i])
		dst_fifo[i]=new($sformatf("dst_fifo[%0d]",i),this);


	endfunction

	//run_phase
	task run_phase(uvm_phase phase);
		fork
			begin
				forever
					begin
					src_fifo[0].get(s_xtn);
					//s_xtn.print();
					s_cov=s_xtn;
					srr_cov.sample();
					end
			end

			begin
				forever
					begin
					fork
					begin
						dst_fifo[0].get(d_xtn);
						compare_data(s_xtn,d_xtn);
						d_cov=d_xtn;
						dss_cov.sample();
					//	d_xtn.print();
					end
					begin
						dst_fifo[1].get(d_xtn);
						compare_data(s_xtn,d_xtn);
						d_cov=d_xtn;
						dss_cov.sample();
					end
					begin
						dst_fifo[2].get(d_xtn);
						compare_data(s_xtn,d_xtn);
						d_cov=d_xtn;
						dss_cov.sample();
					end
					join_any
					disable fork;
					end
			end
	

		join
	endtask		
	

	task compare_data(src_xtn sr_xtn,dst_xtn ds_xtn);
	
		/*if(s_xtn.header==d_xtn.header)
			`uvm_info(get_type_name(),"HEADER OF SOURCE AND DESTINATION MATCHED",UVM_LOW)
		else
			`uvm_info(get_type_name(),"HEADER OF SOURCE AND DESTINATION NOT MATCHED",UVM_LOW)
		if(s_xtn.payload==d_xtn.payload)
			`uvm_info(get_type_name(),"PAYLOAD OF SOURCE AND DESTINATION MATCHED",UVM_LOW)
		else
			`uvm_info(get_type_name(),"PAYLOAD OF SOURCE AND DESTINATION NOT MATCHED",UVM_LOW)

		if(s_xtn.parity==d_xtn.parity)
			`uvm_info(get_type_name(),"PARITY OF SOURCE AND DESTINATION MATCHED",UVM_LOW)
		else
			`uvm_info(get_type_name(),"PARITY OF SOURCE AND DESTINATION NOT MATCHED",UVM_LOW)*/
	

		if(sr_xtn.header==ds_xtn.header)
			begin
				`uvm_info(get_type_name(),"HEADER OF SOURCE AND DESTINATION MATCHED",UVM_LOW)
			if(sr_xtn.payload==ds_xtn.payload)
			begin
				`uvm_info(get_type_name(),"PAYLOAD OF SOURCE AND DESTINATION MATCHED",UVM_LOW)
			if(sr_xtn.parity==ds_xtn.parity)
				`uvm_info(get_type_name(),"PARITY OF SOURCE AND DESTINATION MATCHED",UVM_LOW)

			else
				`uvm_error(get_type_name(),"PARITY IS MISMATCHED")

			end	
			else
				`uvm_error(get_type_name(),"PAYLOAD IS MISMATCHED")
			end
			else
				`uvm_error(get_type_name(),"HEADER IS MISMATCHED")


				
	endtask

	covergroup srr_cov;
		ch: coverpoint s_cov.header[1:0]{bins zero={2'b00};
						   bins one={2'b01};
						   bins two={2'b10};}

		pl:coverpoint s_cov.header[7:2]{bins small_pkt={[1:13]};
						  bins medium_pkt={[14:30]};
						  bins large_pkt={[31:63]};}

		chxpl: cross ch,pl;

	//	error: coverpoint s_cov.error{bins err={1};}

	endgroup
				
	covergroup dss_cov;
		ch:coverpoint d_cov.header[1:0]{bins zero={2'b00};
						  bins one={2'b01};
						  bins two={2'b10};}

		pl:coverpoint d_cov.header[7:2]{bins small_pkt={[1:13]};
						  bins medium_pkt={[14:30]};
					    	  bins large_pkt={[31:63]};}

		chxpl:cross ch,pl;

	endgroup

endclass
