
class MainMemSequence extends uvm_sequence #(MainMemCmd);

	function new(string name="MainMemSequence");
		super.new(name);
	endfunction

	`uvm_object_utils(MainMemSequence)
	`uvm_declare_p_sequencer(Sequencer)

	virtual task body();
		`uvm_info("SVDEBUG","Main Mem SequenceBody",UVM_MEDIUM);
		forever begin
			// check if there is a BusRd
			wait(p_sequencer.pAgent.monitor.busRd_e.triggered);
			repeat(2) @(posedge p_sequencer.pAgent.monitor.vif.clk);
			if(!(p_sequencer.pAgent.monitor.vif.Data_in_Bus==1))
			        `uvm_info("MEM SEQ","Data Not Placed By Other Caches. Placing Data",UVM_MEDIUM);
				`uvm_do_with(req,{dataInBus==1;})
		end
	endtask
endclass:MainMemSequence
