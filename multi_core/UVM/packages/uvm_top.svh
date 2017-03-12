import uvm_pkg::*;
`include "interfacesMultiCore.svh"
`include "uvm_macros.svh"

`define CORE_BITS 2	// bits to represent each core
`include "transaction.svh"
`include "sequence.svh"
`include "driver.svh"
`include "agent.svh"
`include "env.svh"
// tests
`include "base_test.svh"
`include "top_test.svh"
