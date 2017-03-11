// simple test to start using uvm
class hello_test extends uvm_test;
 	`uvm_component_utils(hello_test)

	function new(string name, uvm_component parent );
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info("%m","Running UVM",UVM_HIGH);
	endtask
endclass
