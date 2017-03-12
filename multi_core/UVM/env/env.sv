// Environment class with possibly multiple agents
class Env extends uvm_env;
	
	int num_agents;
	Agent cpuAgent[];   // agent to mimic cpu functionality
	Agent mainMemAgent; // agent to mimic memory functionality

	`uvm_component_utils_begin(Env)
		`uvm_field_int(num_agents,UVM_ALL_ON);
	`uvm_component_utils_end

	function new(string name="Env",uvm_component parent);
		super.new(name,parent);
		num_agents = 1; //default number of agents
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// Instantiate all Cpu Agents
		cpuAgent = new[num_agents];
		foreach(cpuAgent[i])begin
			cpuAgent[i] = Agent::type_id::create({"cpuAgent",i},this);
			cpuAgent[i].is_active = UVM_ACTIVE;
		end
		// Instantiate Memory Agent
		mainMemAgent = Agent::type_id::create("mainMemAgent",this);  
	endfunction:build_phase

endclass:Env
