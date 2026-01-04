// Module nay nhan 16-bit binary tu FPU va xuat ra 4 LED 7 doan tren DE2
module FPU_Display_Module (
    input  [15:0] bin_in,
    output [6:0]  hex0_out,
    output [6:0]  hex1_out,
    output [6:0]  hex2_out,
    output [6:0]  hex3_out   
);


    
    decode_7seg d0 (.digit(bin_in[3:0]),   .seg(hex0_out));
    decode_7seg d1 (.digit(bin_in[7:4]),   .seg(hex1_out));
    decode_7seg d2 (.digit(bin_in[11:8]),  .seg(hex2_out));
    decode_7seg d3 (.digit(bin_in[15:12]), .seg(hex3_out));

endmodule


module decode_7seg (
    input  [3:0] digit,
    output reg [6:0] seg
);
    always @(*) begin
        case (digit)
            4'h0: seg = 7'b1000000; // So 0
            4'h1: seg = 7'b1111001; // So 1
            4'h2: seg = 7'b0100100; // So 2
            4'h3: seg = 7'b0110000; // So 3
            4'h4: seg = 7'b0011001; // So 4
            4'h5: seg = 7'b0010010; // So 5
            4'h6: seg = 7'b0000010; // So 6
            4'h7: seg = 7'b1111000; // So 7
            4'h8: seg = 7'b0000000; // So 8
            4'h9: seg = 7'b0010000; // So 9
            4'hA: seg = 7'b0001000; // Chu A
            4'hB: seg = 7'b0000011; // Chu b
            4'hC: seg = 7'b1000110; // Chu C
            4'hD: seg = 7'b0100001; // Chu d
            4'hE: seg = 7'b0000110; // Chu E
            4'hF: seg = 7'b0001110; // Chu F
            default: seg = 7'b1111111; // Tat het
        endcase
    end
endmodule