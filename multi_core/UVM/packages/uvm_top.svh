import uvm_pkg::*;
`include "interfacesMultiCore.sv"
`include "uvm_macros.svh"

typedef enum bit[1:0] {INVALID, SHARED, EXCLUSIVE, MODIFIED} mesiStateType;

`define CORE_BITS 2	// bits to represent each core
// Transactions
`include "base_cmd.sv"
`include "cpu_cmd.sv"
`include "main_mem_cmd.sv"
`include "cache_mem_access_cmd.sv"

// Sequencers
`include "sequencer.sv"

// Sequences
`include "cpu_sequence.sv"
`include "main_mem_sequence.sv"
`include "wrapper_unit_sequence.sv"
`include "cache_mem_write_sequence.sv"

// Drivers
`include "base_driver.sv"
`include "cache_driver.sv"
`include "main_mem_driver.sv"
`include "cache_direct_mem_driver.sv"


`include "monitor.sv"
`include "agent.sv"
`include "env.sv"

// Tests
`include "base_test.sv"
`include "top_test.sv"
`include "wrapper_serial_command_test.sv"
`include "top_read_hit.sv"
