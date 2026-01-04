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
// CREATED		"Sun Dec  7 20:48:51 2025"

module Datapath_Mul(
	CLK,
	S1A,
	S0A,
	Load,
	S1B,
	S0B,
	Select,
	OE,
	Reset,
	Ain,
	Bin,
	B0,
	ZeroB,
	Adderresult,
	OUT,
	Productresult,
	qRegA,
	qRegB
);


input wire	CLK;
input wire	S1A;
input wire	S0A;
input wire	Load;
input wire	S1B;
input wire	S0B;
input wire	Select;
input wire	OE;
input wire	Reset;
input wire	[10:0] Ain;
input wire	[10:0] Bin;
output wire	B0;
output wire	ZeroB;
output wire	[21:0] Adderresult;
output wire	[21:0] OUT;
output wire	[21:0] Productresult;
output wire	[21:0] qRegA;
output wire	[10:0] qRegB;

wire	[21:0] gdfx_temp0;
wire	[10:0] q;
wire	[21:0] qp;
wire	[21:0] SYNTHESIZED_WIRE_0;
wire	[0:21] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	[21:0] SYNTHESIZED_WIRE_4;
wire	[0:21] SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	[21:0] SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	[21:0] SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_10;

assign	Adderresult = SYNTHESIZED_WIRE_4;
assign	qRegA = SYNTHESIZED_WIRE_0;
assign	SYNTHESIZED_WIRE_1 = 0;
assign	SYNTHESIZED_WIRE_5 = 0;




Adder_22bit	b2v_Adder(
	.A(qp),
	.B(SYNTHESIZED_WIRE_0),
	.S(SYNTHESIZED_WIRE_4));


mux2_1_22bit	b2v_inst(
	.S(OE),
	.D0(SYNTHESIZED_WIRE_1),
	.D1(qp),
	.Y(OUT));


assign	SYNTHESIZED_WIRE_8 = S0A | S1A;

assign	SYNTHESIZED_WIRE_10 = S0B | S1B;

assign	SYNTHESIZED_WIRE_2 = Load & Select;

assign	SYNTHESIZED_WIRE_6 = SYNTHESIZED_WIRE_2 | S0A;

assign	ZeroB =  ~SYNTHESIZED_WIRE_3;


data	b2v_inst19(
	.data_in(gdfx_temp0),
	.data_out(SYNTHESIZED_WIRE_9));



OR11	b2v_inst23(
	.in(q),
	.out(SYNTHESIZED_WIRE_3));



mux2_1_22bit	b2v_mux2_1(
	.S(S0A),
	.D0(SYNTHESIZED_WIRE_4),
	.D1(SYNTHESIZED_WIRE_5),
	.Y(SYNTHESIZED_WIRE_7));


Register_22bit	b2v_ProductReg(
	.CLK(CLK),
	.Enable(SYNTHESIZED_WIRE_6),
	.Reset(Reset),
	.In(SYNTHESIZED_WIRE_7),
	.Q(qp));


ShiftLeftReg_22bit	b2v_RegA(
	.CLK(CLK),
	.Enable(SYNTHESIZED_WIRE_8),
	.Load(S0A),
	.Reset(Reset),
	.In(SYNTHESIZED_WIRE_9),
	.Q(SYNTHESIZED_WIRE_0));


ShiftRightReg_11bit	b2v_RegB(
	.CLK(CLK),
	.Enable(SYNTHESIZED_WIRE_10),
	.Load(S0B),
	.Reset(Reset),
	.In(Bin),
	.Q(q));

assign	B0 = q[0];
assign	Productresult = qp;
assign	qRegB = q;
assign	gdfx_temp0[21:11] = 11'b00000000000;
assign	gdfx_temp0[10:0] = Ain;

endmodule
