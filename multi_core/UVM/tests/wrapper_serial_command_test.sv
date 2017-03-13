// This test calls the wrapperUnitSequence to send CPU command READ/WRITE to all the cores.

class WrapperSerialCommandTest extends BaseTest;
	`uvm_component_utils(WrapperSerialCommandTest)

	function new(string name, uvm_component parent );
		super.new(name, parent);
	endfunction:new
	
	task run_phase(uvm_phase phase);
		//declare the sequence
		WrapperUnitSequence wrapperUnitSequence = WrapperUnitSequence::type_id::create("wrapperUnitSequence",this);
		`uvm_info("BaseTest","Running BaseTest",UVM_MEDIUM);
		phase.raise_objection(this);
		wrapperUnitSequence.start(env.cpuAgent.cpuSequencer);
		
		super.start_main_mem_sequence();
		super.wait_cycles(20);

		phase.drop_objection(this);	
	endtask
	
endclass:WrapperSerialCommandTest
