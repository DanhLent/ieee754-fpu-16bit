module Add_SubUnit_new(
    input wire Select,
    input wire [15:0] Ain,
    input wire [15:0] Bin,
    output wire [15:0] Result
);

// --- CÁC DÂY TÍN HIỆU ---
wire A_gt_B;
wire [3:0] Count;
wire Cout;
wire [4:0] Diff;
wire [4:0] E_max;
wire [4:0] E_max_plus_1;
wire [5:0] E_Sub_6bit;
wire [4:0] Exp_A;
wire [4:0] Exp_B;
wire GND;
wire [10:0] Man_A_Sign;
wire [10:0] Man_B_Sign;
wire [10:0] Man_Large;
wire [15:0] Man_Small_Shifted;
wire [15:0] Norm_Man;
wire Sign_A;
wire Sign_B;
wire [14:0] Sum_Result;
wire VCC;
wire [4:0] E_Norm;
wire [15:0] Result_ALTERA_SYNTHESIZED;
wire Is_Overflow;
wire Op_Effective;
wire [14:0] Adder_In_A;
wire [14:0] Adder_In_B;
wire [3:0] Shift_Amt;

// --- 1. HẰNG SỐ & LOGIC CƠ BẢN ---
assign GND = 0;
assign VCC = 1;

// --- 2. BÓC TÁCH INPUT ---
data_FP16 b2v_A(
    .In(Ain),
    .Sign(Sign_A),
    .E(Exp_A),
    .M(Man_A_Sign[9:0]));
assign Man_A_Sign[10] = 1; // Bit ẩn

data_FP16 b2v_B(
    .In(Bin),
    .Sign(Sign_B),
    .E(Exp_B),
    .M(Man_B_Sign[9:0]));
assign Man_B_Sign[10] = 1; // Bit ẩn

// --- 3. SO SÁNH & SẮP XẾP ---
Compare_5bit b2v_inst2(
    .Ain(Exp_A),
    .Bin(Exp_B),
    .A_gt_B(A_gt_B),
    .Diff(Diff));

mux2_1_5bit b2v_Compare_Exp(
    .S(A_gt_B),
    .D0(Exp_B),
    .D1(Exp_A),
    .Y(E_max));

mux2_1_11bit b2v_Man_Larger(
    .S(A_gt_B),
    .D0(Man_B_Sign),
    .D1(Man_A_Sign),
    .Y(Man_Large));

wire [10:0] Man_Small;
mux2_1_11bit b2v_Man_Small(
    .S(A_gt_B),
    .D0(Man_A_Sign),
    .D1(Man_B_Sign),
    .Y(Man_Small));

// --- 4. CÂN BẰNG MŨ (SHIFT) ---
// Bão hòa dịch: Nếu lệch > 15 thì dịch 15
mux2_1_4bit b2v_inst8(
    .S(Diff[4]),
    .D0(Diff[3:0]),
    .D1(4'b1111), 
    .Y(Shift_Amt));

Shifter_right b2v_inst1(
    .In(Man_Small),
    .S(Shift_Amt),
    .OUT(Man_Small_Shifted));

// --- 5. TÍNH TOÁN CỘNG/TRỪ ---
assign Op_Effective = (Sign_A ^ Sign_B) ^ Select;

// Chuẩn bị Input cho Adder 15-bit
// A: Nối thêm 4 bit 0 vào đuôi
assign Adder_In_A = {Man_Large[10:0], 4'b0000};
// B: Lấy 15 bit cao của kết quả dịch
assign Adder_In_B = Man_Small_Shifted[15:1];

AddSub b2v_inst3(
    .Select(Op_Effective),
    .Ain(Adder_In_A),
    .Bin(Adder_In_B),
    .Cout(Cout),
    .OUT(Sum_Result));

// --- 6. XỬ LÝ TRÀN (QUAN TRỌNG) ---
// Tràn xảy ra khi Cout=1 HOẶC bit cao nhất (14) của Sum bằng 1 (lên hàng 2.0)
assign Is_Overflow = Cout | Sum_Result[14];

// --- 7. CHUẨN HÓA (LZD) ---
wire [15:0] LZD_Input;
assign LZD_Input = {Cout, Sum_Result[14:0]};

detect_zero b2v_inst4(
    .In(LZD_Input),
    .Count(Count));

Shifter_left b2v_inst5(
    .In(LZD_Input),
    .S(Count),
    .OUT(Norm_Man));

// --- 8. TÍNH MŨ MỚI ---
// Trường hợp Tràn: Mũ = E_max + 1
Adder_5bit b2v_inst22(
    .A(E_max),
    .B(5'd1),
    .S(E_max_plus_1));

// Trường hợp Thường: Mũ = E_max + 2 - Count
// (Cộng 2 vì LZD đếm bit 15, 14 là 0 cho số chuẩn 1.0 -> Count=2)
wire [5:0] E_max_plus_2;
assign E_max_plus_2 = {1'b0, E_max} + 6'd2;

Sub_6bit b2v_inst10(
    .A(E_max_plus_2),
    .B({2'b00, Count}),
    .S(E_Sub_6bit));

// Xử lý Underflow (Mũ âm -> 0)
mux2_1_5bit b2v_inst14(
    .S(E_Sub_6bit[5]),
    .D0(E_Sub_6bit[4:0]),
    .D1(5'd0),
    .Y(E_Norm));

// --- 9. CHỌN KẾT QUẢ CUỐI CÙNG ---

// MUX Mũ: Tràn chọn E_max+1, Không tràn chọn E_Norm
mux2_1_5bit b2v_Final(
    .S(Is_Overflow),
    .D0(E_Norm),
    .D1(E_max_plus_1),
    .Y(Result_ALTERA_SYNTHESIZED[14:10]));

// MUX Mantissa:
// - Tràn: Lấy từ bit 13 xuống (bỏ bit ẩn mới là 14) -> [13:4]
// - Không tràn: Lấy từ bit 14 xuống (bỏ bit ẩn mới là 15) -> [14:5]
mux2_1_10bit b2v_inst7(
    .S(Is_Overflow),
    .D0(Norm_Man[14:5]),   
    .D1(Sum_Result[13:4]), 
    .Y(Result_ALTERA_SYNTHESIZED[9:0]));

// Chọn Dấu
mux2_1_1bit b2v_inst18(
    .S(A_gt_B),
    .D0(Sign_B),
    .D1(Sign_A),
    .Y(Result_ALTERA_SYNTHESIZED[15]));

assign Result = Result_ALTERA_SYNTHESIZED;

endmodule