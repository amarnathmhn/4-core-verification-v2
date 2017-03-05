module block(input PrWr,input PrRd, input [4:0] Addr, inout [7:0] data);
 reg [7:0] cache_data[32];
 reg [7:0] data_reg;
 assign data = PrRd ? data_reg : 8'bz;
 always @(PrRd || PrWr) begin
   if PrRd begin
      data = cache_data[Addr];
   end
   else if PrWr begin
      cache_data[Addr] = data;
   end
 end
endmodule

interface block_if();
 logic [7:0] cache_data[31:0];
endinterface

module top();
  block b();
  block_if bif();
  virtual interface local_if;
  
  
  initial begin
    
  end
  
  
endmodule
