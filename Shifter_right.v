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
// CREATED		"Thu Dec 25 00:15:00 2025"

module Shifter_right(
	In,
	S,
	OUT
);


input wire	[10:0] In;
input wire	[3:0] S;
output wire	[15:0] OUT;

wire	GND;
wire	[15:0] Net1;
wire	[15:0] Net2;
wire	[15:0] Net3;

wire	[15:0] GDFX_TEMP_SIGNAL_4;
wire	[15:0] GDFX_TEMP_SIGNAL_3;
wire	[15:0] GDFX_TEMP_SIGNAL_2;
wire	[15:0] GDFX_TEMP_SIGNAL_1;
wire	[15:0] GDFX_TEMP_SIGNAL_0;


assign	GDFX_TEMP_SIGNAL_4 = {GND,GND,GND,GND,GND,GND,GND,GND,Net3[15:8]};
assign	GDFX_TEMP_SIGNAL_3 = {GND,GND,GND,GND,Net2[15:4]};
assign	GDFX_TEMP_SIGNAL_2 = {GND,GND,Net1[15:2]};
assign	GDFX_TEMP_SIGNAL_1 = {GND,In[10:0],GND,GND,GND,GND};
assign	GDFX_TEMP_SIGNAL_0 = {In[10:0],GND,GND,GND,GND,GND};


mux2_1_16bit	b2v_inst(
	.S(S[0]),
	.D0(GDFX_TEMP_SIGNAL_0),
	.D1(GDFX_TEMP_SIGNAL_1),
	.Y(Net1));


mux2_1_16bit	b2v_inst1(
	.S(S[1]),
	.D0(Net1),
	.D1(GDFX_TEMP_SIGNAL_2),
	.Y(Net2));


mux2_1_16bit	b2v_inst2(
	.S(S[2]),
	.D0(Net2),
	.D1(GDFX_TEMP_SIGNAL_3),
	.Y(Net3));


mux2_1_16bit	b2v_inst3(
	.S(S[3]),
	.D0(Net3),
	.D1(GDFX_TEMP_SIGNAL_4),
	.Y(OUT));


assign	GND = 0;

endmodule
