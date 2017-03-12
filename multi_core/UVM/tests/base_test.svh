// simple test to start using uvm
class BaseTest extends uvm_test;
 	`uvm_component_utils(BaseTest)

	Env env;

	function new(string name, uvm_component parent );
		super.new(name, parent);
	endfunction

	// Create the env in build phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		env = Env::type_id::create("env",this);
	endfunction:build_phase

	task run_phase(uvm_phase phase);
		`uvm_info("BaseTest","SVDEBUG:: Running BaseTest",UVM_MEDIUM);
	endtask
	
	
endclass:BaseTest
