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
// CREATED		"Tue Dec 30 08:35:31 2025"

module Add_SubUnit(
	Select,
	CLK,
	Start,
	Ain,
	Bin,
	Done,
	Out
);


input wire	Select;
input wire	CLK;
input wire	Start;
input wire	[15:0] Ain;
input wire	[15:0] Bin;
output reg	Done;
output wire	[15:0] Out;

wire	A_gt_B;
wire	[3:0] Count;
wire	Cout;
wire	Cout_nSel;
wire	[4:0] Diff;
wire	[4:0] E_max;
wire	[4:0] E_max_nor;
wire	[4:0] E_max_reg;
wire	[5:0] E_Sub_6bit;
wire	[4:0] Exp_A;
wire	[4:0] Exp_B;
wire	GND;
wire	[10:0] Man_A_Sign;
wire	[10:0] Man_B_Sign;
wire	[10:0] Man_Large;
wire	[15:0] Man_Small_Shifted;
wire	[15:0] Norm_Man;
wire	[15:0] Q_REG1_MAN_A;
wire	[14:0] Result;
wire	Sign_A;
wire	Sign_B;
wire	[14:0] Sum_Result;
wire	[15:0] Sum_Result_reg;
wire	VCC;
reg	w_sign;
wire	[4:0] SYNTHESIZED_WIRE_0;
wire	[15:0] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	[0:4] SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
reg	DFF_inst4;
wire	SYNTHESIZED_WIRE_5;
wire	[15:0] SYNTHESIZED_WIRE_6;
wire	[0:15] SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
reg	DFF_REG_OP1;
reg	DFF_inst2;
wire	[10:0] SYNTHESIZED_WIRE_9;
wire	[3:0] SYNTHESIZED_WIRE_10;
reg	SYNTHESIZED_WIRE_18;
wire	[14:0] SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
wire	[4:0] SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;
reg	DFF_REG_SIGN_1;

assign	SYNTHESIZED_WIRE_3 = 0;
assign	SYNTHESIZED_WIRE_7 = 0;
assign	SYNTHESIZED_WIRE_14 = 0;
wire	[4:0] GDFX_TEMP_SIGNAL_5;
wire	[5:0] GDFX_TEMP_SIGNAL_2;
wire	[15:0] GDFX_TEMP_SIGNAL_0;
wire	[15:0] GDFX_TEMP_SIGNAL_1;
wire	[15:0] GDFX_TEMP_SIGNAL_7;
wire	[5:0] GDFX_TEMP_SIGNAL_3;
wire	[14:0] GDFX_TEMP_SIGNAL_6;
wire	[3:0] GDFX_TEMP_SIGNAL_4;


assign	GDFX_TEMP_SIGNAL_5 = {GND,GND,GND,GND,VCC};
assign	GDFX_TEMP_SIGNAL_2 = {GND,E_max_nor[4:0]};
assign	GDFX_TEMP_SIGNAL_0 = {Cout_nSel,Sum_Result_reg[14:0]};
assign	GDFX_TEMP_SIGNAL_1 = {Cout_nSel,Sum_Result_reg[14:0]};
assign	GDFX_TEMP_SIGNAL_7 = {Cout,Sum_Result[14:0]};
assign	GDFX_TEMP_SIGNAL_3 = {GND,GND,Count[3:0]};
assign	GDFX_TEMP_SIGNAL_6 = {Man_Large[10:0],GND,GND,GND,GND};
assign	GDFX_TEMP_SIGNAL_4 = {VCC,VCC,VCC,VCC};


mux2_1_5bit	b2v_Compare_Exp(
	.S(A_gt_B),
	.D0(Exp_B),
	.D1(Exp_A),
	.Y(E_max));


mux2_1_5bit	b2v_ExpFinal(
	.S(Cout_nSel),
	.D0(SYNTHESIZED_WIRE_0),
	.D1(E_max_nor),
	.Y(Result[14:10]));



Register_16bit	b2v_inst1(
	.CLK(CLK),
	.Enable(VCC),
	.Reset(GND),
	.In(SYNTHESIZED_WIRE_1),
	.Q(Out));

assign	SYNTHESIZED_WIRE_2 = Sign_A ^ Sign_B;

assign	SYNTHESIZED_WIRE_16 = SYNTHESIZED_WIRE_2 ^ Select;



mux2_1_5bit	b2v_inst14(
	.S(E_Sub_6bit[5]),
	.D0(E_Sub_6bit[4:0]),
	.D1(SYNTHESIZED_WIRE_3),
	.Y(SYNTHESIZED_WIRE_0));





mux2_1_1bit	b2v_inst18(
	.D0(SYNTHESIZED_WIRE_4),
	.D1(Sign_A),
	.S(A_gt_B),
	.Y(SYNTHESIZED_WIRE_17));


data_FP16	b2v_inst19(
	.In(Ain),
	.Sign(Sign_A),
	.E(Exp_A),
	.M(Man_A_Sign[9:0]));


always@(posedge CLK)
begin
	begin
	DFF_inst2 <= DFF_inst4;
	end
end


FP16_Packer	b2v_inst21(
	.Final_Sign(w_sign),
	.Final_Exp(Result[14:10]),
	.Final_Man(Result[9:0]),
	.Out_FP16(SYNTHESIZED_WIRE_6));


mux2_1_16bit	b2v_inst23(
	.S(SYNTHESIZED_WIRE_5),
	.D0(SYNTHESIZED_WIRE_6),
	.D1(SYNTHESIZED_WIRE_7),
	.Y(SYNTHESIZED_WIRE_1));


assign	Cout_nSel = Sum_Result_reg[15] & SYNTHESIZED_WIRE_8;

assign	SYNTHESIZED_WIRE_8 =  ~DFF_REG_OP1;

assign	SYNTHESIZED_WIRE_4 = Select ^ Sign_B;


always@(posedge CLK)
begin
	begin
	Done <= DFF_inst2;
	end
end


data_FP16	b2v_inst30(
	.In(Bin),
	.Sign(Sign_B),
	.E(Exp_B),
	.M(Man_B_Sign[9:0]));


Compare_5bit	b2v_inst31(
	.Ain(Exp_A),
	.Bin(Exp_B),
	.A_gt_B(A_gt_B),
	.Diff(Diff));


Shifter_right	b2v_inst32(
	.In(SYNTHESIZED_WIRE_9),
	.S(SYNTHESIZED_WIRE_10),
	.OUT(Man_Small_Shifted));


AddSub	b2v_inst33(
	.Select(SYNTHESIZED_WIRE_18),
	.Ain(SYNTHESIZED_WIRE_11),
	.Bin(Q_REG1_MAN_A[15:1]),
	.Cout(Cout),
	.OUT(Sum_Result));


check_zero	b2v_inst34(
	.In(Sum_Result_reg[14:0]),
	.is_zero(SYNTHESIZED_WIRE_12));


detect_zero	b2v_inst37(
	.In(GDFX_TEMP_SIGNAL_0),
	.Count(Count));


Shifter_left	b2v_inst38(
	.In(GDFX_TEMP_SIGNAL_1),
	.S(Count),
	.OUT(Norm_Man));

assign	SYNTHESIZED_WIRE_13 =  ~Cout_nSel;


always@(posedge CLK)
begin
	begin
	DFF_inst4 <= Start;
	end
end

assign	SYNTHESIZED_WIRE_5 = SYNTHESIZED_WIRE_12 & SYNTHESIZED_WIRE_13;


Sub_6bit_ver	b2v_inst5(
	.dataa(GDFX_TEMP_SIGNAL_2),
	.datab(GDFX_TEMP_SIGNAL_3),
	.result(E_Sub_6bit));



mux2_1_10bit	b2v_inst7(
	.S(Cout_nSel),
	.D0(Norm_Man[14:5]),
	.D1(Sum_Result_reg[14:5]),
	.Y(Result[9:0]));


mux2_1_4bit	b2v_inst8(
	.S(Diff[4]),
	.D0(Diff[3:0]),
	.D1(GDFX_TEMP_SIGNAL_4),
	.Y(SYNTHESIZED_WIRE_10));


Adder_5bit	b2v_inst9(
	.Cin(SYNTHESIZED_WIRE_14),
	.A(E_max_reg),
	.B(GDFX_TEMP_SIGNAL_5),
	
	.S(E_max_nor));


mux2_1_11bit	b2v_Man_Larger(
	.S(A_gt_B),
	.D0(Man_B_Sign),
	.D1(Man_A_Sign),
	.Y(Man_Large));


mux2_1_11bit	b2v_Man_Small(
	.S(A_gt_B),
	.D0(Man_A_Sign),
	.D1(Man_B_Sign),
	.Y(SYNTHESIZED_WIRE_9));


Register_16bit	b2v_REG1_MAN_A(
	.CLK(CLK),
	.Enable(VCC),
	.Reset(GND),
	.In(Man_Small_Shifted),
	.Q(Q_REG1_MAN_A));


Register_15bit	b2v_REG1_MAN_B(
	.CLK(CLK),
	.Enable(VCC),
	.Reset(GND),
	.In(GDFX_TEMP_SIGNAL_6),
	.Q(SYNTHESIZED_WIRE_11));


Register_5bitn	b2v_REG_EXP_1(
	.CLK(CLK),
	.Enable(VCC),
	.Reset(GND),
	.In(E_max),
	.Q(SYNTHESIZED_WIRE_15));


Register_5bitn	b2v_REG_EXP_2(
	.CLK(CLK),
	.Enable(VCC),
	.Reset(GND),
	.In(SYNTHESIZED_WIRE_15),
	.Q(E_max_reg));


always@(posedge CLK)
begin
	begin
	SYNTHESIZED_WIRE_18 <= SYNTHESIZED_WIRE_16;
	end
end


always@(posedge CLK)
begin
	begin
	DFF_REG_OP1 <= SYNTHESIZED_WIRE_18;
	end
end


always@(posedge CLK)
begin
	begin
	DFF_REG_SIGN_1 <= SYNTHESIZED_WIRE_17;
	end
end


always@(posedge CLK)
begin
	begin
	w_sign <= DFF_REG_SIGN_1;
	end
end


Register_16bit	b2v_REG_SUM(
	.CLK(CLK),
	.Enable(VCC),
	.Reset(GND),
	.In(GDFX_TEMP_SIGNAL_7),
	.Q(Sum_Result_reg));

assign	GND = 0;
assign	Man_A_Sign[10] = 1;
assign	Man_B_Sign[10] = 1;
assign	VCC = 1;

endmodule
