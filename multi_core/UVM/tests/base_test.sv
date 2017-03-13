// simple test to start using uvm
class BaseTest extends uvm_test;
 	`uvm_component_utils(BaseTest)

	Env env;
	// sequences to run in this test
	CpuSequence cpuSeq;
	MainMemSequence mainMemSeq;
	function new(string name, uvm_component parent );
		super.new(name, parent);
	endfunction:new

	// Create the env in build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// override cache driver instance's type BaseDriver into CacheDriver using set override type by instance
		// override main mem driver instance's type BaseDriver into MainMemDriver using set override type by instance
			BaseDriver::type_id::set_inst_override(CacheDriver::get_type(), {"*.cpuAgent.cacheDriver"});	
			BaseDriver::type_id::set_inst_override(MainMemDriver::get_type(), {"*.cpuAgent.mainMemDriver"});	
		env = Env::type_id::create("env",this);
		mainMemSeq = MainMemSequence::type_id::create("mainMemSeq",this);
		

	endfunction:build_phase


	task run_phase(uvm_phase phase);
		cpuSeq = new("cpuSeq");
		`uvm_info("BaseTest","Running BaseTest",UVM_MEDIUM);
		phase.raise_objection(this);
		cpuSeq.start(env.cpuAgent.cpuSequencer);
		
		start_main_mem_sequence();
		wait_cycles(20);
		phase.drop_objection(this);
	endtask

	virtual task start_main_mem_sequence();
		
		mainMemSeq.start(env.cpuAgent.mainMemSequencer);
	
	endtask:start_main_mem_sequence

	virtual task wait_cycles(input int cycles);
		repeat(cycles) @(posedge $root.top.clk);
	endtask:wait_cycles
	
	
endclass:BaseTest
