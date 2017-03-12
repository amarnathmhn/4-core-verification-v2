class Env extends uvm_env;
	
	int num_agents;
	Agent agent;

	`uvm_component_utils_begin(Env)
		`uvm_field_int(num_agents,UVM_ALL_ON);
	`uvm_component_utils_end

	function new(string name="Env",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = Agent::type_id::create("agent",this);
	endfunction:build_phase

endclass:Env