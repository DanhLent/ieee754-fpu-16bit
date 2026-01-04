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
// CREATED		"Wed Dec  3 09:40:56 2025"

module detect_zero(
	In,
	Count
);


input wire	[15:0] In;
output wire	[3:0] Count;

wire	[3:0] Count_ALTERA_SYNTHESIZED;
wire	GND;
wire	[15:0] Node1;
wire	[15:0] Node2;
wire	[15:0] Node3;

wire	[15:0] GDFX_TEMP_SIGNAL_3;
wire	[15:0] GDFX_TEMP_SIGNAL_2;
wire	[15:0] GDFX_TEMP_SIGNAL_5;
wire	[15:0] GDFX_TEMP_SIGNAL_4;
wire	[15:0] GDFX_TEMP_SIGNAL_1;
wire	[15:0] GDFX_TEMP_SIGNAL_0;


assign	GDFX_TEMP_SIGNAL_3 = {GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,Node1[3:0]};
assign	GDFX_TEMP_SIGNAL_2 = {GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,Node1[7:4]};
assign	GDFX_TEMP_SIGNAL_5 = {GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,Node2[1:0]};
assign	GDFX_TEMP_SIGNAL_4 = {GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,GND,Node2[3:2]};
assign	GDFX_TEMP_SIGNAL_1 = {GND,GND,GND,GND,GND,GND,GND,GND,In[7:0]};
assign	GDFX_TEMP_SIGNAL_0 = {GND,GND,GND,GND,GND,GND,GND,GND,In[15:8]};

assign	Count_ALTERA_SYNTHESIZED[3] = ~(In[15] | In[13] | In[14] | In[12] | In[10] | In[11] | In[9] | In[8]);


mux2_1_16bit	b2v_inst1(
	.S(Count_ALTERA_SYNTHESIZED[3]),
	.D0(GDFX_TEMP_SIGNAL_0),
	.D1(GDFX_TEMP_SIGNAL_1),
	.Y(Node1));


mux2_1_16bit	b2v_inst2(
	.S(Count_ALTERA_SYNTHESIZED[2]),
	.D0(GDFX_TEMP_SIGNAL_2),
	.D1(GDFX_TEMP_SIGNAL_3),
	.Y(Node2));

assign	Count_ALTERA_SYNTHESIZED[2] = ~(Node1[7] | Node1[5] | Node1[6] | Node1[4]);


mux2_1_16bit	b2v_inst5(
	.S(Count_ALTERA_SYNTHESIZED[1]),
	.D0(GDFX_TEMP_SIGNAL_4),
	.D1(GDFX_TEMP_SIGNAL_5),
	.Y(Node3));

assign	Count_ALTERA_SYNTHESIZED[1] = ~(Node2[2] | Node2[3]);

assign	Count_ALTERA_SYNTHESIZED[0] =  ~Node3[1];

assign	Count = Count_ALTERA_SYNTHESIZED;

endmodule
