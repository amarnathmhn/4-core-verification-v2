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
		`uvm_info("DRIVE ITEM",{"Driving the Command to Core ",$sformatf(cpuCmd.core)},UVM_MEDIUM);
		 cpuCmd.print();
		// clear all prrd prwr inputs first
		 vif.clear_cache_inputs();
		 // drive the cmd to the corenumber given
		 vif.PrRd[cpuCmd.core] = cpuCmd.PrRd;
		 vif.PrWr[cpuCmd.core] = cpuCmd.PrWr;
		 vif.Address[cpuCmd.core] = cpuCmd.addr;
		 if(cpuCmd.cmdType == WRITE)begin
		 	vif.Data_Bus_reg[cpuCmd.core] = cpuCmd.data;
		 end
		 
	endtask:drive_item

	
endclass:CacheDriver
