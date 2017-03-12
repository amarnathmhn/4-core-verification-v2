
class dut_driver extends uvm_driver #(TopCmd);

	TopCmd topCmd; // reference to basic transaction modeling the cpu command
	virtual globalInterface gintf;
endclass:dut_driver