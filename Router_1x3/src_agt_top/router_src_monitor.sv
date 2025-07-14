class router_src_monitor extends uvm_monitor;
	
	`uvm_component_utils(router_src_monitor)

	router_src_agent_config s_cfg;
	src_xtn s_xtn;
	virtual src_if.SMON_MP svif;

	//anaysis port to connect to the sb
	uvm_analysis_port#(src_xtn)src_ap;
	
	//constructor new method
	function new(string name="router_src_monitor",uvm_component parent);
		super.new(name,parent);
		src_ap=new("src_ap",this);
	endfunction
		
	//build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(router_src_agent_config)::get(this,"","router_src_agent_config",s_cfg))
			`uvm_fatal(get_type_name(),"GETTING THE CONFIG HANDLE FAILED")
	endfunction

	//connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		svif=s_cfg.svif;
	endfunction

	//run phase
	task run_phase(uvm_phase phase);
		forever
		begin
		collect_data();
		end
	endtask

	task collect_data();
		s_xtn=src_xtn::type_id::create("s_xtn");
		@(svif.src_mon_cb);
		while(svif.src_mon_cb.busy)
		@(svif.src_mon_cb);
		while(svif.src_mon_cb.pkt_valid!==1)
		@(svif.src_mon_cb);

		s_xtn.header=svif.src_mon_cb.data_in;
		s_xtn.payload=new[s_xtn.header[7:2]];

		@(svif.src_mon_cb);
		foreach(s_xtn.payload[i])
			begin

		while(svif.src_mon_cb.busy)
		@(svif.src_mon_cb);

			s_xtn.payload[i]=svif.src_mon_cb.data_in;
			@(svif.src_mon_cb);
			end

		while(svif.src_mon_cb.busy)
		@(svif.src_mon_cb);

		while(svif.src_mon_cb.pkt_valid!==0)
		@(svif.src_mon_cb);
		s_xtn.parity=svif.src_mon_cb.data_in;
	repeat(2)
		@(svif.src_mon_cb);
		//count monitor 
		s_cfg.src_mon_count++;
			
//		xtn.print();	
		src_ap.write(s_xtn);
		
		`uvm_info(get_type_name(),$sformatf("monitoring the data \n %s",s_xtn.sprint()),UVM_LOW)

	endtask	

	/*function void report_phase(uvm_phase phase);
		xtn.print();
	endfunction*/
		
endclass

