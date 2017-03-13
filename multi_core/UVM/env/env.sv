// Environment class with possibly multiple agents
class Env extends uvm_env;
	
	Agent cpuAgent;   // agent to mimic cpu functionality
	Agent mainMemAgent; // agent to mimic memory functionality

	`uvm_component_utils(Env)

	function new(string name="Env",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// Instantiate all Cpu Agents
			cpuAgent = Agent::type_id::create("cpuAgent",this);
			cpuAgent.is_active = UVM_ACTIVE;
		// Instantiate Memory Agent
		mainMemAgent = Agent::type_id::create("mainMemAgent",this);  
	endfunction:build_phase

endclass:Env
