class MainMemDriver extends BaseDriver;

	MainMemCmd mainMemCmd; // reference to basic transaction modeling the cpu command
	

	// UVM automation macros
	`uvm_component_utils(MainMemDriver)

	// Mandatory new method for component classes
	function new(string name = "MainMemDriver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	// Drives the  
	task drive_item(input BaseCmd cmd);
		 // cast the BaseCmd to CpuCmd
		 if(  !$cast(mainMemCmd,cmd) )begin
		 	`uvm_fatal("MAIM MEM DRIVER","Could not Cast BaseCmd cmd to CpuCmd cpuCmd");
		 end
		`uvm_info("MAIN MEM DRIVER",{"Driving the Main Mem Command "},UVM_MEDIUM);
		 mainMemCmd.print();
		 // Mimics the main memory action
		 vif.ClkBlk.Data_Bus_Com <= mainMemCmd.data;
		 vif.ClkBlk.Data_in_Bus  <= mainMemCmd.dataInBus;
		 
	endtask:drive_item

endclass:MainMemDriver
