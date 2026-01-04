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
// CREATED		"Tue Dec 30 07:30:40 2025"

module Controller_FPU(
	CLK,
	Reset,
	Start,
	Mul_Done,
	Div_Done,
	AddSub_Done,
	Op,
	Start_Mul,
	Start_Div,
	Final_Done,
	Start_AddSub
);


input wire	CLK;
input wire	Reset;
input wire	Start;
input wire	Mul_Done;
input wire	Div_Done;
input wire	AddSub_Done;
input wire	[1:0] Op;
output reg	Start_Mul;
output reg	Start_Div;
output wire	Final_Done;
output reg	Start_AddSub;

wire	doneDiv;
wire	doneMul;
wire	inCalc;
wire	inDone;
wire	inIdle;
wire	isAddSub;
wire	isDiv;
wire	isMul;
wire	not_done;
wire	SYNTHESIZED_WIRE_26;
wire	SYNTHESIZED_WIRE_27;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_5;
reg	SYNTHESIZED_WIRE_28;
wire	SYNTHESIZED_WIRE_29;
wire	SYNTHESIZED_WIRE_30;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_14;
reg	DFF_Fina_Done;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
reg	SYNTHESIZED_WIRE_31;
wire	SYNTHESIZED_WIRE_32;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_25;

assign	Final_Done = DFF_Fina_Done;




always@(posedge CLK or negedge SYNTHESIZED_WIRE_26)
begin
if (!SYNTHESIZED_WIRE_26)
	begin
	Start_AddSub <= 0;
	end
else
	begin
	Start_AddSub <= SYNTHESIZED_WIRE_27;
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_26)
begin
if (!SYNTHESIZED_WIRE_26)
	begin
	Start_Div <= 0;
	end
else
	begin
	Start_Div <= SYNTHESIZED_WIRE_3;
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_26)
begin
if (!SYNTHESIZED_WIRE_26)
	begin
	DFF_Fina_Done <= 0;
	end
else
	begin
	DFF_Fina_Done <= SYNTHESIZED_WIRE_5;
	end
end

assign	isAddSub =  ~Op[1];

assign	inDone = SYNTHESIZED_WIRE_28 & SYNTHESIZED_WIRE_29;

assign	doneDiv = isDiv & Div_Done;

assign	doneMul = isMul & Mul_Done;

assign	SYNTHESIZED_WIRE_8 = inCalc & SYNTHESIZED_WIRE_30;

assign	SYNTHESIZED_WIRE_9 = inDone & Start;

assign	SYNTHESIZED_WIRE_21 = inIdle & Start & isMul;

assign	SYNTHESIZED_WIRE_25 = SYNTHESIZED_WIRE_8 | SYNTHESIZED_WIRE_9 | SYNTHESIZED_WIRE_27;

assign	SYNTHESIZED_WIRE_27 = inIdle & Start & isAddSub;

assign	SYNTHESIZED_WIRE_12 = inIdle & Start & Op[1];

assign	SYNTHESIZED_WIRE_16 =  ~Op[0];

assign	SYNTHESIZED_WIRE_11 = inCalc & not_done;

assign	SYNTHESIZED_WIRE_23 = SYNTHESIZED_WIRE_11 | SYNTHESIZED_WIRE_12;

assign	not_done =  ~SYNTHESIZED_WIRE_30;

assign	SYNTHESIZED_WIRE_26 =  ~Reset;

assign	SYNTHESIZED_WIRE_15 = isAddSub & AddSub_Done;

assign	SYNTHESIZED_WIRE_5 = inDone | SYNTHESIZED_WIRE_14;

assign	SYNTHESIZED_WIRE_14 = inCalc & DFF_Fina_Done;

assign	SYNTHESIZED_WIRE_3 = inIdle & Start & isDiv;

assign	SYNTHESIZED_WIRE_30 = SYNTHESIZED_WIRE_15 | doneDiv | doneMul;

assign	isMul = Op[1] & SYNTHESIZED_WIRE_16;

assign	isDiv = Op[1] & Op[0];

assign	SYNTHESIZED_WIRE_32 =  ~SYNTHESIZED_WIRE_28;

assign	SYNTHESIZED_WIRE_29 =  ~SYNTHESIZED_WIRE_31;

assign	inIdle = SYNTHESIZED_WIRE_32 & SYNTHESIZED_WIRE_29;

assign	inCalc = SYNTHESIZED_WIRE_32 & SYNTHESIZED_WIRE_31;


always@(posedge CLK or negedge SYNTHESIZED_WIRE_26)
begin
if (!SYNTHESIZED_WIRE_26)
	begin
	Start_Mul <= 0;
	end
else
	begin
	Start_Mul <= SYNTHESIZED_WIRE_21;
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_26)
begin
if (!SYNTHESIZED_WIRE_26)
	begin
	SYNTHESIZED_WIRE_31 <= 0;
	end
else
	begin
	SYNTHESIZED_WIRE_31 <= SYNTHESIZED_WIRE_23;
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_26)
begin
if (!SYNTHESIZED_WIRE_26)
	begin
	SYNTHESIZED_WIRE_28 <= 0;
	end
else
	begin
	SYNTHESIZED_WIRE_28 <= SYNTHESIZED_WIRE_25;
	end
end


endmodule
