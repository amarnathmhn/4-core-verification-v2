class Agent extends uvm_agent;
	uvm_active_passive_enum is_active; // UVM_ACTIVE or UVM_PASSIVE
	
	uvm_sequencer #(TopCmd) sequencer; // sequencer to create sequences with TopCmd type item
	
	DutDriver driver;
	
	`uvm_component_utils(Agent)

	function new(string name="agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// create sequencer object and driver object if the agent is active
		if(is_active == UVM_ACTIVE)begin
			sequencer = uvm_sequencer #(TopCmd)::type_id::create("sequencer",this);
			driver    = DutDriver::type_id::create("driver",this);
		end
	endfunction:build_phase

	// connects sequencer and driver
	virtual function void connect_phase(uvm_phase phase);
		if(is_active == UVM_ACTIVE)begin
			// connect driver's item port to sequencer's item export
			driver.seq_item_port.connect(sequencer.seq_item_export);
		end
	endfunction:connect_phase

	
endclass:Agent