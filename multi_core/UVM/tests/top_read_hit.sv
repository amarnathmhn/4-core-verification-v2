class TopReadHit extends BaseTest;

	CacheDirectMemWriteSequence cacheDMAWriteSeq;
	CpuSequence cpuSeqRead;
	CpuSequence cpuSeqWrite;

	`uvm_component_utils(TopReadHit)

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction:new

	// override the cache memory driver
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		BaseDriver::type_id::set_inst_override(CacheDirectMemDriver::get_type(),"*.cpuAgent.cacheDirectMemAccessDriver");
	endfunction:build_phase
	
	task run_phase(uvm_phase phase);
	
		int core_to_test = 0;
		bit[`ADDRESSSIZE-1:0] addr_ = 32'hdeadbeef;
	
		cpuSeqRead = CpuSequence :: type_id :: create("cpuSeqRead",this);
		cpuSeqWrite = CpuSequence :: type_id :: create("cpuSeqWrite",this);
		cacheDMAWriteSeq = CacheDirectMemWriteSequence :: type_id :: create("cacheDMAWriteSeq",this);
		
		if(!cacheDMAWriteSeq.randomize() with {
			core == core_to_test;
			addr == addr_;
		})	begin
			`uvm_fatal("TOP READ HIT TEST","Randomization Failed");
		end

		if(!cpuSeqRead.randomize() with {
			
			core == core_to_test; 
			cmdType == READ;
			addr == addr_;
		}) begin
			`uvm_fatal("TOP READ HIT TEST","Randomization Failed");
			
		end

		if(!cpuSeqWrite.randomize() with {
			
			core == core_to_test; 
			cmdType == WRITE;
			addr == addr_;
		}) begin
			`uvm_fatal("TOP READ HIT TEST","Randomization Failed");
			
		 end
		`uvm_info("TopReadHit","Running ..",UVM_MEDIUM)
		

		phase.raise_objection(this);
		// finish setting up  a scenario for read hit
		fork 
			begin
				`uvm_info("TOP READ HIT TEST",{"Writing data to location ",$sformatf("%x",cpuSeqRead.addr)},UVM_MEDIUM);
				cpuSeqWrite.start(env.cpuAgent.cpuSequencer);	
				//cacheDMAWriteSeq.start(env.cpuAgent.cacheDirectMemAccessSequencer);	
				//`uvm_info("TOP READ HIT TEST",{"Reading from location ",$sformatf("%x",cpuSeqWrite.addr)},UVM_MEDIUM);
				//cpuSeqRead.start(env.cpuAgent.cpuSequencer);	
			end
			begin
				start_main_mem_sequence();
			end

		join_none
		//cpuSeq.start(env.cpuAgent.cpuSequencer);
		wait_cycles(20);
		phase.drop_objection(this);
	endtask

endclass:TopReadHit 
