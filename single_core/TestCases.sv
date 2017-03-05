//This document contains the Test Bench to verify Single Core L1 MESI Cache in a Multicore environment. Any References to section numbers in the comments have to be looked up in the verification plan submitted.
//NOTE: All the signals to the DUT/Arbiter are accessed via an sv interface. When the DUT and Arbiter Designs are made available, 
//they shall be connected to the interface.
//In order to test the depth of functionality, a top level test is
//instantiated inside another test and then low level verification is done in
//this test within the top level test

`timescale 1ps/1ps
//Include defines.sv file containing all Macros
//`include "defines.sv"
`include "interfaces.sv"
//enum type for MESI States
typedef enum bit[1:0] {INVALID, SHARED, EXCLUSIVE, MODIFIED} mesiStateType;
//Define a base class that contains repeatedly used waiting tasks and fields.
class baseTestClass;
   
  
  string status ="PASSED"; 
  
  rand reg[`ADDRESSSIZE - 1 : 0] Address;
   
   constraint c_Address { Address inside {[32'h00000000:32'hffffffff]};}

   //Delay until Cache Wrapper responds to any stimulus either from Proc or Arbiter or Memory. Measured in cycles of clk
   rand int Max_Resp_Delay;
   rand bit Shared = 0;
   constraint c_max_delay {Max_Resp_Delay inside {[6:50]};}
   int delay;
   reg [2:0] expected_lru_var;
   reg [1:0] expected_line_to_replace;
   
   
   //Task to wait and check for Com_Bus_Req_proc_0 and CPU_Stall to be asserted
   virtual task check_ComBusReqproc_CPUStall_assert(virtual interface globalInterface sintf);
      delay = 0;
      fork
        begin 
         while(delay <= Max_Resp_Delay) begin
           @(posedge sintf.clk);
           delay += 1; 
         end 
        end
        begin 
           wait(sintf.Com_Bus_Req_proc_0 && sintf.CPU_stall);
        end
      join_any
      disable fork;
    //Check if Com_Bus_Req_proc_0 is asserted  
    assert(sintf.Com_Bus_Req_proc_0) $display("SUCCESS:: Com_Bus_Req_Proc and CPU_stall are asserted within timeout after PrRd/PrWr is asserted");
    else begin $display("BUG:: Com_Bus_Req_Proc or CPU_stall is not asserted after PrRd/PrWr");
      status = "FAILED";
    end
    return;
   endtask : check_ComBusReqproc_CPUStall_assert
   
   //Task to wait and check for Com_Bus_Req_snoop_0 to be asserted
   virtual task check_ComBusReqSnoop_assert(virtual interface globalInterface sintf);
      delay = 0;
      fork
        begin 
         while(delay <= Max_Resp_Delay) begin
           @(posedge sintf.clk);
           delay += 1; 
         end 
        end
        begin 
           wait(sintf.Com_Bus_Req_snoop_0);
        end
      join_any
      disable fork;
    //Check if Com_Bus_Req_ is asserted  
    assert(sintf.Com_Bus_Req_snoop_0) $display("SUCCESS:: Com_Bus_Req_snoop_0 is asserted within timeout after BusRd/BusRdX is asserted");
    else begin $display("BUG:: Com_Bus_Req_snoop_0 is not asserted after BusRd/BusRdX");
     status = "FAILED";
    end
   endtask : check_ComBusReqSnoop_assert
   
   
   //Task to wait and check for Com_Bus_Req_snoop_0 to be deasserted
   virtual task check_ComBusReqSnoop_deassert(virtual interface globalInterface sintf);
      delay = 0;
      fork
        begin 
         while(delay <= Max_Resp_Delay) begin
           @(posedge sintf.clk);
           delay += 1; 
         end 
        end
        begin 
           wait(!sintf.Com_Bus_Req_snoop_0);
        end
      join_any
      disable fork;
    //Check if Com_Bus_Req_ is asserted  
    assert(!sintf.Com_Bus_Req_snoop_0) $display("SUCCESS:: Com_Bus_Req_snoop_0 is deasserted within timeout after BusRd is asserted");
    else $warning(1,"TEST:  Checker: Com_Bus_Req_snoop_0 is not deasserted after BusRd", $time);
   endtask : check_ComBusReqSnoop_deassert
 
   //Task to wait for Com_Bus_Req_proc_0 and CPU_Stall to be deasserted
   virtual task check_ComBusReqproc_CPUStall_deaassert(virtual interface globalInterface sintf);
      delay = 0;
      fork
        begin 
         while(delay <= Max_Resp_Delay) begin
           @(posedge sintf.clk);
           delay += 1; 
         end 
        end
        begin 
           wait(!sintf.Com_Bus_Req_proc_0 && !sintf.CPU_stall);
        end
      join_any
      disable fork;
      assert(!sintf.CPU_stall) $display("SUCCESS:: CPU_stall De-Asserted");
      else  begin $display("BUG:: CPU_stall not deasserted");
       status = "FAILED";
      end
      assert(!sintf.Com_Bus_Req_proc_0) $display("SUCCESS:: Com_Bus_Req_proc_0 De-Asserted");
      else begin $display("BUG:: Com_Bus_Req_proc_0 not deasserted");
       status = "FAILED";
      end
   endtask : check_ComBusReqproc_CPUStall_deaassert
 
    //Task to wait for Com Bus Gnt Proc to be asserted
    virtual task check_ComBusGntproc_assert(virtual interface globalInterface sintf);
    delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
      end
      begin 
         wait(sintf.Com_Bus_Gnt_proc_0);
      end
    join_any
    disable fork;
    return;
   endtask : check_ComBusGntproc_assert
   //Task to wait for BusRd is raised.
   virtual task check_BusRd_assert(virtual interface globalInterface sintf);
    delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
      end
      begin 
         wait(sintf.BusRd);
      end
    join_any
    assert(sintf.BusRd) $display("SUCCESS:: BusRd Asserted Properly ");
    disable fork;
    return;
   endtask : check_BusRd_assert
   
  //Task to wait till address placed by cache on Address_Com bus
  virtual task check_Address_Com_load(virtual interface globalInterface sintf);
    delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
      end
      begin 
         wait(sintf.Address[31:2] == sintf.Address_Com[31:2]);
      end
    join_any
    disable fork;
    
    assert(sintf.Address[31:2] == sintf.Address_Com[31:2] &&
           sintf.Address_Com[1:0] == 0) $display("SUCCESS:: Correct Address is placed on Address_Com Bus"); 
    else $warning(1," Checker: Address is either not placed on Address_Com bus or wrong address is placed",$time);
    return;
  endtask : check_Address_Com_load

//Task to wait till CPU_stall is de-asserted
virtual task check_CPU_stall_deassert(virtual interface globalInterface sintf);
     delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         wait(!sintf.CPU_stall);
      end
    join_any
    disable fork;
    assert(!sintf.CPU_stall) $display("SUCCESS:: CPU_stall is De-asserted"); 
    else begin $display("BUG:: CPU stall not de-asserted ");
     status = "FAILED";
    end
  endtask : check_CPU_stall_deassert
  
  //Task to wait till BusRdX is asserted
 virtual task check_BusRdX_assert(virtual interface globalInterface sintf);
     delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         wait(sintf.BusRdX);
      end
    join_any
    disable fork;
    assert(sintf.BusRdX) $display("SUCCESS:: BusRdX is asserted within timeout");
    else $display("BUG:: BusRdX  not asserted within timeout");
  endtask : check_BusRdX_assert
  
  
  //Task to wait till BusRdX is asserted
 virtual  task check_MemOprnAbrt_assert(virtual interface globalInterface sintf);
     delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         wait(sintf.Mem_oprn_abort);
      end
    join_any
    disable fork;
    assert(sintf.Mem_oprn_abort)
    else $warning(1," Checker:  Mem_oprn_abort not asserted",$time);
  endtask : check_MemOprnAbrt_assert
 
// Check for Shared to be asserted
virtual task check_Shared_assert(virtual interface globalInterface sintf);
   delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         wait(sintf.ClkBlk.Shared);
      end
    join_any
    disable fork;
    assert(sintf.ClkBlk.Shared)
    else begin $display("BUG:: Shared not asserted");
      status = "FAILED"; 
    end
endtask : check_Shared_assert

// Check for Invalidate to be asserted
virtual task check_Invalidate_assert(virtual interface globalInterface sintf);
   delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         @(posedge sintf.Invalidate);
      end
    join_any
    disable fork;
    assert(sintf.Invalidate) $display("SUCCESS:: Invalidate asserted properly");
    else begin $display("BUG:: Invalidate not asserted");
       status = "FAILED";
    end
endtask : check_Invalidate_assert

// Check for Mem_wr to be asserted
virtual task check_MemWr_assert(virtual interface globalInterface sintf);
   delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         wait(sintf.Mem_wr);
      end
    join_any
    disable fork;
    assert(sintf.Mem_wr)
    else $warning(1," Checker:  Invalidate not asserted",$time);
endtask : check_MemWr_assert

// Check for Data in Bus to be asserted
virtual task check_DataInBus_assert(virtual interface globalInterface sintf);
   delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         wait(sintf.Data_in_Bus);
      end
    join_any
    disable fork;
    assert(sintf.Invalidate)
    else $warning(1," Checker:  Data in Bus not asserted",$time);
endtask : check_DataInBus_assert

//Task to wait till Single Bit is asserted! Alas Not working...Must find a new strategy to make this work. For now it shall  be here!
 virtual task check_singleBit_assert(input sbit, virtual interface
globalInterface sintf  );
     delay = 0;
    fork
      begin
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         $display("delay = %d, Max_Resp_Delay = %d, BIT = %d", delay, Max_Resp_Delay, sbit);
         delay += 1; 
       end 
       end
      begin 
         wait(sbit);
      end
    join_any
    disable fork;
    assert(sbit)
    else $warning(1," %m : Checker:  Required Bit Field not asserted",$time);
  endtask : check_singleBit_assert
  
  //Task to wait till Bus is valid..same fate as above
  virtual task check_bus_valid(input logic [31:0] BUS, virtual interface globalInterface sintf );
    delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         wait(BUS != 32'hz);
      end
    join_any
    disable fork;
    assert(BUS != 32'hz)
    else $warning(1," %m: Checker:  The BUS contains invalid value",$time);
  endtask : check_bus_valid

 //Task to wait till DataBusCom is valid.
  virtual task check_DataBusCom_valid(virtual interface globalInterface sintf,input[31:0] data );
    delay = 0;
    fork
      begin 
       while(delay <= Max_Resp_Delay) begin
         @(posedge sintf.clk);
         delay += 1; 
       end 
       end
      begin 
         wait(sintf.ClkBlk.Data_Bus_Com == data);
      end
    join_any
    disable fork;
    assert(sintf.ClkBlk.Data_Bus_Com == data) $display("SUCCESS:: Data placed on ClkBlk.Data_Bus_Com matches input data");
    else $display("BUG:: ClkBlk.Data_Bus_Com contains incorrect data");
  endtask : check_DataBusCom_valid



  //Task to check actual and expected next MESI states
    virtual task check_MESI_fsm(virtual interface globalInterface sintf, input
mesiStateType expectedMesiState);
    mesiStateType mst;
    delay = 0;
    while(sintf.Updated_MESI_state_proc != expectedMesiState)begin
       delay += 1;
       @(posedge sintf.clk);
       if(delay >= Max_Resp_Delay)
        break;
     end
     mst = mesiStateType'(sintf.Updated_MESI_state_proc);
    assert(sintf.Updated_MESI_state_proc == expectedMesiState) $display("SUCCESS:: Next MESI State consistent with Expected MESI State: Expected = %s, Actual = %s",expectedMesiState.name(),mst.name());
    else begin $display("BUG:: Next MESI State does not match with expected next MESI state: Expected = %s, Actual = %s",expectedMesiState.name(),mst.name());
     status = "FAILED";
    end
  endtask : check_MESI_fsm

  //Task to check if Data Bus is set with valid data
  virtual task check_DataBus_valid(virtual interface globalInterface sintf,input [31:0] data );
    delay = 0;
    while(sintf.Data_Bus != data || data=== 32'hz || sintf.Data_Bus === 32'hZ) begin
         delay += 1; 
         @(posedge sintf.clk);
         if(delay >= Max_Resp_Delay)
           break;
    end
    assert(sintf.Data_Bus === data) $display("SUCCESS:: Correct data is placed by cache on Data_Bus to the proc: Data Bus = %x, ClkBlk.Data_Bus_Com = %x",sintf.Data_Bus,data);
    else begin $display("BUG:: The Data_Bus contains invalid value: Data_Bus = %x, Expected Data = %x",sintf.Data_Bus,data);
      status = "FAILED";
    end
  endtask : check_DataBus_valid

 //Task to check if Memory is loaded with correct data. Need to fix. Doesnot take correct data
 virtual task check_CacheVar_Data(virtual interface globalInterface sintf, input [31:0] data,input [31:0] Address);
 reg [31:0] temp_data;   
    delay = 0;
      while(sintf.Cache_var[{Address[`INDEX_MSB:`INDEX_LSB],sintf.Blk_access_proc}][`CACHE_DATA_MSB:`CACHE_DATA_LSB] != data ) begin
           delay += 1;
           if(delay >= Max_Resp_Delay) begin
              $display("WARNING:: Timeout for Data to be stored in the Cache");
              break;
           end
           @(posedge sintf.clk);
      end
    temp_data = sintf.Cache_var[{Address[`INDEX_MSB:`INDEX_LSB],sintf.Blk_access_proc}][`CACHE_DATA_MSB:`CACHE_DATA_LSB];
    assert(temp_data === data) $display("SUCCESS:: Data stored in Cache matches with Expected Data: Stored Data = %x , Expected Data = %x",temp_data,data);
    else $display("BUG:: Incorrect data is stored in the Cache: Stored Data = %x , Expected Data = %x ",$time,temp_data, data);
 endtask :  check_CacheVar_Data
  //Task to reset signals after each operation
  virtual task reset_DUT_inputs(virtual interface globalInterface dif);

        dif.Address_Com_reg 			<= 32'hZ;
	dif.ClkBlk.Data_Bus_Com 		<= 32'hZ;
	dif.Data_in_Bus_reg	 		<= 32'hZ;	
	dif.Data_Bus_reg                	<= 32'hZ;
        dif.ClkBlk.PrRd                         <= 0;
        dif.ClkBlk.PrWr                         <= 0;
        dif.ClkBlk.Address                      <= 32'hz;
        dif.BusRd_reg                           <= 1'bz;
        dif.BusRdX_reg                          <= 1'bz;
        dif.failed                              <= 1'b0;
 
  endtask : reset_DUT_inputs

 //task to determine LRU var state expected.
  virtual function determine_LRU_var_exp(input logic [1:0] line_no, ref logic [2:0] next_state);
    begin
       case(line_no)
          2'b00: next_state[2:1] = 2'b11;
          2'b01: next_state[2:1] = 2'b10;
          2'b10: begin next_state[2:2] =  1'b0; next_state[0:0] = 1'b1; end
          2'b11: begin next_state[2:2] =  1'b0; next_state[0:0] = 1'b0; end
       endcase
    end
  endfunction

 //task to determine LRU line to replace
  virtual function logic [1:0] determine_LineToBeReplaced_LRU(input logic[2:0] state);
    begin
      if(!state[2:2]) begin
          if(!state[1:1])
            return 2'b00;
          else return 2'b01; 
      end 
      else begin
          if(!state[0:0]) return 2'b10;
          else return 2'b11;
      end
    end
  endfunction : determine_LineToBeReplaced_LRU


endclass : baseTestClass 


//Test cases to verify top level functionality specified in section 4.8.1.
// A Simple Directed Testcase for Scenario 2,3,5,7 of Section 4.8.1: Read Miss with no copy available in other Caches. Verified at the top level
class topReadMiss extends baseTestClass;
   reg[31:0] DataWrittenByMem;
  //Drive DUT ports with this
  task drive(virtual globalInterface sintf);
    sintf.ClkBlk.PrRd <= 1;
     sintf.ClkBlk.PrWr <= 0;
     sintf.ClkBlk.Address <= Address;
     sintf.ClkBlk.Shared <= Shared;
     expected_lru_var = 3'bxxx; 
  endtask :drive 

  task check(virtual globalInterface sintf);
     var DataWrittenByMem =  32'hBABABABA;
     //Check for behavior
    //Com_Bus_Req_proc_0 and CPU_stall must be made high
     check_ComBusReqproc_CPUStall_assert(sintf);
    //Wait until arbiter grants access
     check_ComBusGntproc_assert(sintf);
     //check_ComBusGntproc_assert(sintf);
    
    //Check if the Cache raises BusRd
    check_BusRd_assert(sintf);
    
     //Snoop side activity
   
    //Wait until cache places Address in Address_Com bus
    check_Address_Com_load(sintf);
    
    //Main Memory requests for Bus Access. Wait for Bus Access Grant by the arbiter
    sintf.Mem_snoop_req = 1;
    wait(sintf.Mem_snoop_gnt == 1);
    //Main Memory puts data on the ClkBlk.Data_Bus_Com and raises Data_in_Bus
    sintf.ClkBlk.Data_Bus_Com <= DataWrittenByMem;
    sintf.Data_in_Bus_reg = 1;
    //Check if MESI State is properly assigned to block corresponding to the Address given
    if(sintf.Shared == 1)  
      check_MESI_fsm(sintf,SHARED);
    else if (sintf.Shared == 0)
      check_MESI_fsm(sintf,EXCLUSIVE);
       
    //Check if Memory is loaded with Correct Data
    check_CacheVar_Data(sintf,DataWrittenByMem,Address); 
    //Check if LRU Value is properly assigned
    //wait(sintf.Blk_access_proc != 2'bZZ && 
    //     sintf.Blk_access_proc != 2'bxx)
    determine_LRU_var_exp(sintf.Blk_access_proc,expected_lru_var);
    if(sintf.Blk_access_proc == 0 || sintf.Blk_access_proc == 1 ) begin
      assert(expected_lru_var[2:1] == sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]][2:1]) $display("SUCCESS:: Line accessed = %b, Expected LRU Var = %b, Actual LRY Var = %b ",sintf.Blk_access_proc,expected_lru_var,sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]]);
      else begin $display("BUG:: Expected lru var = %b, actual lru var = %b",expected_lru_var,sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]]); 
      end
    end
    else if (sintf.Blk_access_proc == 2 || sintf.Blk_access_proc == 3) begin
      assert({expected_lru_var[2],expected_lru_var[0]} == {sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]][2],sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]][0]}) $display("SUCCESS:: Line accessed = %b, Expected LRU Var = %b, Actual LRY Var = %b ",sintf.Blk_access_proc,expected_lru_var,sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]]);
      else begin $display("BUG:: Expected lru var = %b, actual lru var = %b",expected_lru_var,sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]]); 
      end
    end
    //Check if Data_Bus is valid with the data
    check_DataBus_valid(sintf,sintf.ClkBlk.Data_Bus_Com);
    
    //Check if CPU_stall and Com_Bus_Req_proc is de-asserted on asserting Data_in_Bus
    check_CPU_stall_deassert(sintf);
    check_ComBusReqproc_CPUStall_deaassert(sintf);
    repeat(Max_Resp_Delay) @sintf.clk;
  endtask : check
//   Creates the simple Read stimulus and drives it to the DUT and checks for the behavior. Take the single Top Level Cache interface as input.
   task testSimpleReadMiss(virtual globalInterface sintf);
      
     $display("\n****** Test topReadMiss Started ****** "); 
     
      drive(sintf); 
      check(sintf);
    repeat(Max_Resp_Delay) @sintf.clk;
    $display("****** Test topReadMiss Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
   endtask : testSimpleReadMiss
endclass : topReadMiss


// A Simple Directed Testcase for Scenario 1 of Section 4.8.1 :Read Hit. Verified at the top level
class topReadHit extends baseTestClass;
   rand reg[31:0] last_data_stored;
   task testSimpleReadHit(virtual interface globalInterface sintf);
      $display("\n****** Test topReadHit Started ****** "); 
      
      //Do a Read Hit
      sintf.ClkBlk.Address <= Address;
      sintf.ClkBlk.PrRd    <= 1;
      sintf.ClkBlk.PrWr    <= 0;
      $display("Data to be checked against %x",last_data_stored);
      //Check if Data is placed on Data_Bus
      check_DataBus_valid(sintf,last_data_stored); 
      
      //Check if CPU_stall and Com_Bus_Req_proc_0 is deasserted
      check_ComBusReqproc_CPUStall_deaassert(sintf);
      $display("****** Test topReadHit Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
       
   endtask : testSimpleReadHit
   

endclass : topReadHit


// A Simple Directed Testcase for Scenario 4,6,8 of Section 4.8.1. Read Miss with replacement required for a Modified block. Tests until the dirty block is written back to memory.

class topReadMissReplaceModified extends baseTestClass;
     topReadMiss topReadMiss_inst; 
     rand reg [`ADDRESSSIZE - 1 : 0] Address;
     constraint c_Address { Address inside {[32'h00000000:32'hffffffff]};}
     reg[1:0]   lineToBeRepl;
     reg [15:0] TagToBeRepl;
     reg [14:0] IndexToBeRepl;
     reg [31:0] DataToBeWrittenBack;
     mesiStateType actualMesi;
     //Delay until Cache Wrapper responds to any stimulus either from Proc or Arbiter or Memory. Measured in cycles of clk
     int delay;
     task testReadMissReplaceModified(virtual interface globalInterface sintf);
      
      $display("\n****** Test topReadMissReplaceModified Started ****** "); 
      $display("Processor Read Attempt is made for Address = %x",Address);
       
      sintf.ClkBlk.Address <= Address;
      sintf.ClkBlk.PrRd    <= 1;
      sintf.ClkBlk.PrWr    <= 0;
      sintf.ClkBlk.Shared  <= Shared;
      // Check for behavior
      //Com_Bus_Req_proc_0 and CPU_stall must be made high
      check_ComBusReqproc_CPUStall_assert(sintf);
      lineToBeRepl  =  determine_LineToBeReplaced_LRU(sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]]);
      IndexToBeRepl =  Address[`INDEX_MSB:`INDEX_LSB];
      TagToBeRepl   =  sintf.Cache_proc_contr[{IndexToBeRepl,lineToBeRepl}][`CACHE_TAG_MSB: `CACHE_TAG_LSB];
      //Since free block is not available, replacement of the modified block has to be carried out. Wait for bus access grant from arbiter
      wait(sintf.Com_Bus_Gnt_proc_0);
      //Wait till Address com bus is loaded with Address of the Block to be replaced
      $display("Address of the Block to be replaced = %x, Data at that location = %x",{TagToBeRepl,IndexToBeRepl,2'b00},sintf.Cache_var[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_DATA_MSB:`CACHE_DATA_LSB]); 
      delay = 0;
     fork
        begin 
         while(delay <= Max_Resp_Delay) begin
           @(posedge sintf.clk);
           delay += 1; 
         end 
        end
        begin 
           wait(sintf.Address_Com[31:2] == {sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_TAG_MSB:`CACHE_TAG_LSB],Address[`INDEX_MSB:`INDEX_LSB]});
        end
      join_any
      disable fork;
     
      
      assert(sintf.Address_Com[31:2] == {sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_TAG_MSB:`CACHE_TAG_LSB],Address[`INDEX_MSB:`INDEX_LSB]} ) $display("SUCCESS::Address_Com is loaded with correct address of the block to be replaced");
      else begin $display("BUG:: Expected Address_Com = %x, Actual Address_Com = %x",{sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_TAG_MSB:`CACHE_TAG_LSB],Address[`INDEX_MSB:`INDEX_LSB],2'b00},sintf.Address_Com[31:0]);
      status = "FAILED";
      end
      $display("SUCCESS::  Expected Address_Com = %x, Actual Address_Com = %x",{sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_TAG_MSB:`CACHE_TAG_LSB],Address[`INDEX_MSB:`INDEX_LSB],2'b00},sintf.Address_Com[31:0]);
      //Wait till Mem_wr signal is made high
      delay = 0;
      fork
        begin 
         while(delay <= Max_Resp_Delay) begin
           @(posedge sintf.clk);
           delay += 1; 
         end 
        end
        begin 
           wait(sintf.Mem_wr);
        end
      join_any
      disable fork;
      
      assert(sintf.Mem_wr) $display("SUCCESS:: Mem_wr is asserted");
      else begin $display("BUG:: Mem_wr is not asserted", $time);    
        status = "FAILED";
      end
      check_DataBusCom_valid(sintf,sintf.Cache_var[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_DATA_MSB:`CACHE_DATA_LSB]);
      //Memory asserts Memory Wr Done
      sintf.Mem_write_done = 1;
     //free block is now available. Cache will do free block operations for read miss.
     repeat(2) @(posedge sintf.clk);   
     sintf.Mem_write_done = 0;
     repeat(2) @(posedge sintf.clk);   
      
     wait(sintf.BusRd);
     sintf.Mem_snoop_req = 1;
     wait(sintf.Mem_snoop_gnt);
     @(posedge sintf.clk);
     sintf.ClkBlk.Data_Bus_Com <= 32'hdadadada;
     sintf.Data_in_Bus_reg  = 1;
     repeat(4) @(posedge sintf.clk);
     actualMesi = sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB];
     if(Shared == 0) begin
         assert(sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB] == EXCLUSIVE)
         else begin $display("BUG: Updated MESI State = %s Does not match with Expected state = EXCLUSIVE",actualMesi.name());
           status = "FAILED";
         end
     end
     else if (Shared == 1) begin
         assert(sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB] == SHARED)
         else begin $display("BUG: Updated MESI State = %x Does not match with Expected state = SHARED",sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB]);
          status = "FAILED";
         end
     end
      
     $display("****** Test topReadMissReplaceModified Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
     endtask : testReadMissReplaceModified

endclass : topReadMissReplaceModified


//A simple directed test for scenarios 10,11,13,15 in section 4.8.1. This will verify the basic write Miss operation with free block available
class topWriteMiss extends baseTestClass;
   
    //data to be written
   rand int wrData;
   constraint c_wrData  {wrData inside {[32'h00000000:32'hffffffff]};}
   task testWriteMiss(virtual interface globalInterface sintf);
        begin
         $display("\n****** Test topWriteMiss Started ****** "); 
          sintf.ClkBlk.PrWr      <= 1; 
          sintf.ClkBlk.PrRd      <= 0;
          sintf.ClkBlk.Address   <= Address; 
          sintf.Data_Bus_reg  = wrData;
         $display("Processor Write Attempt is made for Address = %x with Data = %x",Address, wrData);
          //wait for CPU_stall and Com_Bus_Gnt_proc to be made high
          check_ComBusReqproc_CPUStall_assert(sintf);

          check_ComBusGntproc_assert(sintf);

          check_BusRdX_assert(sintf);

          check_Address_Com_load(sintf);

          //Lower Memory or Other Cache Loads Data on the Bus
          sintf.Data_in_Bus_reg = 1;

          sintf.ClkBlk.Data_Bus_Com <= 32'hABACABAB;
           
          //Check if MESI State is properly assigned to block corresponding to the Address given
          check_MESI_fsm(sintf,MODIFIED);
          //Check if Data is correctly written into the cache
          check_CacheVar_Data(sintf,wrData,Address); 
          
          //check_DataBus_valid(sintf,wrData); 
          
          check_ComBusReqproc_CPUStall_deaassert(sintf);
          repeat(Max_Resp_Delay) @(posedge sintf.clk);
          $display("****** Test topWriteMiss Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
        end 
   endtask : testWriteMiss

endclass: topWriteMiss

//A simple directed test for scenarios 12,14,16 in section 4.8.1. This will verify write Miss Operation with no free block available. Tests until block is written back into the Cache.
class topWriteMissModifiedReplacement extends baseTestClass;
   //data to be written
   rand int wrData;
   constraint c_wrData  {wrData inside {[32'h00000000:32'hffffffff]};}
   reg [1:0]  lineToBeRepl;
   reg [15:0] TagToBeRepl;
   reg [14:0] IndexToBeRepl;
   reg [31:0] DataToBeWrittenBack;
   mesiStateType actualMesi;
   task testWriteMissReplaceModified(virtual interface globalInterface sintf);
        begin
         $display("\n****** Test topWriteMissModifiedReplacement Started ****** "); 
          sintf.ClkBlk.PrWr      <= 1; 
          sintf.ClkBlk.PrRd      <= 0;
          sintf.ClkBlk.Address   <= Address; 
          sintf.Data_Bus_reg  = wrData;

    $display("Processor Write Attempt is made for Address = %x with Data = %x",Address, wrData);
          // Check for behavior
      //Com_Bus_Req_proc_0 and CPU_stall must be made high
      check_ComBusReqproc_CPUStall_assert(sintf);

      //Since free block is not available, replacement of the modified block has to be carried out. Wait for bus access grant from arbiter
      wait(sintf.Com_Bus_Gnt_proc_0);
            
      //Wait till Address com bus is loaded with Address of the Block to be replaced
      lineToBeRepl    =  determine_LineToBeReplaced_LRU(sintf.LRU_var[Address[`INDEX_MSB:`INDEX_LSB]]);
      TagToBeRepl     =  sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_TAG_MSB:`CACHE_TAG_LSB];
      IndexToBeRepl   =  Address[`INDEX_MSB:`INDEX_LSB];
      $display("MESI State of the Block To Be Replaced is %x",sintf.Cache_proc_contr[{IndexToBeRepl,lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB]);
      DataToBeWrittenBack =  sintf.Cache_var[{Address[`INDEX_MSB:`INDEX_LSB],sintf.Blk_access_proc}][`CACHE_DATA_MSB:`CACHE_DATA_LSB];
      assert(lineToBeRepl == sintf.LRU_replacement_proc) $display("SUCCESS:: LRU Replacemet Proc = %x matches with Expected Line To Be Replaced = %x",sintf.LRU_replacement_proc,lineToBeRepl);
      else begin $display("BUG:: LRU Replacemet Proc = %x matches with Expected Line To Be Replaced = %x",sintf.LRU_replacement_proc,lineToBeRepl); 
        status = "FAILED";
      end
      
      $display("Line To Be Replaced = %x, Address of the Block to be replaced = %x, Data at that location = %x",lineToBeRepl,{TagToBeRepl,IndexToBeRepl,2'b00},DataToBeWrittenBack); 
     delay = 0;
     fork
        begin 
         while(delay <= Max_Resp_Delay) begin
           @(posedge sintf.clk);
           delay += 1; 
         end 
        end
        begin 
           wait(sintf.Address_Com[31:2] === {sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_TAG_MSB:`CACHE_TAG_LSB],Address[`INDEX_MSB:`INDEX_LSB]});
        end
      join_any
      disable fork;
      assert(sintf.Address_Com[31:0] === {sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_TAG_MSB:`CACHE_TAG_LSB],Address[`INDEX_MSB:`INDEX_LSB],2'b00} ) $display("SUCCESS::Address_Com is loaded with correct address of the block to be replaced");
      else begin $display("BUG:: Expected Address_Com = %x, Actual Address_Com = %x",{sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_TAG_MSB:`CACHE_TAG_LSB],Address[`INDEX_MSB:`INDEX_LSB],2'b00},sintf.Address_Com[31:0]);
       status = "FAILED";
      end
      //Wait till Mem_wr signal is made high
      delay = 0;
      fork
        begin 
         while(delay <= Max_Resp_Delay) begin
           @(posedge sintf.clk);
           delay += 1; 
         end 
        end
        begin 
           wait(sintf.Mem_wr);
        end
      join_any
      disable fork;
      assert(sintf.Mem_wr) $display("SUCCESS:: Mem_wr is made high");
      else begin $display("BUG:Mem_wr is not made high within timeout", $time);
         status = "FAILED";
      end


      //free block is now available. Cache will do free block operations for write miss.
     repeat(2) @(posedge sintf.clk);   
     sintf.Mem_write_done = 1;
     repeat(2) @(posedge sintf.clk);   
     sintf.Mem_write_done = 0;      
     wait(sintf.BusRdX);
     sintf.Mem_snoop_req = 1;
     wait(sintf.Mem_snoop_gnt);
     sintf.Mem_snoop_req = 0;
     @(posedge sintf.clk);
     sintf.ClkBlk.Data_Bus_Com <= 32'hdddddddd;
     sintf.Data_in_Bus_reg  = 1;
     repeat(4) @(posedge sintf.clk);
     actualMesi = sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB];
     if(Shared == 0) begin
         assert(sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB] == MODIFIED)
         else begin $display("BUG: Updated MESI State = %s Does not match with Expected state = EXCLUSIVE",actualMesi.name());
          status = "FAILED";
         end
     end
     else if (Shared == 1) begin
         assert(sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB] == MODIFIED)
         else begin $display("BUG: Updated MESI State = %x Does not match with Expected state = SHARED",sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],lineToBeRepl}][`CACHE_MESI_MSB:`CACHE_MESI_LSB]);
          status = "FAILED";
         end
     end
     $display("\n****** Test topWriteMissModifiedReplacement Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
    end 
   endtask : testWriteMissReplaceModified
endclass : topWriteMissModifiedReplacement


// A Simple Directed Testcase for Scenario 9 of Section 4.8.1 :Write Hit. Verified at the top level
class topWriteHit extends baseTestClass;
    //the second argument is the MESI state of the block that is hit. Use the following : 0 for shared state, 1 for exclusive state, 2 for modified state
    rand reg [31:0] wrData;
    mesiStateType MESI_state;
    task testSimpleWriteHit(virtual interface globalInterface sintf);
         $display("\n****** Test topWriteHit Started ****** "); 
                        //store the MESI State
                        MESI_state = mesiStateType'(sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],2'b00}][`CACHE_MESI_MSB:`CACHE_MESI_LSB]);
         $display("Current MESI State of the Block is %s",MESI_state.name());
			//Do a Write
			sintf.ClkBlk.Address <= Address;
			sintf.ClkBlk.PrRd    <= 0;
			sintf.ClkBlk.PrWr    <= 1;
			sintf.Data_Bus_reg    = wrData;
                        
            if(MESI_state == SHARED) begin
               check_Invalidate_assert(sintf);
            end
            			
                //Check if Data is written into the Cache
               check_CacheVar_Data(sintf,wrData,Address);
               //Check if MESI_state is properly updated
               if(MESI_state == SHARED)
                 check_MESI_fsm(sintf,MODIFIED);
               else if(MESI_state == MODIFIED)
                 check_MESI_fsm(sintf,MODIFIED);
               else if(MESI_state == EXCLUSIVE)
                 check_MESI_fsm(sintf, MODIFIED);
                 
		//Check if CPU_stall and Com_Bus_Req_proc_0 is deasserted
		check_ComBusReqproc_CPUStall_deaassert(sintf);
          $display("****** Test topWriteHit Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
      
       
    endtask : testSimpleWriteHit
   

endclass : topWriteHit

//Simple Directed test to verify scenario 20,21,22 in section 4.8.1 in which DUT Cache snoops a BusRd  while it contains
//the addressed block in shared/Modified/Exclusive state
class topBusRdSnoop extends baseTestClass;
    //use MESI_state as follows: 0 for Shared, 1 for Exclusive, 2 for Modified.
    mesiStateType MESI_state;
    reg[31:0] temp_data;
	task testBusRdSnoop(virtual interface globalInterface sintf);
	 begin
        $display("******Test topBusRdSnoop Started*********");
        $display("Bus Read  Attempt is made for Address = %x",Address);
         
	 //Other Cache raises Bus Rd signal
         sintf.Address_Com_reg = Address;
	 sintf.ClkBlk.PrRd      <= 0;
         sintf.ClkBlk.PrWr      <= 0;
         sintf.BusRd_reg = 1;
         
         
         repeat(2) @(posedge sintf.clk); 
	 //Check if DUT Cache Requests for Snoop Access
	 check_ComBusReqSnoop_assert(sintf);
	 //Calculate current MESI state of the Address Block requested.
         MESI_state = sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],sintf.Blk_access_snoop}][`CACHE_MESI_MSB: `CACHE_MESI_LSB];
         $display("MESI State of the Block to Be accessed = %x",MESI_state);
         temp_data  = sintf.Cache_var[{Address[`INDEX_MSB:`INDEX_LSB],sintf.Blk_access_snoop}][`CACHE_DATA_MSB: `CACHE_DATA_LSB];
	 //if data is already in bus, then check if Bus Snoop request is deasserted
	 if(sintf.Data_in_Bus) begin
	   check_ComBusReqSnoop_deassert(sintf);
	 end else begin
	       
	     //wait for grant
             //try by asserting gnt snoop ourselves :)
	     wait(sintf.Com_Bus_Gnt_snoop_0);
	 	//The Cache should raise mem operation abort
	 	check_MemOprnAbrt_assert(sintf);
	 	//block is in shared state
	 	if(MESI_state == SHARED) begin
	 	  //Check if shared signal is made high
	 	  check_Shared_assert(sintf);
	 	  //Check if Data bus com is loaded with data
	 	  check_DataBusCom_valid(sintf,temp_data);//change this
	 	  //Check if Data in Bus is made high
	 	  check_DataInBus_assert(sintf);
	 	  //Check if com bus req snoop is deasserted
	 	  check_ComBusReqSnoop_deassert(sintf);
	 	end
	 	else if(MESI_state == EXCLUSIVE) begin //in Exclusive state
                  //Check if shared signal is made high
	 	  check_Shared_assert(sintf);
	 	  //Check if Data bus com is loaded with data
	 	  check_DataBusCom_valid(sintf,temp_data);
	 	  //Check if Data in Bus is made high
	 	  check_DataInBus_assert(sintf);
	 	  //Check if com bus req snoop is deasserted
	 	  check_ComBusReqSnoop_deassert(sintf);
	 	end 
	 	else if(MESI_state == MODIFIED) begin //in Modified state
	 	  //Check if Data bus com is loaded with data
	 	  check_DataBusCom_valid(sintf,temp_data);
	 	  //Check if mem wr signal is asserted
	 	  check_MemWr_assert(sintf);
	 	  //Raise Mem Wr Done
	 	  sintf.Mem_write_done = 1;
	 	  //Check if shared signal is made high
	 	  check_Shared_assert(sintf);
	 	  //Check if Data in Bus made high
	 	  check_DataInBus_assert(sintf);
	 	  //Check if com bus req snoop is deasserted
	 	  check_ComBusReqSnoop_deassert(sintf);
	 	end					
	  end					
          $display("****** Test topBusRdSnoop Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
	 end
	endtask
endclass : topBusRdSnoop

//Simple Directed test to verify scenario 23,24,25 in section 4.8.1 in which DUT Cache snoops a BusRdX  while it contains
//the addressed block in shared/Modified/Exclusive state
class topBusRdXSnoop extends baseTestClass;
          
        mesiStateType MESI_state;
        reg[31:0] temp_data;
	task testBusRdXSnoop(virtual interface globalInterface sintf );
	 begin
        $display("\n******Test topBusRdXSnoop Started*********\n");
        $display("Bus ReadX  Attempt is made for Address = %x",Address);
	  //Other Cache raises Bus Rd signal
         sintf.Address_Com_reg = Address;
	 sintf.ClkBlk.PrRd      <= 0;
         sintf.ClkBlk.PrWr      <= 0;
         sintf.BusRd_reg = 1;
         
         
         repeat(2) @(posedge sintf.clk); 
	 //Check if DUT Cache Requests for Snoop Access
	 check_ComBusReqSnoop_assert(sintf);
	 //Calculate current MESI state of the Address Block requested.
         MESI_state = sintf.Cache_proc_contr[{Address[`INDEX_MSB:`INDEX_LSB],sintf.Blk_access_snoop}][`CACHE_MESI_MSB: `CACHE_MESI_LSB];
         $display("MESI State of the Block to Be accessed = %x",MESI_state);
         temp_data  = sintf.Cache_var[{Address[`INDEX_MSB:`INDEX_LSB],sintf.Blk_access_snoop}][`CACHE_DATA_MSB: `CACHE_DATA_LSB]; 
	  //if data is already in bus, then check if Bus Snoop request is deasserted
	  if(sintf.Data_in_Bus) begin
	  	check_ComBusReqSnoop_deassert(sintf);
	  end else begin
	        
	   //wait for grant
	   wait(sintf.Com_Bus_Gnt_snoop_0);
	   //The Cache should raise mem operation abort
	   check_MemOprnAbrt_assert(sintf);
	   //block is in shared state
	   if(MESI_state == 0) begin
	   	//Check if shared signal is made high
	   	check_Shared_assert(sintf);
	   	
	   end
	   else if(MESI_state == 1) begin //in Exclusive state
	   	//Nothing done at top level. Only internal states are changed.
	   	
	   end 
	   else if(MESI_state == 2) begin //in Modified state
	   	//Check if Common Bus Access is requested
	   	check_ComBusReqSnoop_assert(sintf);
	   	//wait for access grant
	   	wait(sintf.Com_Bus_Gnt_snoop_0);
	   	//check if data bus com has valid data
	   	check_DataBusCom_valid(sintf,32'bz);
	   	//check if mem wr is asserted
	   	check_MemWr_assert(sintf);
	   	//raise the memory write done
	   	sintf.Mem_write_done = 1;
	   	//check if com bus req snoop is deasserted
	   	check_ComBusReqSnoop_deassert(sintf);
	   	
	   end
	  		
	  end										
          $display("\n****** Test topBusRdXSnoop Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
	 end
	endtask
endclass : topBusRdXSnoop

class topSnoopInvalidate extends baseTestClass;
   //Task to send Invalidate signal to the DUT
   task testInvalidation(virtual globalInterface sintf);
   $display("\n****** TEST topSnoopInvalidate Started ******\n");
         sintf.Address_Com_reg = Address;
	 sintf.ClkBlk.PrRd     <= 0;
         sintf.ClkBlk.PrWr     <= 0;
         sintf.ClkBlk.Invalidate <= 1;    
   //Check if block with the Address is Invalidated 
   repeat(Max_Resp_Delay) @(posedge sintf.clk);
   delay = 0;
   fork
     wait(sintf.Cache_proc_contr[{sintf.Index_snoop,sintf.Blk_access_snoop}][`CACHE_MESI_MSB:`CACHE_MESI_LSB] == INVALID);
     begin
       repeat(Max_Resp_Delay) @(posedge sintf.clk);
     end
   join_any
   disable fork;
   assert(sintf.Cache_proc_contr[{sintf.Index_snoop,sintf.Blk_access_snoop}][`CACHE_MESI_MSB:`CACHE_MESI_LSB] == INVALID) $display("SUCCESS:Invalidation is done" );
   else begin $display("BUG:: Invalidation Not Done upon snooping Invalidate");
     status = "FAILED";
   end
    
    $display("\n****** Test topSnoopInvalidate Done Status = %s ******\n",!sintf.failed?status:"FAILED"); 
   endtask : testInvalidation
endclass

//Unit level Tests: Defined in 4.8.2.
//Unit Interface considered is cache_controller;


//Class to test MESI FSM functionality depending on the top level Processor Write/Read Request and current MESI State.
//Constrained Randomization is used to consider M/S/E MESI states as initial
//states. 
/*class unitMESIProc extends baseTestClass;
   
   rand mesiStateType current_mesi_state;
   rand mesiStateType next_mesi_state;
  
   constraint c_current_mesi_state {current_mesi_state inside
{MODIFIED,EXCLUSIVE,SHARED};} 
   
   rand bit PrRd;
   rand bit PrWr;
   //constrain this parameter: 2'b10 for Read, 2'b01 for Write
   constraint c_PrRd {PrRd inside {1,0};
                      PrWr == ~PrRd;}
    
   task testUnitMESIProc(virtual interface globalInterface cci );
     begin
        cci.ClkBlk.PrRd <= PrRd;
        cci.ClkBlk.PrWr <= PrWr;
        cci.ClkBlk.Address <= 32'hbabacafe;
        
        //set the Current_MESI_state_proc input
        cci.Current_MESI_state_proc = current_mesi_state;
        case(cci.ClkBlk.PrWr)
           1'b1: begin
                   cci.Data_Bus_reg = 32'habababab;
                   case(cci.Current_MESI_state_proc)
                       MODIFIED:  begin
                         check_MESI_fsm(cci,MODIFIED); 
                       end
                       EXCLUSIVE: begin
                         check_MESI_fsm(cci,MODIFIED); 
                       end
                       SHARED:    begin
                         check_MESI_fsm(cci,MODIFIED);
                         //check if invalidate signal is asserted
                         check_Invalidate_assert(cci); 
                       end
                   endcase
                 end
           1'b0: begin
                       check_MESI_fsm(cci,mesiStateType'(cci.Current_MESI_state_proc)); 
                 end
        endcase
        //store the next mesi state
        next_mesi_state = mesiStateType'(cci.Updated_MESI_state_proc);
        //sample for coverage
        `ifdef HAS_COVERAGE
          cg_PrRdWr_MESI_fsm_proc.sample();
        `endif
        
     end
    
   endtask : testUnitMESIProc
  `ifdef HAS_COVERAGE
   //Define covergroup to see what initial states are covered when Processor
   //Request is Read/Write
   covergroup cg_PrRdWr_MESI_fsm_proc;
      cover_item_cur_mesi_state : coverpoint current_mesi_state;
      cover_item_next_mesi_state : coverpoint next_mesi_state;
      cover_item_PrRd      : coverpoint PrRd;
      cover_item_PrWr      : coverpoint PrWr;
      cross_cover_item_MESI_PrRdWr : cross cover_item_PrRd, cover_item_PrWr, cover_item_cur_mesi_state;
      cross_cover_item_MESI_curXnext_state : cross cover_item_cur_mesi_state, cover_item_next_mesi_state;
   endgroup : cg_PrRdWr_MESI_fsm_proc

   function new();
      cg_PrRdWr_MESI_fsm_proc = new;
   endfunction: new 
  `endif
endclass: unitMESIProc

//Class to test MESI FSM functionality on the snoop side.
class unitMESISnoop extends baseTestClass;
      
   rand mesiStateType current_mesi_state;
  
   constraint c_current_mesi_state {current_mesi_state inside
{MODIFIED,EXCLUSIVE,SHARED};} 
   
   rand bit BusRd;
   rand bit BusRdX;
   //constrain this parameter: 2'b10 for Read, 2'b01 for Write
   constraint c_PrRd {BusRd inside {1,0};
                      BusRdX == ~BusRd;}
    
   task testUnitMESISnoop(virtual interface globalInterface cci );
     begin
        cci.BusRd_reg   = BusRd;
        cci.BusRdX_reg  = BusRdX;
        cci.ClkBlk.Address <= 32'hbabacafe;
        
        //set the Current_MESI_state_proc input
        cci.Current_MESI_state_snoop = current_mesi_state;
        case(cci.BusRdX_reg)
           1'b1: begin
                   case(cci.Current_MESI_state_snoop)
                       MODIFIED:  begin
                         check_MESI_fsm(cci,INVALID); 
                       end
                       EXCLUSIVE: begin
                         check_MESI_fsm(cci,MODIFIED); 
                       end
                       SHARED:    begin
                         check_MESI_fsm(cci,MODIFIED);
                         //check if invalidate signal is asserted
                         check_Invalidate_assert(cci); 
                       end
                   endcase
                 end
           1'b0: begin
                       check_MESI_fsm(cci,mesiStateType'(cci.Current_MESI_state_snoop)); 
                 end
        endcase
      `ifdef HAS_COVERAGE
        //sample for coverage
       cg_BusRdRdX_MESI_fsm_snoop.sample();
       `endif
        
     end
    
   endtask : testUnitMESISnoop
   `ifdef HAS_COVERAGE
      //Define covergroup to see what initial states are covered when other
      //caches Request is Bus Read/ReadX
      covergroup cg_BusRdRdX_MESI_fsm_snoop;
         cover_item_init_mesi_state      : coverpoint current_mesi_state;
         cover_item_BusRd                : coverpoint BusRd;
         cover_item_BusRdX               : coverpoint BusRdX;
         cross_cover_item_MESI_BusRdRdX  : cross cover_item_BusRd, cover_item_BusRdX, cover_item_init_mesi_state;
      endgroup : cg_BusRdRdX_MESI_fsm_snoop

   function new();
      cg_BusRdRdX_MESI_fsm_snoop = new;
   endfunction: new  
   `endif
 
endclass: unitMESISnoop


//Testcase to verify Pseudo LRU Block
class unitPlruBlkReplace extends baseTestClass;
  
  //define index field
  rand reg[`INDEX_SIZE - 1:0] set_index;
  constraint c_set_index {set_index inside {0,14'b11111111111111};}
  //define Tag of first block to be accessed
  rand reg[`TAG_SIZE - 1 : 0] first_access_tag;
  constraint c_first_access_tag {first_access_tag inside {0,16'hffff};}
   

  task testPlruReplace(virtual interface globalInterface gi);
       //set initial LRU Var expected. Make sure this is same as used in DUT
       //when the design is released.
       expected_lru_var = 3'b000;
       
       //fill out all 4 lines of a set
       for(int j = 0 ; j < 4 ; j++) begin
         gi.ClkBlk.PrRd <= 1;
         gi.ClkBlk.PrWr <= 0;
         //Read from a different address to fill out all lines in the set with
         //set_index index value
         gi.ClkBlk.Address <= {first_access_tag + j,set_index,2'b00};
         //check if CPU_stall is asserted
         wait(gi.CPU_stall);
         //wait until CPU_stall is de-asserted
         wait(!gi.CPU_stall);
         //determine the expected value of lru_var
         void'(determine_LRU_var_exp(j,expected_lru_var));
         //reset the DUT
         reset_DUT_inputs(gi);
       end
       
       //Access a block address that has same set_index as above but different
       //Tag
       gi.ClkBlk.PrRd <= 1;
       gi.ClkBlk.PrWr <= 0;
       gi.ClkBlk.Address <= {first_access_tag + 10,set_index,2'b00};
       //determine expected line to be replaced
       expected_line_to_replace = determine_LineToBeReplaced_LRU(expected_lru_var);
       //wait for Blk_accessed to go High
       wait(gi.Blk_accessed);
       //wait for LRU_replacement_proc is valid. Assuming it is set to z.
       wait(gi.LRU_replacement_proc != 2'bz);
       //check if the same line is being replaced by the dut
       assert(expected_line_to_replace == gi.LRU_replacement_proc)
       else $warning(1,"Wrong line is replaced by LRU block",$time);
     `ifdef HAS_COVERAGE
        //sample coverage if test succeeds
       cg_PlruReplace.sample();
     `endif
  endtask : testPlruReplace
  `ifdef HAS_COVERAGE 
  //define covergroup to collect data about what sets and lines are covered.
  covergroup cg_PlruReplace;
     cover_point_set_index        : coverpoint set_index;
     cover_point_first_access_tag : coverpoint first_access_tag;
     cover_point_index_x_tag      : cross cover_point_set_index, cover_point_first_access_tag;
  endgroup
  
  function new(); 
    cg_PlruReplace = new;
  endfunction
 `endif
  
endclass : unitPlruBlkReplace

//Macro level Tests
//Define test classes for lowest blocks for low level verification discussed in section 4.8.2
//For blocks inside Cache Controller

//Class to contain stimulus and task to check correctness of Address Segregator Block
class testAddrSeg;
	rand reg [`ADDRESSSIZE - 1 : 0] Address;
	constraint c_Address { Address inside {[32'h00000000 : 32'hffffffff]};}
	
	reg[`BLK_OFFSET_SIZE - 1 : 0] Expected_Blk_offset_proc;
	reg[`TAG_SIZE - 1 : 0]        Expected_Tag_proc;
	reg[`INDEX_SIZE - 1 : 0]      Expected_Index_proc;
        `ifdef HAS_COVERAGE	
	//define Cover group to collect the addresses covered
	covergroup cg_Address_testAddrSeg;
	  coverpoint_Address : coverpoint Address {
	  option.auto_bin_max = 8;    //divide the range of possible addresses into 8 bins
	  }
	endgroup
	
	function new();
		cg_Address_testAddrSeg = new;
	endfunction : new
        `endif
	
	task testAddr(virtual interface globalInterface asi);
          asi.ClkBlk.PrRd    <= 1; 
          asi.ClkBlk.PrWr    <= 0; 
	  asi.ClkBlk.Address <= this.Address;
	  Expected_Blk_offset_proc = this.Address[`BLK_OFFSET_SIZE - 1 : 0];
	  Expected_Tag_proc        = this.Address[`TAG_MSB : `TAG_LSB];
	  Expected_Index_proc      = this.Address[`INDEX_MSB : `INDEX_LSB];
	  @(posedge asi.clk); 
	  @(posedge asi.clk); 
	  //Check for mismatch
	  assert((asi.Blk_offset_proc == Expected_Blk_offset_proc) &&
	         (asi.Tag_proc        == Expected_Tag_proc)        &&
	         (asi.Index_proc      == Expected_Index_proc)) $display("TEST PASSED: Address Segregator Works Fine. testAddrSeg");
	  else $warning(1,"Address Segregator failure",$time);
	  
          `ifdef HAS_COVERAGE 
	  //sample the coverage
	  cg_Address_testAddrSeg.sample();
          `endif
	  return;   
	endtask : testAddr		
endclass : testAddrSeg
//Create class to test blk accessed blk
*/





