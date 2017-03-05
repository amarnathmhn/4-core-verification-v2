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


//Top module that applies stimulus to the DUT
module testDut_1Core();

 //create the clock register to be used throughout the simulation for all
 //blocks
 reg clk;
//define Com_Bus_Req_snoop register
wire [3:0] Com_Bus_Req_snoop;


reg Com_Bus_Gnt_snoop_0;
reg Com_Bus_Gnt_snoop_1;
reg Com_Bus_Gnt_snoop_2;
reg Com_Bus_Gnt_snoop_3;

wire Com_Bus_Req_proc;
wire Com_Bus_Gnt_proc;
wire Com_Bus_Gnt_proc_0;
wire Com_Bus_Gnt_proc_1;
wire Com_Bus_Gnt_proc_2;
wire Com_Bus_Gnt_proc_3;
wire Com_Bus_Gnt_proc_4;
wire Com_Bus_Gnt_proc_5;
wire Com_Bus_Gnt_proc_6;
wire Com_Bus_Gnt_proc_7;

//Define wires for inout ports
wire [`ADDRESSSIZE - 1 : 0] Address_Com;
wire [`ADDRESSSIZE - 1 : 0] Data_Bus_Com;
wire [`ADDRESSSIZE - 1 : 0] Data_Bus;
wire                        BusRd;
wire                        BusRdX;
wire                        Invalidate;
wire                        Data_in_Bus;
//Instantiate the interface through which the Verification testbench and the
//DUT connect
globalInterface g_intf();
//.Com_Bus_Req_snoop(Com_Bus_Req_snoop[0]),
//                       .Address_Com(Address_Com),
//                       .Data_Bus_Com(Data_Bus_Com),
//                       .Data_Bus(Data_Bus),
//                       .BusRd(BusRd),
//                       .BusRdX(BusRdX),
//                       .Invalidate(Invalidate),

assign g_intf.Address_Com     =  g_intf.PrRd || g_intf.PrWr ?Address_Com : 32'hZ;
assign g_intf.Data_Bus_Com    =  g_intf.PrWr ? Data_Bus_Com       : 32'hZ; 
assign g_intf.Data_Bus        =  g_intf.PrRd ? Data_Bus           : 32'hZ;
assign g_intf.BusRd           =  g_intf.PrRd ? BusRd              : 32'hZ;
assign g_intf.BusRdX          =  g_intf.PrWr ? BusRdX             : 32'hZ;
assign g_intf.Invalidate      =  g_intf.PrWr ? Invalidate         : 32'hZ;
assign g_intf.Data_in_Bus     =  g_intf.PrWr ? Data_in_Bus        : 32'hZ;
assign g_intf.Blk_offset_proc =  P1_DL.cb.Blk_offset_proc;
assign g_intf.Tag_proc        =  P1_DL.cb.Tag_proc;
assign g_intf.Index_proc      =  P1_DL.cb.Index_proc;
assign g_intf.Com_Bus_Gnt_proc = Com_Bus_Gnt_proc;
assign g_intf.Com_Bus_Req_proc = Com_Bus_Req_proc;
 
//Instantiate the local virtual interface which is passed to various tasks
 //defined in test cases in TestCases.sv
virtual interface globalInterface local_g_intf;

 //Connect DUT to the global interface as follows
  cache_wrapper_1 P1_DL (   .clk(g_intf.clk),
                            .PrWr(g_intf.PrWr),
                            .PrRd(g_intf.PrRd),
                            .Address(g_intf.Address),
                            .Data_Bus(Data_Bus),
                            .CPU_stall(g_intf.CPU_stall),
                            .Com_Bus_Req_proc(Com_Bus_Req_proc),
                            .Com_Bus_Gnt_proc(Com_Bus_Gnt_proc),
                            .Com_Bus_Req_snoop(g_intf.Com_Bus_Req_snoop),
                            .Com_Bus_Gnt_snoop(g_intf.Com_Bus_Gnt_snoop),
                            .Address_Com(Address_Com),
                            .Data_Bus_Com(Data_Bus_Com),
                            .BusRd(BusRd),
                            .BusRdX(BusRdX),
                            .Invalidate(Invalidate),
                            .Data_in_Bus(Data_in_Bus),
                            .Mem_wr(g_intf.Mem_wr),
                            .Mem_oprn_abort(g_intf.Mem_oprn_abort),
                            .Mem_write_done(g_intf.Mem_write_done),
                            .Invalidation_done(g_intf.Invalidation_done),
                            .All_Invalidation_done(g_intf.All_Invalidation_done),
                            .Shared_local(g_intf.Shared_local),
                            .Shared(g_intf.Shared)
                           );
 
//Connect Arbiter to the global interface as follows
arbiter 		a1 		(       Com_Bus_Req_proc,
						1'b0,
						1'b0,
						1'b0,
						1'b0,
						1'b0,
						1'b0,
						1'b0,
                                                1'b0,
						1'b0,
						1'b0,
						1'b0,
						Com_Bus_Gnt_proc,
					        Com_Bus_Gnt_proc_1,
					        Com_Bus_Gnt_proc_2,
					        Com_Bus_Gnt_proc_3,
					        Com_Bus_Gnt_proc_4,
					        Com_Bus_Gnt_proc_5,
					        Com_Bus_Gnt_proc_6,
					        Com_Bus_Gnt_proc_7,	
						Com_Bus_Gnt_snoop_0,
						Com_Bus_Gnt_snoop_1,
						Com_Bus_Gnt_snoop_2,
						Com_Bus_Gnt_snoop_3,
						g_intf.Mem_snoop_req,
						g_intf.Mem_snoop_gnt);
                          
 
 assign clk = a1.clk;
 

//connect clk to the interface thereby connecting to all blocks of DUT and
//Verification testbench environment.
assign g_intf.clk = clk;
 
//Instantiate a Top level direct testcase object
topReadMiss topReadMiss_inst;

//Instantiate a Unit level constrained random test case
unitMESIProc unitMESIProc_inst;

//Instantiate a Macro level constrained random test case
testAddrSeg  macroAddrSeg_inst;

//Top level Read hit testing
topReadHit topReadHit_inst;

//Top level Write hit testing
topWriteMiss topWriteMiss_inst;
//Task to reset signals after each operation

  task reset_DUT_inputs(virtual interface globalInterface dif);

        dif.Address_Com 			= 32'hZ;
	dif.Data_Bus_Com 			= 32'hZ;
	dif.Data_in_Bus 	 		= 32'hZ;	
	dif.Data_Bus                	        = 32'hZ;
        dif.PrRd                                = 0;
        dif.PrWr                                = 0;
        dif.Address                             = 32'hz;
 
  endtask : reset_DUT_inputs
 
    int x;
 initial begin
  
 //assign the virtual interface
  local_g_intf = g_intf;
//Idea is to begin verification at Macro Level according to the verification
//theory which enables us to find quick low level bugs
//Simulation method is shown for one of Macro level, One of Unit Level, and One of Top level
 
 //1) Macro level Test :testAddrSeg
 //   reset_DUT_inputs(local_g_intf);
 //   macroAddrSeg_inst = new();
//x// = 0;
 //    macroAddrSeg_inst.randomize() with {Address == 32'hffffffff;};
 //    $display("run number %d, Address generated is %d", x++,macroAddrSeg_inst.Address );
 //    macroAddrSeg_inst.testAddr(local_g_intf);
 //  #100; 
 

 //2) Unit level Test : unitMESIProc.. Repeat for more coverage. Dynamic
 //assesment of coverage still to be figured out
 //Also a Constrained Random Test
  //  $display("******* STARTING 2nd TEST ************"); 
  //  reset_DUT_inputs(local_g_intf);
  //  unitMESIProc_inst = new();
  //  void'(unitMESIProc_inst.randomize());
  //  unitMESIProc_inst.testUnitMESIProc(local_g_intf);
  //  #100;
  //  $finish;


//1) Directed : topReadMiss, Top level test
    #10;
    reset_DUT_inputs(local_g_intf);
    topReadMiss_inst = new();
    topReadMiss_inst.randomize() with {Address == 32'hdeadbeef;};
    topReadMiss_inst.testSimpleReadMiss(local_g_intf);
    $display("1) Test topReadMiss_inst done with Address %x ", g_intf.Address);
    // BUG 2 in Bug_Report.log is found with above test.
    //Check if Data is Properly Stored
    $display("Data at Address = %x is Data = %x",g_intf.Address, P1_DL.cb.Cache_var[{g_intf.Address[`INDEX_MSB: `INDEX_LSB],P1_DL.cb.Blk_access_proc}][`CACHE_DATA_MSB:`CACHE_DATA_LSB]);
 
 //2)Test Write Miss
 //   reset_DUT_inputs(local_g_intf);
 //  $display("2) Trying to Write to an address....");
 //   topWriteMiss_inst = new();
 //   topWriteMiss_inst.randomize() with {Address == 32'h00000000;};
 //   topWriteMiss_inst.testWriteMiss(local_g_intf);
 //  $display("Write Complete to address %x", g_intf.Address);
 //  $display("Trying to Read from the same address %x",g_intf.Address);
 //
 //Set the environment for read hit
 //   reset_DUT_inputs(local_g_intf);
 //   #10; 
 //   topReadHit_inst = new();
 //   topReadHit_inst.randomize() with {Address == 32'hDEADBEEF;};
 //   
 //   topReadHit_inst.testSimpleReadHit(local_g_intf);
 //   $display("Test topReadHit_inst with Address %x ", g_intf.Address);
 //   #100;
 //   $finish; 

 //Repeat the above procedure for all other test cases when the design is
 //finally released.
  
 end
 
endmodule

