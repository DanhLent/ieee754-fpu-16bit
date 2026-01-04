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
// CREATED		"Thu Dec 25 12:43:54 2025"

module Controller_Div(
	CLK,
	Reset,
	Start,
	Load,
	Shift_Enable,
	Update_A,
	Sel_A,
	Done
);


input wire	CLK;
input wire	Reset;
input wire	Start;
output wire	Load;
output wire	Shift_Enable;
output wire	Update_A;
output wire	Sel_A;
output wire	Done;

reg	[2:0] data;
wire	Finish;
wire	LoopDone;
wire	[4:0] q;
wire	S0;
wire	S1;
wire	S2;
wire	S3;
wire	S4;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_10;
reg	SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;





always@(posedge CLK or negedge SYNTHESIZED_WIRE_18)
begin
if (!SYNTHESIZED_WIRE_18)
	begin
	data[0] <= 0;
	end
else
	begin
	data[0] <= SYNTHESIZED_WIRE_1;
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_18)
begin
if (!SYNTHESIZED_WIRE_18)
	begin
	data[1] <= 0;
	end
else
	begin
	data[1] <= SYNTHESIZED_WIRE_3;
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_18)
begin
if (!SYNTHESIZED_WIRE_18)
	begin
	data[2] <= 0;
	end
else
	begin
	data[2] <= SYNTHESIZED_WIRE_5;
	end
end


decoder3_5	b2v_inst(
	.data(data),
	.S0(S0),
	.S1(S1),
	.S2(S2),
	.S3(S3),
	.S4(S4));

assign	SYNTHESIZED_WIRE_12 = S0 & Start;

assign	SYNTHESIZED_WIRE_17 = S3 & SYNTHESIZED_WIRE_6;

assign	SYNTHESIZED_WIRE_5 = S3 & LoopDone;

assign	SYNTHESIZED_WIRE_18 =  ~Reset;


and5_0	b2v_inst13(
	.IN3(q[2]),
	.IN2(q[3]),
	.IN1(q[4]),
	.IN5(SYNTHESIZED_WIRE_7),
	.IN4(SYNTHESIZED_WIRE_8),
	.OUT(LoopDone));


and5_1	b2v_inst14(
	.IN3(q[2]),
	.IN2(SYNTHESIZED_WIRE_9),
	.IN1(q[4]),
	.IN5(SYNTHESIZED_WIRE_10),
	.IN4(q[1]),
	.OUT(Finish));

assign	SYNTHESIZED_WIRE_10 =  ~q[0];

assign	SYNTHESIZED_WIRE_9 =  ~q[3];

assign	SYNTHESIZED_WIRE_20 =  ~SYNTHESIZED_WIRE_19;

assign	Load = S1 & SYNTHESIZED_WIRE_20;

assign	SYNTHESIZED_WIRE_1 = S2 | SYNTHESIZED_WIRE_12;

assign	Shift_Enable = S2 & SYNTHESIZED_WIRE_20;

assign	Update_A = S3 & SYNTHESIZED_WIRE_20;

assign	Sel_A = S3 & SYNTHESIZED_WIRE_20;


always@(posedge CLK)
begin
	begin
	SYNTHESIZED_WIRE_19 <= SYNTHESIZED_WIRE_16;
	end
end

assign	SYNTHESIZED_WIRE_3 = S2 | SYNTHESIZED_WIRE_17 | S1;


Counter_5bit	b2v_inst5(
	.CLK(CLK),
	.Enable(S3),
	.Clear(S1),
	.q(q));

assign	SYNTHESIZED_WIRE_16 = Finish | SYNTHESIZED_WIRE_19;

assign	SYNTHESIZED_WIRE_8 =  ~q[1];

assign	SYNTHESIZED_WIRE_7 =  ~q[0];

assign	SYNTHESIZED_WIRE_6 =  ~LoopDone;

assign	Done = S4;

endmodule

module and5_0(IN3,IN2,IN1,IN5,IN4,OUT);
/* synthesis black_box */

input IN3;
input IN2;
input IN1;
input IN5;
input IN4;
output OUT;

endmodule

module and5_1(IN3,IN2,IN1,IN5,IN4,OUT);
/* synthesis black_box */

input IN3;
input IN2;
input IN1;
input IN5;
input IN4;
output OUT;

endmodule
