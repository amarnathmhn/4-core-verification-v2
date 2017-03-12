import uvm_pkg::*;
`include "interfacesMultiCore.svh"
`include "uvm_macros.svh"
typedef enum bit {READ=1'b0, WRITE=1'b1} CommandType;
`define CORE_BITS 2	// bits to represent each core
`include "sequence.svh"
`include "helloworld.svh"
