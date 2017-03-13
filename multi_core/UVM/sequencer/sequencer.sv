typedef class Agent;
class Sequencer extends uvm_sequencer#(BaseCmd);
	`uvm_component_utils(Sequencer)

	Agent pAgent;
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction:new
	
endclass:Sequencer
