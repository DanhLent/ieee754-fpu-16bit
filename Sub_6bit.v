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
// CREATED		"Tue Dec 30 01:08:27 2025"

module Sub_6bit(
	A,
	B,
	Cout,
	S
);


input wire	[5:0] A;
input wire	[5:0] B;
output wire	Cout;
output wire	[5:0] S;

wire	[5:0] S_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_0;
wire	[3:0] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;

assign	SYNTHESIZED_WIRE_0 = 1;




Adder_4bit	b2v_inst(
	.Cin(SYNTHESIZED_WIRE_0),
	.A(A[3:0]),
	.B(SYNTHESIZED_WIRE_1),
	.Cout(SYNTHESIZED_WIRE_3),
	.S(S_ALTERA_SYNTHESIZED[3:0]));

assign	SYNTHESIZED_WIRE_2 =  ~B[4];

assign	SYNTHESIZED_WIRE_1 =  ~B[3:0];


Adder_1bit	b2v_inst3(
	.A(A[4]),
	.B(SYNTHESIZED_WIRE_2),
	.Cin(SYNTHESIZED_WIRE_3),
	.Sum(S_ALTERA_SYNTHESIZED[4]),
	.Cout(SYNTHESIZED_WIRE_5));


Adder_1bit	b2v_inst4(
	.A(A[5]),
	.B(SYNTHESIZED_WIRE_4),
	.Cin(SYNTHESIZED_WIRE_5),
	.Sum(S_ALTERA_SYNTHESIZED[5]),
	.Cout(Cout));


assign	SYNTHESIZED_WIRE_4 =  ~B[5];

assign	S = S_ALTERA_SYNTHESIZED;

endmodule
