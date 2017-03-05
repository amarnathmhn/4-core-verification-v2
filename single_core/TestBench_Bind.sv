//IMPORTANT: This documents contains top module which does Simulation Based verification of DUT. The test cases used are taken from TestCases.sv file.
//Test Cases for IL are a subset of Test Cases for DL. MESI and Snoop based
//testing are only applicable for DL. So IL can be tested by following steps
//similar to that of DL

`timescale 1ps/1ps
//include Design Files
`include "cache_wrapper_1.v"
`include "arbiter.v"
`include "TestCases.sv"

//define half clock period
`define HALF_PERIOD 100

module top_C1();


 //Global interface containing all the signals that need to be
 //driven/monitored
 globalInterface g_intf();


 //Virtual interface for global interface

 assign g_intf.clk = a.clk;
 
 bind cache_wrapper_1: P1_DL globalInterface g_intf();
 virtual interface globalInterface local_intf;
 //assign Data_Bus_Com = g_intf.PrRd || g_intf.PrWr ? g_intf.Data_Bus_Com : 32'hZ;
 //assign Data_in_Bus  = g_intf.PrRd || g_intf.PrWr ? g_intf.Data_in_Bus  : 32'hZ;
 ////Connect the inner blocks of CC/CB with the global interface
 //assign g_intf.Cache_var        = P1_DL.cb.Cache_var; 
 //assign g_intf.Cache_proc_contr = P1_DL.cb.Cache_proc_contr;
 //assign g_intf.Updated_MESI_state_proc = P1_DL.cb.Updated_MESI_state_proc; 
  
cache_wrapper_1 P1_DL (
                        g_intf.clk,
                        g_intf.PrWr,
                        g_intf.PrRd,
                        g_intf.Address,
                        g_intf.Data_Bus,
                        g_intf.CPU_stall,
                        g_intf.Com_Bus_Req_proc_0,
                        g_intf.Com_Bus_Gnt_proc_0,
                        g_intf.Com_Bus_Req_snoop_0,
                        g_intf.Com_Bus_Gnt_snoop_0,
                        g_intf.Address_Com,
                        g_intf.Data_Bus_Com,
                        g_intf.BusRd,
                        g_intf.BusRdX,
                        g_intf.Invalidate,
                        g_intf.Data_in_Bus,
                        g_intf.Mem_wr,
                        g_intf.Mem_oprn_abort,
                        g_intf.Mem_write_done,
                        g_intf.Invalidation_done,
                        g_intf.All_Invalidation_done,
                        g_intf.Shared_local,
                        g_intf.Shared

);
 
arbiter a (
                        g_intf.Com_Bus_Req_proc_0,
			g_intf.Com_Bus_Req_proc_1,
			g_intf.Com_Bus_Req_proc_2,
			g_intf.Com_Bus_Req_proc_3,
			g_intf.Com_Bus_Req_proc_4,
			g_intf.Com_Bus_Req_proc_5,
			g_intf.Com_Bus_Req_proc_6,
			g_intf.Com_Bus_Req_proc_7,
			g_intf.Com_Bus_Req_snoop_0,
			g_intf.Com_Bus_Req_snoop_1,
			g_intf.Com_Bus_Req_snoop_2,
			g_intf.Com_Bus_Req_snoop_3,
			g_intf.Com_Bus_Gnt_proc_0,
			g_intf.Com_Bus_Gnt_proc_1,
			g_intf.Com_Bus_Gnt_proc_2,
			g_intf.Com_Bus_Gnt_proc_3,
			g_intf.Com_Bus_Gnt_proc_4,
			g_intf.Com_Bus_Gnt_proc_5,
			g_intf.Com_Bus_Gnt_proc_6,
			g_intf.Com_Bus_Gnt_proc_7,
			g_intf.Com_Bus_Gnt_snoop_0,
			g_intf.Com_Bus_Gnt_snoop_1,
			g_intf.Com_Bus_Gnt_snoop_2,
			g_intf.Com_Bus_Gnt_snoop_3,
			g_intf.Mem_snoop_req,
			g_intf.Mem_snoop_gnt
);

//Instantiate a Top level direct testcase object
topReadMiss topReadMiss_inst;
topReadHit  topReadHit_inst;

initial
 begin
   local_intf       = g_intf;
   $display("Testing Read Miss Scenario using topReadMiss test case");
// top read miss
   topReadMiss_inst = new();
   topReadMiss_inst.randomize() with {Address == 32'hdeadbeef;};
   topReadMiss_inst.testSimpleReadMiss(local_intf);
   $display("1) Test topReadMiss_inst done with Address %x ", g_intf.Address);
   #100;
   $display("Data in cache is %x,",g_intf.Cache_var[{g_intf.Address[`INDEX_MSB: `INDEX_LSB],P1_DL.cb.Blk_access_proc}][`CACHE_DATA_MSB:`CACHE_DATA_LSB]);
   #2;
   $display("Updated_MESI_state_proc = %d at time = %d",g_intf.Updated_MESI_state_proc,$time);
   $display("Updated_MESI_state_proc from Cache_proc_contr = %d at time = %d",g_intf.Cache_proc_contr[{g_intf.Index_proc,g_intf.Blk_access_proc}][`CACHE_MESI_MSB:`CACHE_MESI_LSB],$time);
   #100;
   topReadMiss_inst.reset_DUT_inputs(local_intf);
   #100;
  
    //top read hit
//   local_intf       = g_intf;
//   topReadHit_inst = new();
//   topReadHit_inst.randomize() with {Address == 32'hdeadbeef;};
//   topReadHit_inst.testSimpleReadHit(local_intf);
//   $display("1) Test topReadHit_inst done with Address %x ", g_intf.Address);
//   #100;
//   $display("Data in cache is %x,",P1_DL.cb.Cache_var[{g_intf.Address[`INDEX_MSB: `INDEX_LSB],P1_DL.cb.Blk_access_proc}][`CACHE_DATA_MSB:`CACHE_DATA_LSB]);
//   #100;
//   topReadHit_inst.reset_DUT_inputs(local_intf);
//   #100; 
//   $finish;   
 end 
initial begin
  wait(g_intf.PrRd);
  #10;
  wait(g_intf.PrRd);
  #100;
end
endmodule
