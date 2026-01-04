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
// CREATED		"Tue Dec 30 05:03:32 2025"

module Compare_5bit(
	Ain,
	Bin,
	A_gt_B,
	Diff
);


input wire	[4:0] Ain;
input wire	[4:0] Bin;
output wire	A_gt_B;
output wire	[4:0] Diff;

wire	[4:0] A;
wire	Ain5;
wire	Bin5;
wire	[5:0] S;
wire	[0:4] SYNTHESIZED_WIRE_0;

assign	SYNTHESIZED_WIRE_0 = 0;
wire	[5:0] GDFX_TEMP_SIGNAL_1;
wire	[5:0] GDFX_TEMP_SIGNAL_0;


assign	GDFX_TEMP_SIGNAL_1 = {Bin5,Bin[4],Bin[3],Bin[2],Bin[1],Bin[0]};
assign	GDFX_TEMP_SIGNAL_0 = {Ain5,Ain[4],Ain[3],Ain[2],Ain[1],Ain[0]};



Sub_6bit	b2v_inst1(
	.A(GDFX_TEMP_SIGNAL_0),
	.B(GDFX_TEMP_SIGNAL_1),
	
	.S(S));

assign	A_gt_B =  ~S[5];

assign	A[4] = S[4] ^ S[5];

assign	A[3] = S[3] ^ S[5];

assign	A[2] = S[2] ^ S[5];

assign	A[1] = S[1] ^ S[5];

assign	A[0] = S[0] ^ S[5];


Adder_5bit	b2v_inst8(
	.Cin(S[5]),
	.A(A),
	.B(SYNTHESIZED_WIRE_0),
	
	.S(Diff));



assign	Ain5 = 0;
assign	Bin5 = 0;

endmodule
