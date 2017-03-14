// access the cache memory variables directly from the vif.

class CacheDirectMemDriver extends BaseDriver;

	
	CacheDirectMemAccessCmd cdmaCmd;
	
	`uvm_component_utils_begin(CacheDirectMemDriver)
		`uvm_field_object(cdmaCmd,UVM_ALL_ON)
	`uvm_component_utils_end
	function new(string name="CacheDirectMemDriver",uvm_component parent);
		super.new(name,parent);
	endfunction:new	
	
	task drive_item(BaseCmd cmd);
		if( !$cast( cdmaCmd, cmd ) ) begin
			`uvm_fatal("CACHE DIRECT MEM DRIVER","Cast failed");
		end
		`uvm_info("DRIVE ITEM","DIRECTLY WRITING INTO CACHE MEMORY",UVM_MEDIUM);	
		cdmaCmd.print();
		// overwriting the cache memory directly
		vif.Cache_var[cdmaCmd.core][{cdmaCmd.addr[`INDEX_MSB:`INDEX_LSB],cdmaCmd.line}][`CACHE_DATA_MSB:`CACHE_DATA_LSB] = cdmaCmd.data; 
		// set MESI state	
		vif.Cache_proc_contr[cdmaCmd.core][{cdmaCmd.addr[`INDEX_MSB:`INDEX_LSB],cdmaCmd.line}][`CACHE_MESI_MSB:`CACHE_MESI_LSB] = EXCLUSIVE;
		// set tag
		vif.Cache_proc_contr[cdmaCmd.core][{cdmaCmd.addr[`INDEX_MSB:`INDEX_LSB],cdmaCmd.line}][`CACHE_TAG_MSB:`CACHE_TAG_LSB]   = cdmaCmd.addr[`TAG_MSB:`TAG_LSB];
	endtask:drive_item	
endclass:CacheDirectMemDriver
