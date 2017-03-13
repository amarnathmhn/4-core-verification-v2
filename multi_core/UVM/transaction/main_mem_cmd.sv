// Transaction to communicate with a single cache
class MainMemCmd extends BaseCmd;

	rand int unsigned data; // data requested
	rand bit dataInBus;
	// constrain the address and data to 32  bits
	constraint data_range {

		data inside {[0: (1 << `ADDRESSSIZE ) - 1  ]};	
	}
	
	
	// UVM automation macros for objects
	// Implements copy, print, and compare utility functions for these members.
	`uvm_object_utils_begin(MainMemCmd)
		`uvm_field_int(dataInBus, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "MainMemCmd");
		super.new(name);
	endfunction

	// try overriding constraints in derived classes

endclass:MainMemCmd

