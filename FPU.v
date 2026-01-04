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
// CREATED		"Tue Dec 30 06:19:22 2025"

module FPU(
	CLK,
	Reset,
	Start,
	LoadA,
	LoadB,
	In,
	Opcode,
	Done,
	Div_Zero,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	OUT
);


input wire	CLK;
input wire	Reset;
input wire	Start;
input wire	LoadA;
input wire	LoadB;
input wire	[15:0] In;
input wire	[1:0] Opcode;
output wire	Done;
output wire	Div_Zero;
output wire	[6:0] HEX0;
output wire	[6:0] HEX1;
output wire	[6:0] HEX2;
output wire	[6:0] HEX3;
output wire	[15:0] OUT;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	[15:0] SYNTHESIZED_WIRE_17;
wire	[15:0] SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_6;
wire	[15:0] SYNTHESIZED_WIRE_9;
wire	[15:0] SYNTHESIZED_WIRE_19;
wire	[15:0] SYNTHESIZED_WIRE_12;
wire	[15:0] SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;

assign	OUT = SYNTHESIZED_WIRE_9;




Controller_FPU	b2v_Controller(
	.CLK(CLK),
	.Reset(Reset),
	.Start(Start),
	.AddSub_Done(SYNTHESIZED_WIRE_0),
	.Mul_Done(SYNTHESIZED_WIRE_1),
	.Div_Done(SYNTHESIZED_WIRE_2),
	.Op(Opcode),
	.Start_AddSub(SYNTHESIZED_WIRE_6),
	.Start_Mul(SYNTHESIZED_WIRE_14),
	.Start_Div(SYNTHESIZED_WIRE_3),
	.Final_Done(Done));


DivUnit	b2v_Div(
	.CLK(CLK),
	.Start(SYNTHESIZED_WIRE_3),
	.Ain(SYNTHESIZED_WIRE_17),
	.Bin(SYNTHESIZED_WIRE_18),
	.Div_Zero(Div_Zero),
	.Done(SYNTHESIZED_WIRE_2),
	.Out(SYNTHESIZED_WIRE_13));


Add_SubUnit	b2v_inst1(
	.Select(Opcode[0]),
	.CLK(CLK),
	.Start(SYNTHESIZED_WIRE_6),
	.Ain(SYNTHESIZED_WIRE_17),
	.Bin(SYNTHESIZED_WIRE_18),
	.Done(SYNTHESIZED_WIRE_0),
	.Out(SYNTHESIZED_WIRE_19));


FPU_Display_Module	b2v_inst3(
	.bin_in(SYNTHESIZED_WIRE_9),
	.hex0_out(HEX0),
	.hex1_out(HEX1),
	.hex2_out(HEX2),
	.hex3_out(HEX3));


mux4_1_16bit	b2v_inst4(
	.D0(SYNTHESIZED_WIRE_19),
	.D1(SYNTHESIZED_WIRE_19),
	.D2(SYNTHESIZED_WIRE_12),
	.D3(SYNTHESIZED_WIRE_13),
	.Sel(Opcode),
	.Y(SYNTHESIZED_WIRE_9));


Register_16bit	b2v_Load_A(
	.CLK(CLK),
	.Enable(LoadA),
	.Reset(Reset),
	.In(In),
	.Q(SYNTHESIZED_WIRE_17));


Register_16bit	b2v_Load_b(
	.CLK(CLK),
	.Enable(LoadB),
	.Reset(Reset),
	.In(In),
	.Q(SYNTHESIZED_WIRE_18));


MulUnit	b2v_Mul(
	.CLK(CLK),
	.Start(SYNTHESIZED_WIRE_14),
	.Ain(SYNTHESIZED_WIRE_17),
	.Bin(SYNTHESIZED_WIRE_18),
	.Done(SYNTHESIZED_WIRE_1),
	.Out(SYNTHESIZED_WIRE_12));


endmodule
