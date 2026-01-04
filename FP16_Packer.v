module FP16_Packer (
    input wire        Final_Sign, // Bit dấu (1 bit)
    input wire [4:0]  Final_Exp,  // Số mũ đã chuẩn hóa (5 bit)
    input wire [9:0]  Final_Man,  // Phân số đã chuẩn hóa [14:5] (10 bit)
    output wire [15:0] Out_FP16    // Kết quả FP16 hoàn chỉnh
);

    // Ghép các thành phần theo đúng thứ tự chuẩn IEEE 754
    assign Out_FP16 = {Final_Sign, Final_Exp, Final_Man};

endmodule