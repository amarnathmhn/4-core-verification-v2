`include "cache_wrapper_0.v"
`include "cache_wrapper_1.v"
`include "cache_wrapper_2.v"
`include "cache_wrapper_3.v"


module cache_multi_config_1 (	clk,
								PrWr_0,
								PrRd_0,
								Address           [0],
								Data_Bus_0        ,
								CPU_stall         [0],
								Com_Bus_Req_proc  [0],
								Com_Bus_Gnt_proc  [0],
								Com_Bus_Req_snoop [0],
								Com_Bus_Gnt_snoop [0],
								PrWr_1,
								PrRd_1,
								Address           [1],
								Data_Bus_1,
								CPU_stall         [1],
								Com_Bus_Req_proc  [1],
								Com_Bus_Gnt_proc  [1],
								Com_Bus_Req_snoop [1],
								Com_Bus_Gnt_snoop [1],
								PrWr_2,
								PrRd_2,
								Address           [2],
								Data_Bus_2         ,
								CPU_stall         [2],
								Com_Bus_Req_proc  [2],
								Com_Bus_Gnt_proc  [2],
								Com_Bus_Req_snoop [2],
								Com_Bus_Gnt_snoop [2],
								PrWr_3,
								PrRd_3,
								Address           [3],
								Data_Bus_3         ,
								CPU_stall         [3],
								Com_Bus_Req_proc  [3],
								Com_Bus_Gnt_proc  [3],
								Com_Bus_Req_snoop [3],
								Com_Bus_Gnt_snoop [3],
								Address_Com,
								Data_Bus_Com,
								Data_in_Bus,
								Mem_wr,
								Mem_oprn_abort,
								Mem_write_done,
								PrWr_4,
								PrRd_4,
								Address           [4],
								Data_Bus_4         ,
								CPU_stall         [4],
								Com_Bus_Req_proc  [4],
								Com_Bus_Gnt_proc  [4],
								
								PrWr_5,
								PrRd_5,
								Address           [5],
								Data_Bus_5         ,
								CPU_stall         [5],
								Com_Bus_Req_proc  [5],
								Com_Bus_Gnt_proc  [5],
								
								PrWr_6,
								PrRd_6,
								Address           [6],
								Data_Bus_6        ,
								CPU_stall         [6],
								Com_Bus_Req_proc  [6],
								Com_Bus_Gnt_proc  [6],
								
								PrWr_7,
								PrRd_7,
								Address           [7],
								Data_Bus_7,
								CPU_stall         [7],
								Com_Bus_Req_proc  [7],
								Com_Bus_Gnt_proc  [7]);



input 							clk;
input								         PrWr_0              ;
input								         PrWr_1              ;
input								         PrWr_2              ;
input								         PrWr_3              ;
input								         PrWr_4              ;
input								         PrWr_5              ;
input								         PrWr_6              ;
input								         PrWr_7              ;
input								         PrRd_0              ;
input								         PrRd_1              ;
input								         PrRd_2              ;
input								         PrRd_3              ;
input								         PrRd_4              ;
input								         PrRd_5              ;
input								         PrRd_6              ;
input								         PrRd_7              ;
input 	[`ADDRESSSIZE-1 : 0] 		Address           [7 : 0];
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_0          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_1          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_2          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_3          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_4          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_5          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_6          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_7          ;
output								      CPU_stall         [7 : 0];
output								      Com_Bus_Req_proc  [7 : 0];

input								         Com_Bus_Gnt_proc  [7 : 0];
output								      Com_Bus_Req_snoop [3 : 0];
input								         Com_Bus_Gnt_snoop [3 : 0];

inout 	[`ADDRESSSIZE-1 : 0] 		Address_Com;
inout 	[`ADDRESSSIZE-1 : 0] 		Data_Bus_Com;
input                               Data_in_Bus;
output                              Mem_wr;
output                              Mem_oprn_abort;
input                               Mem_write_done;

wire 	[`ADDRESSSIZE-1 : 0] 		Address_Com;
wire 	[`ADDRESSSIZE-1 : 0] 		Data_Bus_Com;
wire                               BusRd;
wire                               BusRdX;
wire                               Invalidate;
tri                               Data_in_Bus;
wire                              Mem_wr;
wire                              Mem_oprn_abort;
wire                               Mem_write_done;

wire                                Shared_local [3 : 0];

// Needs logic to drive signal
wire								         All_Invalidation_done;

wire                              Invalidation_done [3 : 0];

assign      Shared = Shared_local[0] | Shared_local[1] | Shared_local[2] | Shared_local[3];

// A work around assumed that when one invalidation is done then all copies are invalidated
assign All_Invalidation_done = Invalidation_done[0] & Invalidation_done[1] & Invalidation_done[2] & Invalidation_done[3];

//assign      All_Invalidation_done = ((!Shared_local[0] & !Invalidation_done[0]) | Invalidation_done[0]) & ((!Shared_local[1] & !Invalidation_done[1]) |   Invalidation_done[1]) & ((!Shared_local[2] & !Invalidation_done[2]) |   Invalidation_done[2]) & ((!Shared_local[3] & !Invalidation_done[3]) |   Invalidation_done[3]);

cache_wrapper_0     P1_DL (	clk,
                              PrWr_0,
                              PrRd_0,
                              Address[0],
                              Data_Bus_0,
                              CPU_stall[0],
                              Com_Bus_Req_proc[0],
                              Com_Bus_Gnt_proc[0],
                              Com_Bus_Req_snoop[0],
                              Com_Bus_Gnt_snoop[0],
                              Address_Com,
                              Data_Bus_Com,
                              BusRd,
                              BusRdX,
                              Invalidate,
                              Data_in_Bus,
                              Mem_wr,
                              Mem_oprn_abort,
                              Mem_write_done,
                              Invalidation_done[0],
                              All_Invalidation_done,
                              Shared_local[0],
                              Shared
);
cache_wrapper_I_0   P1_IL (	clk,
                              PrRd_4,
                              Address[4],
                              Data_Bus_4,
                              CPU_stall[4],
                              Com_Bus_Req_proc[4],
                              Com_Bus_Gnt_proc[4],
                              Address_Com,
                              Data_Bus_Com,
                              Data_in_Bus
                           );

cache_wrapper_1     P2_DL (   clk,
                              PrWr_1,
                              PrRd_1,
                              Address[1],
                              Data_Bus_1,
                              CPU_stall[1],
                              Com_Bus_Req_proc[1],
                              Com_Bus_Gnt_proc[1],
                              Com_Bus_Req_snoop[1],
                              Com_Bus_Gnt_snoop[1],
                              Address_Com,
                              Data_Bus_Com,
                              BusRd,
                              BusRdX,
                              Invalidate,
                              Data_in_Bus,
                              Mem_wr,
                              Mem_oprn_abort,
                              Mem_write_done,
                              Invalidation_done[1],
                              All_Invalidation_done,
                              Shared_local[1],
                              Shared
);
cache_wrapper_I_1   P2_IL (clk,
                              PrRd_5,
                              Address[5],
                              Data_Bus_5,
                              CPU_stall[5],
                              Com_Bus_Req_proc[5],
                              Com_Bus_Gnt_proc[5],
                              Address_Com,
                              Data_Bus_Com,
                              Data_in_Bus
                           );

cache_wrapper_2     P3_DL (   clk,
                              PrWr_2,
                              PrRd_2,
                              Address[2],
                              Data_Bus_2,
                              CPU_stall[2],
                              Com_Bus_Req_proc[2],
                              Com_Bus_Gnt_proc[2],
                              Com_Bus_Req_snoop[2],
                              Com_Bus_Gnt_snoop[2],
                              Address_Com,
                              Data_Bus_Com,
                              BusRd,
                              BusRdX,
                              Invalidate,
                              Data_in_Bus,
                              Mem_wr,
                              Mem_oprn_abort,
                              Mem_write_done,
                              Invalidation_done[2],
                              All_Invalidation_done,
                              Shared_local[2],
                              Shared
);
cache_wrapper_I_2   P3_IL (   clk,
                              PrRd_7,
                              Address[7],
                              Data_Bus_7,
                              CPU_stall[7],
                              Com_Bus_Req_proc[7],
                              Com_Bus_Gnt_proc[7],
                              Address_Com,
                              Data_Bus_Com,
                              Data_in_Bus
                           );

cache_wrapper_3     P4_DL (   clk,
                              PrWr_3,
                              PrRd_3,
                              Address[3],
                              Data_Bus_3,
                              CPU_stall[3],
                              Com_Bus_Req_proc[3],
                              Com_Bus_Gnt_proc[3],
                              Com_Bus_Req_snoop[3],
                              Com_Bus_Gnt_snoop[3],
                              Address_Com,
                              Data_Bus_Com,
                              BusRd,
                              BusRdX,
                              Invalidate,
                              Data_in_Bus,
                              Mem_wr,
                              Mem_oprn_abort,
                              Mem_write_done,
                              Invalidation_done[3],
                              All_Invalidation_done,
                              Shared_local[3],
                              Shared
);
cache_wrapper_I_3   P4_IL (   clk,
                              PrRd_6,
                              Address[6],
                              Data_Bus_6,
                              CPU_stall[6],
                              Com_Bus_Req_proc[6],
                              Com_Bus_Gnt_proc[6],
                              Address_Com,
                              Data_Bus_Com,
                              Data_in_Bus
                           );

endmodule
