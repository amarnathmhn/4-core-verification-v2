
class CpuSequence extends uvm_sequence #(CpuCmd);

	function new(string name="CpuSequence");
		super.new(name);
	endfunction

	`uvm_object_utils(CpuSequence)

	virtual task body();
		`uvm_info("SVDEBUG","TopSequenceBody",UVM_MEDIUM);
		`uvm_do_with(req,{cmdType==READ;core==0;})
	endtask
endclass:CpuSequence
