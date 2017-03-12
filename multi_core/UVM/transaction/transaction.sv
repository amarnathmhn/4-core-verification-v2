typedef enum {READ, WRITE} CommandType;
typedef enum {ALL_ZEROS, SMALL, MEDIUM, LARGE, ALL_ONES} AddrType;
// Transaction to communicate with a single cache
class BaseCmd extends uvm_sequence_item;
	
	function new(string name = "BaseCmd");
		super.new(name);
	endfunction

endclass
class CpuCmd extends BaseCmd;

	rand CommandType cmdType; // READ and WRITE knob for command type
	rand AddrType    addrType; // knob for Address range
	rand int unsigned addr; // address of data requested
	rand int unsigned data; // data requested
	rand int unsigned  core; // core number 0 to 3
	rand int PrRd;
	rand int PrWr;

	// constrain the address and data to 32  bits
	constraint addr_data_range {

		(addrType == ALL_ZEROS) -> ( addr == 0 ); // all zeros
		(addrType == SMALL)     -> ( addr inside {[1: ( 1<< (`ADDRESSSIZE/4) ) -1 ]} ); 
		(addrType == MEDIUM)    -> ( addr inside {[( 1<< (`ADDRESSSIZE/4) ) : ( 1<< (`ADDRESSSIZE/2) ) -1 ]} );
		(addrType == LARGE)     -> ( addr inside {[( 1<< (`ADDRESSSIZE/2) ) : ( 1<< (`ADDRESSSIZE) ) - 2 ]} );
		(addrType == ALL_ONES)  -> ( addr == (1 << `ADDRESSSIZE ) - 1 );

		data inside {[0: (1 << `ADDRESSSIZE ) - 1  ]};	
	}
	constraint cmdType_to_pin
	{
		(cmdType == READ)  -> (PrRd == 1 && PrWr == 0);
		(cmdType == WRITE) -> (PrWr == 1 && PrRd == 0);
	}
	
	constraint core_nums
	{
		core inside {[0:3]};
	}
	
	// UVM automation macros for objects
	// Implements copy, print, and compare utility functions for these members.
	`uvm_object_utils_begin(CpuCmd)
		`uvm_field_enum(CommandType,cmdType,UVM_ALL_ON)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(core, UVM_ALL_ON)
		`uvm_field_int(PrRd, UVM_ALL_ON)
		`uvm_field_int(PrWr, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "CpuCmd");
		super.new(name);
	endfunction

	// try overriding constraints in derived classes

endclass:CpuCmd

