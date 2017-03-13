// simple test to start using uvm
class BaseTest extends uvm_test;
 	`uvm_component_utils(BaseTest)

	Env env;
	int num_agents;	
	// sequences to run in this test
	CpuSequence cpuSeq;
	MainMemSequence mainMemSeq;
	function new(string name, uvm_component parent );
		super.new(name, parent);
		cpuSeq = new("cpuSeq");
		mainMemSeq = new("mainMemSeq");
	endfunction:new

	// Create the env in build phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// override cache driver instance's type BaseDriver into CacheDriver using set override type by instance
		// override main mem driver instance's type BaseDriver into MainMemDriver using set override type by instance
		num_agents = 1;
		for(int i=0; i < num_agents; i++)begin		
			BaseDriver::type_id::set_inst_override(CacheDriver::get_type(), {"*.cpuAgent",i,".cacheDriver"});	
			BaseDriver::type_id::set_inst_override(MainMemDriver::get_type(), {"*.cpuAgent",i,".mainMemDriver"});	
		end
		env = Env::type_id::create("env",this);
		env.num_agents = this.num_agents;
		

	endfunction:build_phase

	task run_phase(uvm_phase phase);
		`uvm_info("BaseTest","Running BaseTest",UVM_MEDIUM);
		phase.raise_objection(this);
		cpuSeq.start(env.cpuAgent[0].cpuSequencer);
		mainMemSeq.start(env.cpuAgent[0].mainMemSequencer);
		repeat(20)
			@(posedge $root.top.clk);
		phase.drop_objection(this);
	endtask
	
	
endclass:BaseTest
