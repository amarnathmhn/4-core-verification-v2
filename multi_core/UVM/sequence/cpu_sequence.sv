
class CpuSequence extends uvm_sequence #(CpuCmd);

	function new(string name="CpuSequence");
		super.new(name);
	endfunction
	rand CommandType cmdType;
	rand bit[`CORE_BITS-1:0] core;
	`uvm_object_utils_begin(CpuSequence)
		`uvm_field_enum(CommandType, cmdType, UVM_ALL_ON)
		`uvm_field_int(core, UVM_ALL_ON)
	`uvm_object_utils_end
	`uvm_declare_p_sequencer(Sequencer)
	virtual task body();
		`uvm_info("CPU SEQ",{"COMMAND = ",cmdType.name()," CORE = ",this.core},UVM_MEDIUM);
		`uvm_do_with(req,{cmdType==this.cmdType;core==this.core;})
	endtask
endclass:CpuSequence
