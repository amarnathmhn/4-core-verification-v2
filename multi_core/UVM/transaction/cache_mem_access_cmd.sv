// Use this command to write data directly into cache memory
// sequences can use this to create various cache behavior scenarios
class CacheDirectMemAccessCmd extends BaseCmd;
	
	//Set associative cache. So need address (for set and tag), line number to access a line.
	rand bit[`ADDRESSSIZE-1:0] addr;
	rand bit[`ASSOCIATIVITY-1:0] line;
	rand bit[`DATA_SIZE-1:0]   data;
	rand bit[`CORE_BITS-1:0] core;
	
	`uvm_object_utils_begin(CacheDirectMemAccessCmd)
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(line,UVM_ALL_ON)
		`uvm_field_int(data,UVM_ALL_ON)
		`uvm_field_int(core,UVM_ALL_ON)
	`uvm_object_utils_end

	 function new(string name="CacheDirectMemAccessCmd");
	 	super.new(name);
	 endfunction
		
endclass : CacheDirectMemAccessCmd
