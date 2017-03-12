// UVM - Testbench for 4-core-MESI Cache System Verification

`timescale 1ns/1ps

// import uvm class definitions


//`include "uvm_pkg.sv" // uncomment for home modelsim pe
import uvm_pkg::*;
`include "uvm_macros.svh"
// top design module
`include "cache_multi_config_1.v"

// uvm classes to verify the design module
`include "uvm_top.svh" // my uvm tb

module top;

	reg clk;
	// Instantiate Interface
	globalInterface g_intf (.clk(clk));

	// run clock
	always #50 clk = ~clk;

	 //Virtual interface for global interface
	virtual interface globalInterface local_intf;
	//Connect internal registers of DUT to interface
	assign g_intf.Cache_var[0]            = CMC.P1_DL.cb.Cache_var;
	assign g_intf.Cache_proc_contr[0]    = CMC.P1_DL.cb.Cache_proc_contr;
	assign g_intf.LRU_var[0]              = CMC.P1_DL.cc.LRU_var;
	assign g_intf.LRU_replacement_proc[0] = CMC.P1_DL.LRU_replacement_proc;
	
	assign g_intf.Cache_var[1]            = CMC.P2_DL.cb.Cache_var;
	assign g_intf.Cache_proc_contr[1]     = CMC.P2_DL.cb.Cache_proc_contr;
	assign g_intf.LRU_var[1]              = CMC.P2_DL.cc.LRU_var;
	assign g_intf.LRU_replacement_proc[1] = CMC.P2_DL.LRU_replacement_proc;
	
	assign g_intf.Cache_var[2]            = CMC.P3_DL.cb.Cache_var;
	assign g_intf.Cache_proc_contr[2]     = CMC.P3_DL.cb.Cache_proc_contr;
	assign g_intf.LRU_var[2]              = CMC.P3_DL.cc.LRU_var;
	assign g_intf.LRU_replacement_proc[2] = CMC.P3_DL.LRU_replacement_proc;
	
	assign g_intf.Cache_var[3]            = CMC.P4_DL.cb.Cache_var;
	assign g_intf.Cache_proc_contr[3]     = CMC.P4_DL.cb.Cache_proc_contr;
	assign g_intf.LRU_var[3]              = CMC.P4_DL.cc.LRU_var;
	assign g_intf.LRU_replacement_proc[3] = CMC.P4_DL.LRU_replacement_proc;
	
	assign g_intf.Cache_var[4]            =  CMC.P1_IL.cb.Cache_var;
	assign g_intf.Cache_proc_contr_IL[0]     = CMC.P1_IL.cb.Cache_proc_contr;
	assign g_intf.LRU_var[4]              = CMC.P1_IL.cc.LRU_var;
	assign g_intf.LRU_replacement_proc[4] = CMC.P1_IL.LRU_replacement_proc;
	
	assign g_intf.Cache_var[5]             = CMC.P2_IL.cb.Cache_var;
	assign g_intf.Cache_proc_contr_IL[1]     = CMC.P2_IL.cb.Cache_proc_contr;
	assign g_intf.LRU_var[5]              = CMC.P2_IL.cc.LRU_var;
	assign g_intf.LRU_replacement_proc[5] = CMC.P2_IL.LRU_replacement_proc;
	
	assign g_intf.Cache_var[6]            =  CMC.P3_IL.cb.Cache_var;
	assign g_intf.Cache_proc_contr_IL[2]     = CMC.P3_IL.cb.Cache_proc_contr;
	assign g_intf.LRU_var[6]              = CMC.P3_IL.cc.LRU_var;
	assign g_intf.LRU_replacement_proc[6] = CMC.P3_IL.LRU_replacement_proc;
	
	assign g_intf.Cache_var[7]             = CMC.P4_IL.cb.Cache_var;
	assign g_intf.Cache_proc_contr_IL[3]     = CMC.P4_IL.cb.Cache_proc_contr;
	assign g_intf.LRU_var[7]              = CMC.P4_IL.cc.LRU_var;
	assign g_intf.LRU_replacement_proc[7] = CMC.P4_IL.LRU_replacement_proc; 
	
	assign g_intf.BusRd                    = CMC.BusRd;
	assign g_intf.BusRdX                   = CMC.BusRdX;
	assign g_intf.Invalidate               = CMC.Invalidate;
	assign g_intf.Shared                   = CMC.Shared;
	
	
	
	//always @(g_intf.clk) begin
	
	assign g_intf.Updated_MESI_state_proc[0]  = CMC.P1_DL.cb.Updated_MESI_state_proc; 
	assign g_intf.Blk_access_proc[0]          = CMC.P1_DL.cb.Blk_access_proc;
	assign g_intf.Blk_access_snoop[0]         = CMC.P1_DL.cb.Blk_access_snoop;
	assign g_intf.Index_snoop[0]              = CMC.P1_DL.cb.Index_snoop;
	
	assign g_intf.Updated_MESI_state_proc[1]  = CMC.P2_DL.cb.Updated_MESI_state_proc; 
	assign g_intf.Blk_access_proc[1]          = CMC.P2_DL.cb.Blk_access_proc;
	assign g_intf.Blk_access_snoop[1]         = CMC.P2_DL.cb.Blk_access_snoop;
	assign g_intf.Index_snoop[1]              = CMC.P2_DL.cb.Index_snoop; 
	
	assign g_intf.Updated_MESI_state_proc[2]  = CMC.P3_DL.cb.Updated_MESI_state_proc; 
	assign g_intf.Blk_access_proc[2]          = CMC.P3_DL.cb.Blk_access_proc;
	assign g_intf.Blk_access_snoop[2]         = CMC.P3_DL.cb.Blk_access_snoop;
	assign g_intf.Index_snoop[2]              = CMC.P3_DL.cb.Index_snoop;
	
	assign g_intf.Updated_MESI_state_proc[3]  = CMC.P4_DL.cb.Updated_MESI_state_proc; 
	assign g_intf.Blk_access_proc[3]          = CMC.P4_DL.cb.Blk_access_proc;
	assign g_intf.Blk_access_snoop[3]         = CMC.P4_DL.cb.Blk_access_snoop;
	assign g_intf.Index_snoop[3]              = CMC.P4_DL.cb.Index_snoop;
	
	 //g_intf.Updated_MESI_state_proc[4]  = CMC.P1_IL.cb.Updated_MESI_state_proc; 
	assign g_intf.Blk_access_proc[4]          = CMC.P1_IL.cb.Blk_access_proc;
	 //g_intf.Blk_access_snoop[4]         = CMC.P1_IL.cb.Blk_access_snoop;
	 //g_intf.Index_snoop[4]              = CMC.P1_IL.cb.Index_snoop;
	
	 //g_intf.Updated_MESI_state_proc[5]  = CMC.P2_IL.cb.Updated_MESI_state_proc; 
	assign g_intf.Blk_access_proc[5]          = CMC.P2_IL.cb.Blk_access_proc;
	 //g_intf.Blk_access_snoop[5]         = CMC.P2_IL.cb.Blk_access_snoop;
	 //g_intf.Index_snoop[5]              = CMC.P2_IL.cb.Index_snoop;
	
	 //g_intf.Updated_MESI_state_proc[6]  = CMC.P3_IL.cb.Updated_MESI_state_proc; 
	assign  g_intf.Blk_access_proc[6]          = CMC.P3_IL.cb.Blk_access_proc;
	 //g_intf.Blk_access_snoop[6]         = CMC.P3_IL.cb.Blk_access_snoop;
	 //g_intf.Index_snoop[6]              = CMC.P3_IL.cb.Index_snoop;
	
	 //g_intf.Updated_MESI_state_proc[7]  = CMC.P4_IL.cb.Updated_MESI_state_proc; 
	assign g_intf.Blk_access_proc[7]          = CMC.P4_IL.cb.Blk_access_proc;
	 //g_intf.Blk_access_snoop[7]         = CMC.P4_IL.cb.Blk_access_snoop;
	 //g_intf.Index_snoop[7]              = CMC.P4_IL.cb.Index_snoop;
	
	// end


//The port connections are made without the knowledge of the actual design. It is supposed to change later.
cache_multi_config_1 CMC (
                                                                g_intf.clk,
								g_intf.PrWr[0]              ,
								g_intf.PrRd[0]              ,
								g_intf.Address[0]           ,
								g_intf.Data_Bus[0]          ,
								g_intf.CPU_stall[0]         ,
								g_intf.Com_Bus_Req_proc[0],
								g_intf.Com_Bus_Gnt_proc[0],
								g_intf.Com_Bus_Req_snoop[0],
								g_intf.Com_Bus_Gnt_snoop[0],
								g_intf.PrWr[1]              ,
								g_intf.PrRd[1]              ,
								g_intf.Address[1]           ,
								g_intf.Data_Bus[1]          ,
								g_intf.CPU_stall[1]         ,
								g_intf.Com_Bus_Req_proc[1]  ,
								g_intf.Com_Bus_Gnt_proc[1]  ,
								g_intf.Com_Bus_Req_snoop[1] ,
								g_intf.Com_Bus_Gnt_snoop[1] ,
								g_intf.PrWr[2]              ,
								g_intf.PrRd[2]              ,
								g_intf.Address[2]           ,
								g_intf.Data_Bus[2]          ,
								g_intf.CPU_stall[2]         ,
								g_intf.Com_Bus_Req_proc[2]  ,
								g_intf.Com_Bus_Gnt_proc[2]  ,
								g_intf.Com_Bus_Req_snoop[2] ,
								g_intf.Com_Bus_Gnt_snoop[2] ,
								g_intf.PrWr[3]              ,
								g_intf.PrRd[3]              ,
								g_intf.Address[3]           ,
								g_intf.Data_Bus[3]          ,
								g_intf.CPU_stall[3]         ,
								g_intf.Com_Bus_Req_proc[3]  ,
								g_intf.Com_Bus_Gnt_proc[3]  ,
								g_intf.Com_Bus_Req_snoop[3] ,
								g_intf.Com_Bus_Gnt_snoop[3] ,
								g_intf.Address_Com,
								g_intf.Data_Bus_Com,
								g_intf.Data_in_Bus,
								g_intf.Mem_wr,
								g_intf.Mem_oprn_abort,
								g_intf.Mem_write_done,
								g_intf.PrWr[4]              ,
								g_intf.PrRd[4]              ,
								g_intf.Address[4]           ,
								g_intf.Data_Bus[4]          ,
								g_intf.CPU_stall[4]         ,
								g_intf.Com_Bus_Req_proc[4]  ,
								g_intf.Com_Bus_Gnt_proc[4]  ,
								g_intf.PrWr[5]              ,
								g_intf.PrRd[5]              ,
								g_intf.Address[5]           ,
								g_intf.Data_Bus[5]          ,
								g_intf.CPU_stall[5]         ,
								g_intf.Com_Bus_Req_proc[5]  ,
								g_intf.Com_Bus_Gnt_proc[5]  ,
								g_intf.PrWr[6]              ,
								g_intf.PrRd[6]              ,
								g_intf.Address[6]           ,
								g_intf.Data_Bus[6]          ,
								g_intf.CPU_stall[6]         ,
								g_intf.Com_Bus_Req_proc[6]  ,
								g_intf.Com_Bus_Gnt_proc[6]  ,
								g_intf.PrWr[7]              ,
								g_intf.PrRd[7]              ,
								g_intf.Address[7]           ,
								g_intf.Data_Bus[7]          ,
								g_intf.CPU_stall[7]         ,
								g_intf.Com_Bus_Req_proc[7]  ,
								g_intf.Com_Bus_Gnt_proc[7]  

);


	initial begin
		clk = 0;
		$display("Hello World.. starting test!");
		run_test();
	end
endmodule
