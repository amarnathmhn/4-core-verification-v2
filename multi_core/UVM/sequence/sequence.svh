
class TopSequence extends uvm_sequence #(TopCmd);

	function new(string name="TopSequence");
		super.new(name);
	endfunction

	`uvm_object_utils(TopSequence)

	virtual task body();
		`uvm_do(req)
	endtask
endclass:TopSequence