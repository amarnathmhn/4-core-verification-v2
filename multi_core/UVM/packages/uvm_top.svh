import uvm_pkg::*;
`include "interfacesMultiCore.sv"
`include "uvm_macros.svh"

`define CORE_BITS 2	// bits to represent each core
`include "transaction.sv"
`include "sequence.sv"
`include "driver.sv"
`include "agent.sv"
`include "env.sv"
// tests
`include "base_test.sv"
`include "top_test.sv"
