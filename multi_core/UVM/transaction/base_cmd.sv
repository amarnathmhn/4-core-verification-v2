typedef enum {READ, WRITE} CommandType;
typedef enum {ALL_ZEROS, SMALL, MEDIUM, LARGE, ALL_ONES} AddrType;
// Transaction to communicate with a single cache
class BaseCmd extends uvm_sequence_item;
	
	function new(string name = "BaseCmd");
		super.new(name);
	endfunction

endclass:BaseCmd
