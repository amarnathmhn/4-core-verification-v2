// Definition of the driver class for the Verification Environment
class DutDriver extends uvm_driver #(TopCmd);

	TopCmd topCmd; // reference to basic transaction modeling the cpu command
	virtual globalInterface vif; // reference to the global interface to the DUT

	// UVM automation macros
	`uvm_component_utils(DutDriver)

	// Mandatory new method for component classes
	function new(string name = "DutDriver", uvm_component parent);
		super.new(name, parent);
	endfunction
	// Gets the virtual interface actually in use by the testbench.
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual globalInterface)::get(this, "", "vif",vif) ) begin
			`uvm_fatal("NO VIF",{"virtual interface must be set for: ",get_full_name(), ".vif"});
		end
	endfunction:build_phase
	
	// Gets the item from sequencer and drive it to DUT
	task run_phase(uvm_phase phase);
		forever begin
			// Get the next data item from the sequencer
			seq_item_port.get_next_item(topCmd); // topCmd now references the 
			// Execute the item 
			drive_item(topCmd);
			seq_item_port.item_done(); // Lets the sequencer know that the item is driven
		end
	endtask:run_phase

	// Drives the item to the DUT
	task drive_item(input TopCmd cmd);
		`uvm_info("DRIVE ITEM",{"Driving the Command"},UVM_HIGH);
	endtask:drive_item

endclass:DutDriver