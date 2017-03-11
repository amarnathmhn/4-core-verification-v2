
// Transaction to communicate with a single cache
class TopCmd extends uvm_sequence_item;

	rand CommandType cmdType; // READ and WRITE
	rand reg[`ADDRESSSIZE-1:0] addr; // address of data requested
	rand reg[`ADDRESSSIZE-1:0] data; // data requested
	rand reg[`CORE_BITS-1:0]   core; // core number 0 to 3
	bit PrRd;
	bit PrWr;

	constraint cmdType_to_pin
	{
		(cmdType == READ)  -> (PrRd == 1);
		(cmdType == WRITE) -> (PrWr == 1);
	}
	
	constraint core_nums
	{
		core inside {[0:3]};
	}
	
endclass:TopCmd