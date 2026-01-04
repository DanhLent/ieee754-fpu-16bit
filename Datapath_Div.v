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
// CREATED		"Thu Dec 25 12:25:25 2025"

module Datapath_Div(
	CLK,
	Reset,
	Sel_A,
	Shift_Enable,
	Load,
	Update_A,
	Ain,
	Bin,
	A_lt_M,
	OUT,
	qRemainder
);


input wire	CLK;
input wire	Reset;
input wire	Sel_A;
input wire	Shift_Enable;
input wire	Load;
input wire	Update_A;
input wire	[21:0] Ain;
input wire	[10:0] Bin;
output wire	A_lt_M;
output wire	[21:0] OUT;
output wire	[11:0] qRemainder;

wire	A_ge_M;
wire	Bin11;
wire	[21:0] Q;
wire	[11:0] R;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[11:0] SYNTHESIZED_WIRE_2;
wire	[11:0] SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	[21:0] SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	[11:0] SYNTHESIZED_WIRE_9;

assign	SYNTHESIZED_WIRE_5 = 0;
wire	[11:0] GDFX_TEMP_SIGNAL_0;
wire	[21:0] GDFX_TEMP_SIGNAL_1;
wire	[11:0] GDFX_TEMP_SIGNAL_2;


assign	GDFX_TEMP_SIGNAL_0 = {R[10:0],Q[21]};
assign	GDFX_TEMP_SIGNAL_1 = {Q[21:1],A_ge_M};
assign	GDFX_TEMP_SIGNAL_2 = {Bin11,Bin[10],Bin[9],Bin[8],Bin[7],Bin[6],Bin[5],Bin[4],Bin[3],Bin[2],Bin[1],Bin[0]};

assign	A_lt_M =  ~A_ge_M;


assign	SYNTHESIZED_WIRE_7 = Shift_Enable | SYNTHESIZED_WIRE_0;

assign	SYNTHESIZED_WIRE_4 = Load | Update_A;


mux2_1_12bit	b2v_inst34(
	.S(SYNTHESIZED_WIRE_1),
	.D0(GDFX_TEMP_SIGNAL_0),
	.D1(SYNTHESIZED_WIRE_2),
	.Y(SYNTHESIZED_WIRE_9));

assign	SYNTHESIZED_WIRE_0 = A_ge_M & Update_A;



Sub_12bit	b2v_inst5(
	.A(R),
	.B(SYNTHESIZED_WIRE_3),
	.Cout(A_ge_M),
	.S(SYNTHESIZED_WIRE_2));

assign	SYNTHESIZED_WIRE_1 = A_ge_M & Sel_A;


mux2_1_22bit	b2v_inst8(
	.S(Update_A),
	.D0(Ain),
	.D1(GDFX_TEMP_SIGNAL_1),
	.Y(SYNTHESIZED_WIRE_6));

assign	SYNTHESIZED_WIRE_8 = Load | Reset;


Register_12bit	b2v_M(
	.CLK(CLK),
	.Enable(Load),
	.Reset(Reset),
	.In(GDFX_TEMP_SIGNAL_2),
	.Q(SYNTHESIZED_WIRE_3));


ShiftLeftReg_22bit_Shiftin	b2v_Quotient(
	.CLK(CLK),
	.Enable(Shift_Enable),
	.Load(SYNTHESIZED_WIRE_4),
	.Shift_In(SYNTHESIZED_WIRE_5),
	.Reset(Reset),
	.In(SYNTHESIZED_WIRE_6),
	.Q(Q));


Register_12bit	b2v_Remainder(
	.CLK(CLK),
	.Enable(SYNTHESIZED_WIRE_7),
	.Reset(SYNTHESIZED_WIRE_8),
	.In(SYNTHESIZED_WIRE_9),
	.Q(R));

assign	OUT = Q;
assign	qRemainder = R;
assign	Bin11 = 0;

endmodule
