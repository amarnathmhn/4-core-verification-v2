
class CpuSequence extends uvm_sequence #(CpuCmd);

	function new(string name="CpuSequence");
		super.new(name);
	endfunction
	rand CpuCmd cpuCmd;
	rand CommandType cmdType;
	rand bit[`ADDRESSSIZE-1:0] addr;
	rand bit[`CORE_BITS-1:0] core;
	`uvm_object_utils_begin(CpuSequence)
		`uvm_field_enum(CommandType, cmdType, UVM_ALL_ON)
		`uvm_field_int(core, UVM_ALL_ON)
		`uvm_field_object(cpuCmd,UVM_ALL_ON)
		`uvm_field_int(addr, UVM_ALL_ON)
	`uvm_object_utils_end
	`uvm_declare_p_sequencer(Sequencer)
	 task body();
		`uvm_info("CPU SEQ",{"COMMAND = ",cmdType.name()," CORE = ",$sformatf("%d",this.core)},UVM_MEDIUM);
		 cpuCmd = CpuCmd::type_id::create("cpuCmd",,get_full_name());

		 cpuCmd.addr.rand_mode(0);// disable randomization for addr
		 cpuCmd.cmdType.rand_mode(0); 
		 cpuCmd.core.rand_mode(0);    
		 cpuCmd.addr.rand_mode(0);   
		 
		 cpuCmd.cmdType = cmdType;
		 cpuCmd.core    = core;
		 cpuCmd.addr    = addr;
		 start_item(cpuCmd);
			void'(randomize(cpuCmd)); 
		 finish_item(cpuCmd);

		
		`uvm_info("SVDEBUG:","CPU SEQ transaction",UVM_MEDIUM);

	endtask
endclass:CpuSequence
