class router_dst_monitor extends uvm_monitor;
	
	`uvm_component_utils(router_dst_monitor)

	virtual dst_if.DMON_MP dvif;
	router_dst_agent_config d_cfg;
	dst_xtn d_xtn;

	uvm_analysis_port#(dst_xtn) dst_ap;
	
	//constructor new method
	function new(string name="router_dst_monitor",uvm_component parent=null);
		super.new(name,parent);
		dst_ap=new("dst_ap",this);
	endfunction

	//build_phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(router_dst_agent_config)::get(this,"","router_dst_agent_config",d_cfg))
			`uvm_fatal(get_type_name(),"GETTING THE CONFIG HANDLE FAILED")
	endfunction
	
	//connect_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		dvif=d_cfg.dvif;
	endfunction

	//run_phase
	task run_phase(uvm_phase phase);
		forever
		begin
			collect_data();
		end
	endtask

	task collect_data;

		d_xtn=dst_xtn::type_id::create("d_xtn");
		
		while(dvif.dst_mon_cb.read_enb!==1)
			@(dvif.dst_mon_cb);
			@(dvif.dst_mon_cb);
			d_xtn.header=dvif.dst_mon_cb.data_out;
			@(dvif.dst_mon_cb);
			d_xtn.payload=new[d_xtn.header[7:2]];
			foreach(d_xtn.payload[i])
			begin
				d_xtn.payload[i]=dvif.dst_mon_cb.data_out;
					@(dvif.dst_mon_cb);

			end
			d_xtn.parity=dvif.dst_mon_cb.data_out;
			@(dvif.dst_mon_cb);
			
			dst_ap.write(d_xtn);

		`uvm_info(get_type_name(),$sformatf("monitor from rd the data \n %s",d_xtn.sprint()),UVM_LOW)

	endtask
		
//	function void report_phase(uvm_phase phase);
//		`uvm_info(get_type_name(),$sformatf("monitor from rd the data \n %s",xtn.sprint()),UVM_LOW)
//	endfunction

endclass

