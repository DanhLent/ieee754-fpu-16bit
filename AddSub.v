// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
// CREATED		"Sun Dec 28 14:56:12 2025"

module AddSub(
	Select,
	Ain,
	Bin,
	Cout,
	OUT
);


input wire	Select;
input wire	[14:0] Ain;
input wire	[14:0] Bin;
output wire	Cout;
output wire	[14:0] OUT;

wire	[14:0] B;





Adder_15bit	b2v_inst(
	.Cin(Select),
	.A(Ain),
	.B(B),
	.Cout(Cout),
	.S(OUT));

assign	B[14] = Bin[14] ^ Select;

assign	B[13] = Bin[13] ^ Select;

assign	B[12] = Bin[12] ^ Select;

assign	B[11] = Bin[11] ^ Select;

assign	B[10] = Bin[10] ^ Select;

assign	B[9] = Bin[9] ^ Select;

assign	B[8] = Bin[8] ^ Select;

assign	B[7] = Bin[7] ^ Select;

assign	B[6] = Bin[6] ^ Select;

assign	B[5] = Bin[5] ^ Select;

assign	B[4] = Bin[4] ^ Select;

assign	B[3] = Bin[3] ^ Select;

assign	B[2] = Bin[2] ^ Select;

assign	B[1] = Bin[1] ^ Select;

assign	B[0] = Bin[0] ^ Select;


endmodule
