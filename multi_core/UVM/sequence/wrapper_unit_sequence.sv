// Sequence For all Cores
// Can send READ/WRITE Command to any of the 4 cores
class WrapperUnitSequence extends uvm_sequence#(CpuSequence);
	
	`uvm_object_utils(WrapperUnitSequence)	
	 
	task body();
		`uvm_info("WRAPPER SEQ","SENDING *READ* COMMANDS OVER ALL CORES SERIALLY",UVM_MEDIUM);
		for(int c=0; c < (1<<`CORE_BITS); c++ )begin
			`uvm_do_with(req,{cmdType == READ; core == c;})
		end
	endtask:body	
endclass:WrapperUnitSequence
