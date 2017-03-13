import uvm_pkg::*;
`include "interfacesMultiCore.sv"
`include "uvm_macros.svh"

`define CORE_BITS 2	// bits to represent each core
`include "base_cmd.sv"
`include "cpu_cmd.sv"
`include "main_mem_cmd.sv"
`include "sequencer.sv"
`include "cpu_sequence.sv"
`include "main_mem_sequence.sv"
`include "wrapper_unit_sequence.sv"
`include "base_driver.sv"
`include "cache_driver.sv"
`include "main_mem_driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "env.sv"
// tests
`include "base_test.sv"
`include "top_test.sv"
`include "wrapper_serial_command_test.sv"
