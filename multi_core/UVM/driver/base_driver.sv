// Definition of the driver class for the Verification Environment
class BaseDriver extends uvm_driver#(BaseCmd);
		

	BaseCmd baseCmd;
	
	virtual globalInterface vif; // reference to the global interface to the DUT

	function new(string name = "BaseDriver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	`uvm_component_utils(BaseDriver)

// Gets the virtual interface actually in use by the testbench.
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual globalInterface)::get(this, "", "vif",vif) ) begin
			`uvm_fatal("NO VIF",{"virtual interface must be set for: ",get_full_name(), ".vif"});
		end
	endfunction:build_phase
	
	// Gets the item from sequencer and drive it to DUT
	virtual task run_phase(uvm_phase phase);
		forever begin
			// Get the next data item from the sequencer
			seq_item_port.get_next_item(baseCmd); // topCmd now references the 
			// Execute the item 
			drive_item(baseCmd); // will be implemented in derived class
			seq_item_port.item_done(); // Lets the sequencer know that the item is driven
		end
	endtask:run_phase

	// making use of polymorphism here. BaseCmd can assume Cpu Command or Memory transaction etc. to be defined in child class
	virtual task drive_item(input BaseCmd cmd);
	endtask:drive_item

endclass


