class CacheDriver extends BaseDriver;

	CpuCmd cpuCmd; // reference to basic transaction modeling the cpu command
	

	// UVM automation macros
	`uvm_component_utils(CacheDriver)

	// Mandatory new method for component classes
	function new(string name = "CacheDriver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	// Drives the  
	task drive_item(input BaseCmd cmd);
		 // cast the BaseCmd to CpuCmd
		 if(  !$cast(cpuCmd,cmd) )begin
		 	`uvm_fatal("CACHE DRIVER","Could not Cast BaseCmd cmd to CpuCmd cpuCmd");
		 end
		`uvm_info("DRIVE ITEM",{"Driving the Command to Core ",cpuCmd.core},UVM_MEDIUM);
		 cpuCmd.print();
		// clear inputs first
		 clear_cache_inputs();
		 // drive the cmd to the corenumber given
		 vif.PrRd[cpuCmd.core] = cpuCmd.PrRd;
		 vif.PrWr[cpuCmd.core] = cpuCmd.PrWr;
		 vif.Address[cpuCmd.core] = cpuCmd.addr;
		 if(cpuCmd.cmdType == WRITE)begin
		 	vif.Data_Bus_reg[cpuCmd.core] = cpuCmd.data;
		 end
		 
	endtask:drive_item

	task clear_cache_inputs();
		 vif.PrRd[cpuCmd.core] = 0;
		 vif.PrWr[cpuCmd.core] = 0;
		 vif.Address[cpuCmd.core] = 0;
		 if(cpuCmd.cmdType == WRITE)begin
		 	vif.Data_Bus_reg[cpuCmd.core] = 0;
		 end
	endtask:clear_cache_inputs

endclass:CacheDriver
