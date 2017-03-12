/*
Basic Agent Skeleton. 
Agent has a sequencer, driver, monitor.
Define single agent (Do not derive from it) but define sequencers and drivers as needed. 
Override the sequencer and driver with user defined class types.
*/

class Agent extends uvm_agent;
	uvm_active_passive_enum is_active; // UVM_ACTIVE or UVM_PASSIVE
	
	uvm_sequencer #(BaseCmd) cpuSequencer; // sequencer to create sequences with CpuCmd type item
	
	BaseDriver driver;
	
	`uvm_component_utils(Agent)

	function new(string name="Agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// create sequencer object and driver object if the agent is active
		if(is_active == UVM_ACTIVE)begin
			`uvm_info("SVDEBUG","creating sequencer",UVM_MEDIUM);
			cpuSequencer = uvm_sequencer #(BaseCmd)::type_id::create("cpuSequencer",this);
			driver    = BaseDriver::type_id::create("driver",this);
		end
	endfunction:build_phase

	// connects sequencer and driver
	virtual function void connect_phase(uvm_phase phase);
		if(is_active == UVM_ACTIVE)begin
			// connect driver's item port to sequencer's item export
			driver.seq_item_port.connect(cpuSequencer.seq_item_export);
		end
	endfunction:connect_phase

	
endclass:Agent
