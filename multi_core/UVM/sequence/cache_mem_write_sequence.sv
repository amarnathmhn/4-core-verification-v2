// Sequence to directly data to the cache memory without any Read or Write Command
class CacheDirectMemWriteSequence extends uvm_sequence#(CacheDirectMemAccessCmd);


	rand bit[`CORE_BITS-1:0] core;
	rand bit[`ASSOCIATIVITY-1:0] line;
	rand bit[`ADDRESSSIZE-1:0] addr;
	rand bit[`DATA_SIZE-1:0] data;

	rand CacheDirectMemAccessCmd cacheDirectMemAccessCmd;

	`uvm_object_utils_begin(CacheDirectMemWriteSequence)
		`uvm_field_int(core, UVM_ALL_ON)
		`uvm_field_int(line, UVM_ALL_ON)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_object(cacheDirectMemAccessCmd,UVM_ALL_ON)
	`uvm_object_utils_end

	`uvm_declare_p_sequencer(Sequencer)


	function new(string name = "CacheDirectMemWriteSequence");
		super.new(name);
	endfunction:new
	
	task body();

		
		cacheDirectMemAccessCmd = CacheDirectMemAccessCmd::type_id::create("cacheDirectMemAccessCmd",,get_full_name());
		
		cacheDirectMemAccessCmd.addr.rand_mode(0);
		cacheDirectMemAccessCmd.core.rand_mode(0);
		cacheDirectMemAccessCmd.data.rand_mode(0);
		cacheDirectMemAccessCmd.line.rand_mode(0);
		
		cacheDirectMemAccessCmd.addr = addr;
		cacheDirectMemAccessCmd.core = core;
		cacheDirectMemAccessCmd.data = data;
		cacheDirectMemAccessCmd.line = line;

		start_item(cacheDirectMemAccessCmd);
		finish_item(cacheDirectMemAccessCmd);
		
		`uvm_info("CACHE DIRECT WRITE SEQ","SENDING MEM WRITE CMD",UVM_MEDIUM)

		 
	endtask:body
	
endclass:CacheDirectMemWriteSequence
