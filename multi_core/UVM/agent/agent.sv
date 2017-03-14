/*
Basic Agent Skeleton. 
Agent has  sequencers, drivers, monitor.
Define single agent (Do not derive from it) but define sequencers and drivers as needed. 
Override the sequencer and driver with user defined class types.
*/

class Agent extends uvm_agent;
	uvm_active_passive_enum is_active; // UVM_ACTIVE or UVM_PASSIVE
	
	Sequencer  cpuSequencer; // sequencer to create sequences with CpuCmd type item
	Sequencer  mainMemSequencer; // sequencer to create sequences with mainMemCmd type item
	Sequencer  cacheDirectMemAccessSequencer; // sequencer to create sequences with mainMemCmd type item
	
	BaseDriver cacheDriver;
	BaseDriver mainMemDriver;
	BaseDriver cacheDirectMemAccessDriver;

	Monitor monitor;	
	
	`uvm_component_utils(Agent)

	function new(string name="Agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// create sequencer object and driver object if the agent is active
		if(is_active == UVM_ACTIVE)begin
			`uvm_info("SVDEBUG","creating sequencer",UVM_MEDIUM);
			cpuSequencer     = Sequencer ::type_id::create("cpuSequencer",this);
			cpuSequencer.pAgent = this;
			
			mainMemSequencer = Sequencer ::type_id::create("mainMemSequencer",this);
			mainMemSequencer.pAgent = this;

			cacheDirectMemAccessSequencer = Sequencer::type_id::create("CacheDirectMemAccessSequencer",this);
			cacheDirectMemAccessSequencer.pAgent = this;
			
			cacheDriver      = BaseDriver::type_id::create("cacheDriver",this);
			mainMemDriver    = BaseDriver::type_id::create("mainMemDriver",this);
			cacheDirectMemAccessDriver = BaseDriver::type_id::create("cacheDirectMemAccessDriver",this);
			monitor		 = Monitor::type_id::create("monitor",this);

		end
	endfunction:build_phase

	// connects sequencer and driver
	virtual function void connect_phase(uvm_phase phase);
		if(is_active == UVM_ACTIVE)begin
			// connect driver's item port to sequencer's item export
			cacheDriver.seq_item_port.connect(cpuSequencer.seq_item_export);
			mainMemDriver.seq_item_port.connect(mainMemSequencer.seq_item_export);
			cacheDirectMemAccessDriver.seq_item_port.connect(cacheDirectMemAccessSequencer.seq_item_export);
		end
	endfunction:connect_phase

	
endclass:Agent
