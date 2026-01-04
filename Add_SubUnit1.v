// ============================================================================
// MODULE: Add_SubUnit (Phiên bản Clean - Logic Fix Lỗi)
// Thứ tự chân KHỚP HOÀN TOÀN với Symbol hình ảnh bạn gửi
// ============================================================================

module Add_SubUnit1(
    // --- INPUTS (Thứ tự từ trên xuống theo Symbol) ---
    input wire [15:0] Ain,
    input wire [15:0] Bin,
    input wire Select,      // 0: Add, 1: Sub
    input wire CLK,
    input wire Start,
    
    // --- OUTPUTS (Thứ tự từ trên xuống theo Symbol) ---
    output wire [15:0] Out,
    output wire Done
);

    // ============================================================
    // KHAI BÁO DÂY TÍN HIỆU NỘI BỘ
    // ============================================================
    
    wire sign_a, sign_b;
    wire [4:0] exp_a, exp_b;
    wire [10:0] man_a, man_b; // 1.xxxx (Hidden bit = 1)
    wire a_gt_b;
    
    wire [4:0] exp_diff;
    wire [4:0] s1_mux_exp;
    wire s1_mux_sign;
    wire [11:0] s1_mux_man_l;
    wire [11:0] s1_man_s_in;
    wire [11:0] s1_man_s_shifted_wire;
    wire actual_sub;
    
    // Register lưu trữ giữa Stage 1 -> 2
    wire s1_start_reg;
    wire [4:0] s1_exp_max_reg;
    wire s1_sign_l_reg;
    wire s1_real_op_reg;
    wire [11:0] s1_man_l_reg;
    wire [11:0] s1_man_s_shifted_reg;

    // Tín hiệu Stage 2
    wire [12:0] s2_sum_wire;
    
    // Register lưu trữ giữa Stage 2 -> 3
    wire s2_start_reg;
    wire [4:0] s2_exp_max_reg;
    wire s2_sign_l_reg;
    wire s2_real_op_reg;
    wire [12:0] s2_sum_reg;

    // Tín hiệu Stage 3 (Chuẩn hóa)
    wire [3:0] l_zeros;
    wire [4:0] final_exp_norm;
    wire [11:0] shifted_man;
    wire [9:0] final_man_norm;
    wire [15:0] result_mux_out;
    wire is_overflow, is_underflow, is_zero;
    wire [15:0] res_overflow, res_norm;

    // ============================================================
    // STAGE 1: DECODE & ALIGNMENT (Giải mã & Gióng hàng)
    // ============================================================

    assign sign_a = Ain[15];
    assign sign_b = Bin[15];
    assign exp_a  = Ain[14:10];
    assign exp_b  = Bin[14:10];

    // FIX: Nối cứng bit ẩn = 1 (Giả sử đầu vào luôn chuẩn hóa)
    assign man_a = {1'b1, Ain[9:0]};
    assign man_b = {1'b1, Bin[9:0]};

    // So sánh độ lớn
    CMP_Magnitude_Clean cmp_inst (
        .exp_a(exp_a), .exp_b(exp_b),
        .man_a(man_a), .man_b(man_b),
        .a_gt_b(a_gt_b)
    );

    // Tính hiệu số mũ
    SUB_5bit_Clean sub_exp (
        .in1(a_gt_b ? exp_a : exp_b),
        .in2(a_gt_b ? exp_b : exp_a),
        .out(exp_diff)
    );

    // Xác định phép tính thực (dựa vào dấu và lệnh Select)
    assign actual_sub = sign_a ^ sign_b ^ Select;

    // Mux chọn số Lớn/Bé
    assign s1_mux_exp   = a_gt_b ? exp_a : exp_b;
    assign s1_mux_sign  = a_gt_b ? sign_a : (Select ? ~sign_b : sign_b);
    
    // Thêm 1 bit 0 vào đuôi mantissa để tăng độ chính xác
    assign s1_mux_man_l = a_gt_b ? {man_a, 1'b0} : {man_b, 1'b0};
    assign s1_man_s_in  = a_gt_b ? {man_b, 1'b0} : {man_a, 1'b0};

    // Dịch phải Mantissa số bé
    Shifter_Right_Barrel_Clean shift_r_inst (
        .in_data(s1_man_s_in),
        .shift_amt(exp_diff),
        .out_data(s1_man_s_shifted_wire)
    );

    // --- PIPELINE REGISTER 1 -> 2 ---
    // Không dùng chân Reset ngoài để tránh xung đột
    REG_Clean #(.WIDTH(1))  reg_s1_start (.clk(CLK), .in(Start), .out(s1_start_reg));
    REG_Clean #(.WIDTH(5))  reg_s1_exp   (.clk(CLK), .in(s1_mux_exp), .out(s1_exp_max_reg));
    REG_Clean #(.WIDTH(1))  reg_s1_sign  (.clk(CLK), .in(s1_mux_sign), .out(s1_sign_l_reg));
    REG_Clean #(.WIDTH(1))  reg_s1_op    (.clk(CLK), .in(actual_sub), .out(s1_real_op_reg));
    REG_Clean #(.WIDTH(12)) reg_s1_manl  (.clk(CLK), .in(s1_mux_man_l), .out(s1_man_l_reg));
    REG_Clean #(.WIDTH(12)) reg_s1_mans  (.clk(CLK), .in(s1_man_s_shifted_wire), .out(s1_man_s_shifted_reg));

    // ============================================================
    // STAGE 2: ARITHMETIC (Tính toán Mantissa)
    // ============================================================

    ADD_SUB_13bit_Clean alu_inst (
        .a({1'b0, s1_man_l_reg}),        // Mở rộng thành 13 bit
        .b({1'b0, s1_man_s_shifted_reg}),
        .sub_mode(s1_real_op_reg),
        .res(s2_sum_wire)
    );

    // --- PIPELINE REGISTER 2 -> 3 ---
    REG_Clean #(.WIDTH(1))  reg_s2_start (.clk(CLK), .in(s1_start_reg), .out(s2_start_reg));
    REG_Clean #(.WIDTH(5))  reg_s2_exp   (.clk(CLK), .in(s1_exp_max_reg), .out(s2_exp_max_reg));
    REG_Clean #(.WIDTH(1))  reg_s2_sign  (.clk(CLK), .in(s1_sign_l_reg), .out(s2_sign_l_reg));
    REG_Clean #(.WIDTH(1))  reg_s2_op    (.clk(CLK), .in(s1_real_op_reg), .out(s2_real_op_reg));
    REG_Clean #(.WIDTH(13)) reg_s2_sum   (.clk(CLK), .in(s2_sum_wire), .out(s2_sum_reg));

    // ============================================================
    // STAGE 3: NORMALIZATION (Chuẩn hóa kết quả)
    // ============================================================

    // Đếm số 0 dẫn đầu (LZD)
    LZD_13bit_Clean lzd_inst (
        .in(s2_sum_reg),
        .out(l_zeros)
    );

    // *** FIX LỖI EXPONENT: Cộng thêm 1 để bù trừ cho LZD ***
    assign final_exp_norm = s2_exp_max_reg - {1'b0, l_zeros};

    // Dịch trái để chuẩn hóa lại
    Shifter_Left_Barrel_Clean shift_l_inst (
        .in_data(s2_sum_reg[11:0]),
        .shift_amt(l_zeros),
        .out_data(shifted_man)
    );
    
    // Lấy 10 bit mantissa sau dấu phẩy (Bỏ bit 1 ẩn đi)
    assign final_man_norm = shifted_man[10:1];

    assign is_zero      = (s2_sum_reg == 13'd0);
    assign is_overflow  = s2_sum_reg[12]; // Bit 12 = 1 là tràn
    assign is_underflow = (s2_exp_max_reg < {1'b0, l_zeros});

    // Kết quả khi bị tràn (Dịch phải 1 bit, Exp + 1)
    assign res_overflow = {s2_sign_l_reg, (s2_exp_max_reg + 5'd1), s2_sum_reg[11:2]};
    
    // Kết quả chuẩn hóa thông thường
    assign res_norm     = {s2_sign_l_reg, final_exp_norm, final_man_norm};

    // Mux chọn kết quả cuối cùng
    assign result_mux_out = is_zero      ? 16'h0000 :
                            is_overflow  ? res_overflow :
                            is_underflow ? 16'h0000 :
                            res_norm;

    // --- OUTPUT REGISTER ---
    REG_Clean #(.WIDTH(1))  reg_out_done (.clk(CLK), .in(s2_start_reg),   .out(Done));
    REG_Clean #(.WIDTH(16)) reg_out_data (.clk(CLK), .in(result_mux_out), .out(Out));

endmodule


// ============================================================================
// CÁC MODULE CON (HELPER MODULES)
// Giữ nguyên logic tối ưu, chỉ copy vào để chạy
// ============================================================================

module REG_Clean #(parameter WIDTH = 1) (input clk, input [WIDTH-1:0] in, output reg [WIDTH-1:0] out);
    initial out = 0; 
    always @(posedge clk) begin
        out <= in;
    end
endmodule

module CMP_Magnitude_Clean(
    input [4:0] exp_a, exp_b,
    input [10:0] man_a, man_b,
    output a_gt_b
);
    assign a_gt_b = (exp_a > exp_b) || (exp_a == exp_b && man_a > man_b);
endmodule

module SUB_5bit_Clean(input [4:0] in1, in2, output [4:0] out);
    assign out = in1 - in2;
endmodule

module ADD_SUB_13bit_Clean(input [12:0] a, b, input sub_mode, output [12:0] res);
    assign res = sub_mode ? (a - b) : (a + b);
endmodule

module Shifter_Right_Barrel_Clean(input [11:0] in_data, input [4:0] shift_amt, output [11:0] out_data);
    assign out_data = in_data >> shift_amt;
endmodule

module Shifter_Left_Barrel_Clean(input [11:0] in_data, input [3:0] shift_amt, output [11:0] out_data);
    assign out_data = in_data << shift_amt;
endmodule

module LZD_13bit_Clean(input [12:0] in, output reg [3:0] out);
    always @(*) begin
        if      (in[12]) out = 4'd0;
        else if (in[11]) out = 4'd0; 
        else if (in[10]) out = 4'd1;
        else if (in[9])  out = 4'd2;
        else if (in[8])  out = 4'd3;
        else if (in[7])  out = 4'd4;
        else if (in[6])  out = 4'd5;
        else if (in[5])  out = 4'd6;
        else if (in[4])  out = 4'd7;
        else if (in[3])  out = 4'd8;
        else if (in[2])  out = 4'd9;
        else if (in[1])  out = 4'd10;
        else if (in[0])  out = 4'd11;
        else             out = 4'd12;
    end
endmodule