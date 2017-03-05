`include "cache_def_0.v"
`include "cache_def_I_0.v"
`include "cache_wrapper_0.v"
`include "cache_wrapper_1.v"
`include "cache_wrapper_2.v"
`include "cache_wrapper_3.v"

`include "cache_wrapper_I_0.v"
`include "cache_wrapper_I_1.v"
`include "cache_wrapper_I_2.v"
`include "cache_wrapper_I_3.v"

module cache_multi_config_1 (	clk,
								PrWr_0,
								PrRd_0,
								Address_0,
								Data_Bus_0        ,
								CPU_stall_0,
								Com_Bus_Req_proc_0,
								Com_Bus_Gnt_proc_0,
								Com_Bus_Req_snoop_0,
								Com_Bus_Gnt_snoop_0,
								PrWr_1,
								PrRd_1,
								Address_1,
								Data_Bus_1,
								CPU_stall_1,
								Com_Bus_Req_proc_1,
								Com_Bus_Gnt_proc_1,
								Com_Bus_Req_snoop_1,
								Com_Bus_Gnt_snoop_1,
								PrWr_2,
								PrRd_2,
								Address_2,
								Data_Bus_2         ,
								CPU_stall_2,
								Com_Bus_Req_proc_2,
								Com_Bus_Gnt_proc_2,
								Com_Bus_Req_snoop_2,
								Com_Bus_Gnt_snoop_2,
								PrWr_3,
								PrRd_3,
								Address_3,
								Data_Bus_3         ,
								CPU_stall_3,
								Com_Bus_Req_proc_3,
								Com_Bus_Gnt_proc_3,
								Com_Bus_Req_snoop_3,
								Com_Bus_Gnt_snoop_3,
								Address_Com,
								Data_Bus_Com,
								Data_in_Bus,
								Mem_wr,
								Mem_oprn_abort,
								Mem_write_done,
								PrWr_4,
								PrRd_4,
								Address_4,
								Data_Bus_4         ,
								CPU_stall_4,
								Com_Bus_Req_proc_4,
								Com_Bus_Gnt_proc_4,						
								PrWr_5,
								PrRd_5,
								Address_5,
								Data_Bus_5         ,
								CPU_stall_5,
								Com_Bus_Req_proc_5,
								Com_Bus_Gnt_proc_5,
								
								PrWr_6,
								PrRd_6,
								Address_6,
								Data_Bus_6        ,
								CPU_stall_6,
								Com_Bus_Req_proc_6,
								Com_Bus_Gnt_proc_6,
								
								PrWr_7,
								PrRd_7,
								Address_7,
								Data_Bus_7,
								CPU_stall_7,
								Com_Bus_Req_proc_7,
								Com_Bus_Gnt_proc_7);



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

input 	[`ADDRESSSIZE-1 : 0] 		Address_0;
input 	[`ADDRESSSIZE-1 : 0] 		Address_1;
input 	[`ADDRESSSIZE-1 : 0] 		Address_2;
input 	[`ADDRESSSIZE-1 : 0] 		Address_3;
input 	[`ADDRESSSIZE-1 : 0] 		Address_4;
input 	[`ADDRESSSIZE-1 : 0] 		Address_5;
input 	[`ADDRESSSIZE-1 : 0] 		Address_6;
input 	[`ADDRESSSIZE-1 : 0] 		Address_7;

inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_0          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_1          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_2          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_3          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_4          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_5          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_6          ;
inout  	[`ADDRESSSIZE-1 : 0] 		Data_Bus_7          ;

output								      CPU_stall_0         ;
output								      CPU_stall_1         ;
output								      CPU_stall_2         ;
output								      CPU_stall_3         ;
output								      CPU_stall_4         ;
output								      CPU_stall_5         ;
output								      CPU_stall_6         ;
output								      CPU_stall_7         ;

output								     Com_Bus_Req_proc_0         ;
output								     Com_Bus_Req_proc_1         ;
output								     Com_Bus_Req_proc_2         ;
output								     Com_Bus_Req_proc_3         ;
output								     Com_Bus_Req_proc_4         ;
output								     Com_Bus_Req_proc_5         ;
output								     Com_Bus_Req_proc_6         ;
output								     Com_Bus_Req_proc_7         ;
//output								      Com_Bus_Req_proc  [7 : 0];

//input								         Com_Bus_Gnt_proc  [7 : 0];
input								     Com_Bus_Gnt_proc_0         ;
input								     Com_Bus_Gnt_proc_1         ;
input								     Com_Bus_Gnt_proc_2         ;
input								     Com_Bus_Gnt_proc_3         ;
input								     Com_Bus_Gnt_proc_4         ;
input								     Com_Bus_Gnt_proc_5         ;
input								     Com_Bus_Gnt_proc_6         ;
input								     Com_Bus_Gnt_proc_7         ;


input								     Com_Bus_Req_snoop_0;
input								     Com_Bus_Req_snoop_1;
input								     Com_Bus_Req_snoop_2;
input								     Com_Bus_Req_snoop_3;


input								     Com_Bus_Gnt_snoop_0;
input								     Com_Bus_Gnt_snoop_1;
input								     Com_Bus_Gnt_snoop_2;
input								     Com_Bus_Gnt_snoop_3;


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

//assign      All_Invalidation_done = ((!Shared_local[0] & !Invalidation_done[0]) | Invalidation_done[0]) & ((!Shared_local_1 & !Invalidation_done_1) |   Invalidation_done_1) & ((!Shared_local_2 & !Invalidation_done_2) |   Invalidation_done_2) & ((!Shared_local[3] & !Invalidation_done[3]) |   Invalidation_done[3]);

cache_wrapper_0     P1_DL (	clk,
                              PrWr_0,
                              PrRd_0,
                              Address_0,
                              Data_Bus_0,
                              CPU_stall_0,
                              Com_Bus_Req_proc_0,
                              Com_Bus_Gnt_proc_0,
                              Com_Bus_Req_snoop_0,
                              Com_Bus_Gnt_snoop_0,
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
                              Address_4,
                              Data_Bus_4,
                              CPU_stall_4,
                              Com_Bus_Req_proc_4,
                              Com_Bus_Gnt_proc_4,
                              Address_Com,
                              Data_Bus_Com,
                              Data_in_Bus
                           );

cache_wrapper_1     P2_DL (   clk,
                              PrWr_1,
                              PrRd_1,
                              Address_1,
                              Data_Bus_1,
                              CPU_stall_1,
                              Com_Bus_Req_proc_1,
                              Com_Bus_Gnt_proc_1,
                              Com_Bus_Req_snoop_1,
                              Com_Bus_Gnt_snoop_1,
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
                              Address_5,
                              Data_Bus_5,
                              CPU_stall_5,
                              Com_Bus_Req_proc_5,
                              Com_Bus_Gnt_proc_5,
                              Address_Com,
                              Data_Bus_Com,
                              Data_in_Bus
                           );

cache_wrapper_2     P3_DL (   clk,
                              PrWr_2,
                              PrRd_2,
                              Address_2,
                              Data_Bus_2,
                              CPU_stall_2,
                              Com_Bus_Req_proc_2,
                              Com_Bus_Gnt_proc_2,
                              Com_Bus_Req_snoop_2,
                              Com_Bus_Gnt_snoop_2,
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
                              Address_7,
                              Data_Bus_7,
                              CPU_stall_7,
                              Com_Bus_Req_proc_7,
                              Com_Bus_Gnt_proc_7,
                              Address_Com,
                              Data_Bus_Com,
                              Data_in_Bus
                           );

cache_wrapper_3     P4_DL (   clk,
                              PrWr_3,
                              PrRd_3,
                              Address_3,
                              Data_Bus_3,
                              CPU_stall_3,
                              Com_Bus_Req_proc_3,
                              Com_Bus_Gnt_proc_3,
                              Com_Bus_Req_snoop_3,
                              Com_Bus_Gnt_snoop_3,
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
                              Address_6,
                              Data_Bus_6,
                              CPU_stall_6,
                              Com_Bus_Req_proc_6,
                              Com_Bus_Gnt_proc_6,
                              Address_Com,
                              Data_Bus_Com,
                              Data_in_Bus
                           );

endmodule
