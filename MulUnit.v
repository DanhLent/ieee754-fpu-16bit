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
// CREATED		"Sun Dec 28 18:45:40 2025"

module MulUnit(
	CLK,
	Start,
	Ain,
	Bin,
	Done,
	Out
);


input wire	CLK;
input wire	Start;
input wire	[15:0] Ain;
input wire	[15:0] Bin;
output wire	Done;
output wire	[15:0] Out;

wire	Done_ALTERA_SYNTHESIZED;
wire	[4:0] Exp_A;
wire	[4:0] Exp_B;
wire	[4:0] Exp_Final;
wire	GND;
wire	is_zero;
wire	[10:0] Man_A_Sign;
wire	[10:0] Man_B_Sign;
wire	[9:0] Man_Final;
wire	[21:0] ResultMul;
wire	[5:0] ResultSub;
wire	Sign_A;
wire	Sign_B;
wire	Sign_Final;
wire	VCC;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[5:0] SYNTHESIZED_WIRE_2;
wire	[4:0] SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	[15:0] SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	[0:15] SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;

assign	SYNTHESIZED_WIRE_0 = 0;
assign	SYNTHESIZED_WIRE_1 = 0;
assign	SYNTHESIZED_WIRE_4 = 0;
assign	SYNTHESIZED_WIRE_8 = 0;
assign	SYNTHESIZED_WIRE_9 = 0;
wire	[5:0] GDFX_TEMP_SIGNAL_2;
wire	[5:0] GDFX_TEMP_SIGNAL_1;
wire	[15:0] GDFX_TEMP_SIGNAL_4;
wire	[4:0] GDFX_TEMP_SIGNAL_0;
wire	[5:0] GDFX_TEMP_SIGNAL_3;


assign	GDFX_TEMP_SIGNAL_2 = {GND,Exp_B[4:0]};
assign	GDFX_TEMP_SIGNAL_1 = {GND,Exp_A[4:0]};
assign	GDFX_TEMP_SIGNAL_4 = {Sign_Final,Exp_Final[4:0],Man_Final[9:0]};
assign	GDFX_TEMP_SIGNAL_0 = {GND,GND,GND,GND,VCC};
assign	GDFX_TEMP_SIGNAL_3 = {GND,GND,VCC,VCC,VCC,VCC};



Adder_5bit	b2v_inst1(
	.Cin(SYNTHESIZED_WIRE_0),
	.A(ResultSub[4:0]),
	.B(GDFX_TEMP_SIGNAL_0),
	
	.S(SYNTHESIZED_WIRE_3));




assign	Sign_Final = Sign_B ^ Sign_A;


Adder_6bit	b2v_inst19(
	.Cin(SYNTHESIZED_WIRE_1),
	.A(GDFX_TEMP_SIGNAL_1),
	.B(GDFX_TEMP_SIGNAL_2),
	
	.S(SYNTHESIZED_WIRE_2));



data_FP16	b2v_inst20(
	.In(Ain),
	.Sign(Sign_A),
	.E(Exp_A),
	.M(Man_A_Sign[9:0]));



Sub_6bit	b2v_inst25(
	.A(SYNTHESIZED_WIRE_2),
	.B(GDFX_TEMP_SIGNAL_3),
	
	.S(ResultSub));


mux2_1_10bit	b2v_inst27(
	.S(ResultMul[21]),
	.D0(ResultMul[19:10]),
	.D1(ResultMul[20:11]),
	.Y(Man_Final));


mux2_1_5bit	b2v_inst28(
	.S(ResultMul[21]),
	.D0(ResultSub[4:0]),
	.D1(SYNTHESIZED_WIRE_3),
	.Y(Exp_Final));


Register_16bit	b2v_inst3(
	.CLK(CLK),
	.Enable(Done_ALTERA_SYNTHESIZED),
	.Reset(SYNTHESIZED_WIRE_4),
	.In(SYNTHESIZED_WIRE_5),
	.Q(Out));


data_FP16	b2v_inst30(
	.In(Bin),
	.Sign(Sign_B),
	.E(Exp_B),
	.M(Man_B_Sign[9:0]));

assign	is_zero = SYNTHESIZED_WIRE_6 | SYNTHESIZED_WIRE_7;


mux2_1_16bit	b2v_inst5(
	.S(is_zero),
	.D0(GDFX_TEMP_SIGNAL_4),
	.D1(SYNTHESIZED_WIRE_8),
	.Y(SYNTHESIZED_WIRE_5));




Mul	b2v_inst8(
	.CLK(CLK),
	.Start(Start),
	.Reset(SYNTHESIZED_WIRE_9),
	.Ain(Man_A_Sign),
	.Bin(Man_B_Sign),
	.Done(Done_ALTERA_SYNTHESIZED),
	.OUT(ResultMul)
	
	
	);



NOR_5	b2v_NOR_A(
	.In(Exp_A),
	.Out(SYNTHESIZED_WIRE_7));


NOR_5	b2v_NOR_B(
	.In(Exp_B),
	.Out(SYNTHESIZED_WIRE_6));

assign	Done = Done_ALTERA_SYNTHESIZED;
assign	GND = 0;
assign	Man_A_Sign[10] = 1;
assign	Man_B_Sign[10] = 1;
assign	VCC = 1;

endmodule
