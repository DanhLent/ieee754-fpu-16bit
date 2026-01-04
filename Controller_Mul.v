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
// CREATED		"Mon Dec  8 23:22:18 2025"

module Controller_Mul(
	CLK,
	ZeroB,
	B0,
	Reset,
	Start,
	S1A,
	S0A,
	S1B,
	S0B,
	Load,
	Select,
	OE
);


input wire	CLK;
input wire	ZeroB;
input wire	B0;
input wire	Reset;
input wire	Start;
output wire	S1A;
output wire	S0A;
output wire	S1B;
output wire	S0B;
output wire	Load;
output wire	Select;
output wire	OE;

reg	[2:0] data;
wire	S0;
wire	S1;
wire	S2;
wire	S3;
wire	S4;
wire	SYNTHESIZED_WIRE_29;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_30;
wire	SYNTHESIZED_WIRE_31;
wire	SYNTHESIZED_WIRE_32;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_33;
wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_25;
wire	SYNTHESIZED_WIRE_28;





always@(posedge CLK or negedge SYNTHESIZED_WIRE_29)
begin
if (!SYNTHESIZED_WIRE_29)
	begin
	data[0] <= 0;
	end
else
	begin
	data[0] <= SYNTHESIZED_WIRE_1;
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_29)
begin
if (!SYNTHESIZED_WIRE_29)
	begin
	data[1] <= 0;
	end
else
	begin
	data[1] <= SYNTHESIZED_WIRE_3;
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_29)
begin
if (!SYNTHESIZED_WIRE_29)
	begin
	data[2] <= 0;
	end
else
	begin
	data[2] <= SYNTHESIZED_WIRE_5;
	end
end

assign	SYNTHESIZED_WIRE_25 = SYNTHESIZED_WIRE_30 & SYNTHESIZED_WIRE_31 & data[0];


decode3_5	b2v_inst1(
	.data(data),
	.S0(S0),
	
	.S2(S2),
	.S3(S3),
	.S4(S4));

assign	SYNTHESIZED_WIRE_24 = SYNTHESIZED_WIRE_30 & SYNTHESIZED_WIRE_31 & SYNTHESIZED_WIRE_32;

assign	SYNTHESIZED_WIRE_1 = SYNTHESIZED_WIRE_11 | SYNTHESIZED_WIRE_12 | SYNTHESIZED_WIRE_13 | SYNTHESIZED_WIRE_14;

assign	SYNTHESIZED_WIRE_11 = SYNTHESIZED_WIRE_15 & SYNTHESIZED_WIRE_33;

assign	SYNTHESIZED_WIRE_15 =  ~B0;

assign	SYNTHESIZED_WIRE_12 = SYNTHESIZED_WIRE_30 & data[1] & SYNTHESIZED_WIRE_32;

assign	SYNTHESIZED_WIRE_13 = SYNTHESIZED_WIRE_30 & data[1] & data[0];

assign	SYNTHESIZED_WIRE_3 = SYNTHESIZED_WIRE_20 | SYNTHESIZED_WIRE_33;

assign	SYNTHESIZED_WIRE_20 = SYNTHESIZED_WIRE_30 & data[1] & SYNTHESIZED_WIRE_32;

assign	SYNTHESIZED_WIRE_29 =  ~Reset;

assign	SYNTHESIZED_WIRE_30 =  ~data[2];

assign	SYNTHESIZED_WIRE_14 = Start & SYNTHESIZED_WIRE_24;

assign	SYNTHESIZED_WIRE_31 =  ~data[1];

assign	SYNTHESIZED_WIRE_32 =  ~data[0];

assign	SYNTHESIZED_WIRE_5 = ZeroB & SYNTHESIZED_WIRE_25;

assign	Load = S2 | S0;

assign	SYNTHESIZED_WIRE_33 = SYNTHESIZED_WIRE_30 & SYNTHESIZED_WIRE_31 & data[0] & SYNTHESIZED_WIRE_28;

assign	SYNTHESIZED_WIRE_28 =  ~ZeroB;

assign	S1A = S3;
assign	S0A = S0;
assign	S1B = S3;
assign	S0B = S0;
assign	Select = S2;
assign	OE = S4;

endmodule
