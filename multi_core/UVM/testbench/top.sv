// UVM - Testbench for 4-core-MESI Cache System Verification

`timescale 1ns/1ps

// import uvm class definitions


`include "uvm_macros.svh"
`include "uvm_pkg.sv"
import uvm_pkg::*;
// top design module
`include "cache_multi_config_1.v"

// uvm classes to verify the design module
`include "uvm_top.svh" // my uvm tb

module top;



	initial begin
		$display("Hello World.. starting test Now!");
		run_test("BaseTest");
	end
endmodule
