class Monitor extends uvm_monitor;

 virtual globalInterface vif;

 bit checks_enable = 1;   // control checking
 bit coverage_enable = 1; // control coverage collection

 uvm_analysis_port#(CpuCmd)     cpuCmdPort;
 uvm_analysis_port#(MainMemCmd) mainMemCmdPort;

 event cpuCmdCollected_e;
 event mainMemCmdCollected_e;

 event dataInBus_e;
 event comBusRequestProc_e;
 event comBusGntProc_e;

 event busRd_e;
 event busRdX_e;
 

 CpuCmd cpuCmdCollected;
 MainMemCmd mainMemCmdCollected;

 `uvm_component_utils_begin(Monitor)
   `uvm_field_int(checks_enable, UVM_ALL_ON)
   `uvm_field_int(coverage_enable, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
	super.new(name,parent);
	cpuCmdCollected = new();
	mainMemCmdCollected = new();
  endfunction:new

 virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	// get virtual interface
	if( !uvm_config_db#(virtual globalInterface)::get(this,"","vif",vif) )begin
		`uvm_fatal("MONITOR","Virtual Interface Could Not be Set for Monitor");
	end
 endfunction:build_phase

 virtual task run_phase(uvm_phase phase);
	// emit events
	
		// monitor on memory
		fork
		    // monitor if data is placed on bus
		    begin 
			forever begin 
	
				@(vif.Data_in_Bus) ; //detect change in Data_in_Bus
				  mainMemCmdCollected.data = vif.Data_Bus_Com;
				  ->dataInBus_e;
				
				
			end
                    end
		    // check for bus read
			
                    begin
			forever begin
			 @(posedge vif.BusRd);
			 ->busRd_e;
			`uvm_info("MONITOR","*******BusRd Placed******",UVM_MEDIUM);	
			end
                    end
		    // check for bus read x
		    begin
			forever begin
			@(posedge vif.BusRdX);
			->busRdX_e;
			end
		    end

		 


		join_any
		
	
 endtask:run_phase

 
  
endclass:Monitor
