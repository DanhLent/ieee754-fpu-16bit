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
// CREATED		"Fri Dec 12 21:39:50 2025"

module Counter_4bit(
	CLK,
	Enable,
	Clear,
	q
);


input wire	CLK;
input wire	Enable;
input wire	Clear;
output wire	[3:0] q;

wire	[3:0] q_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_9;
reg	DFF_D3;
wire	SYNTHESIZED_WIRE_4;
reg	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
reg	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
reg	SYNTHESIZED_WIRE_14;





always@(posedge CLK or negedge SYNTHESIZED_WIRE_9)
begin
if (!SYNTHESIZED_WIRE_9)
	begin
	SYNTHESIZED_WIRE_14 <= 0;
	end
else
	begin
	SYNTHESIZED_WIRE_14 <= q_ALTERA_SYNTHESIZED[0];
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_9)
begin
if (!SYNTHESIZED_WIRE_9)
	begin
	SYNTHESIZED_WIRE_12 <= 0;
	end
else
	begin
	SYNTHESIZED_WIRE_12 <= q_ALTERA_SYNTHESIZED[1];
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_9)
begin
if (!SYNTHESIZED_WIRE_9)
	begin
	SYNTHESIZED_WIRE_10 <= 0;
	end
else
	begin
	SYNTHESIZED_WIRE_10 <= q_ALTERA_SYNTHESIZED[2];
	end
end


always@(posedge CLK or negedge SYNTHESIZED_WIRE_9)
begin
if (!SYNTHESIZED_WIRE_9)
	begin
	DFF_D3 <= 0;
	end
else
	begin
	DFF_D3 <= q_ALTERA_SYNTHESIZED[3];
	end
end

assign	q_ALTERA_SYNTHESIZED[3] = DFF_D3 ^ SYNTHESIZED_WIRE_4;

assign	q_ALTERA_SYNTHESIZED[2] = SYNTHESIZED_WIRE_10 ^ SYNTHESIZED_WIRE_11;

assign	q_ALTERA_SYNTHESIZED[1] = SYNTHESIZED_WIRE_12 ^ SYNTHESIZED_WIRE_13;

assign	q_ALTERA_SYNTHESIZED[0] = SYNTHESIZED_WIRE_14 ^ Enable;

assign	SYNTHESIZED_WIRE_11 = SYNTHESIZED_WIRE_13 & SYNTHESIZED_WIRE_12;

assign	SYNTHESIZED_WIRE_4 = SYNTHESIZED_WIRE_11 & SYNTHESIZED_WIRE_10;

assign	SYNTHESIZED_WIRE_13 = Enable & SYNTHESIZED_WIRE_14;

assign	SYNTHESIZED_WIRE_9 =  ~Clear;

assign	q = q_ALTERA_SYNTHESIZED;

endmodule
