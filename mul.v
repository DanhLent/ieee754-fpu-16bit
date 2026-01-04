// IEEE 754 Half-Precision (16-bit) Floating Point Multiplier.
// Copyright (c) 2026 Le Nguyen Thanh Danh
// 2026-01-04

`default_nettype none

module mul (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] in_a,
    input  wire [15:0] in_b,
    output reg  [15:0] out,
    output reg         done
);

    localparam [2:0] S_IDLE = 3'd0;
    localparam [2:0] S_INIT = 3'd1;
    localparam [2:0] S_CALC = 3'd2;
    localparam [2:0] S_NORM = 3'd3;
    localparam [2:0] S_PACK = 3'd4;
    localparam [2:0] S_SUBN = 3'd5;
    localparam [2:0] S_DONE = 3'd6;

    reg [2:0]  state;

    reg [15:0] a_r, b_r;

    reg        sign_res;

    reg [21:0] reg_a;
    reg [10:0] reg_b;
    reg [21:0] reg_prod;

    reg [3:0]  iter_left;

    reg signed [6:0] exp_acc;
    reg signed [6:0] exp_final;

    reg [10:0] man_norm11;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= S_IDLE;
            out       <= 16'h0000;
            done      <= 1'b0;

            a_r       <= 16'h0000;
            b_r       <= 16'h0000;

            sign_res  <= 1'b0;

            reg_a     <= 22'd0;
            reg_b     <= 11'd0;
            reg_prod  <= 22'd0;

            iter_left <= 4'd0;

            exp_acc   <= 7'sd0;
            exp_final <= 7'sd0;

            man_norm11 <= 11'd0;
        end else begin
            done <= 1'b0;

            case (state)
                S_IDLE: begin
                    if (start) begin
                        a_r   <= in_a;
                        b_r   <= in_b;
                        state <= S_INIT;
                    end
                end

                S_INIT: begin
                    begin : init_locals
                        reg        sa, sb;
                        reg [4:0]  ea, eb;
                        reg [9:0]  fa, fb;

                        reg        a_zero, b_zero;
                        reg        a_inf,  b_inf;
                        reg        a_nan,  b_nan;

                        reg [5:0]  ea_adj, eb_adj;
                        reg [10:0] ma, mb;

                        sa = a_r[15];
                        sb = b_r[15];
                        ea = a_r[14:10];
                        eb = b_r[14:10];
                        fa = a_r[9:0];
                        fb = b_r[9:0];

                        sign_res <= sa ^ sb;

                        a_zero = (a_r[14:0] == 15'h0000);
                        b_zero = (b_r[14:0] == 15'h0000);

                        a_inf  = (ea == 5'h1F) && (fa == 10'h000);
                        b_inf  = (eb == 5'h1F) && (fb == 10'h000);

                        a_nan  = (ea == 5'h1F) && (fa != 10'h000);
                        b_nan  = (eb == 5'h1F) && (fb != 10'h000);

                        ea_adj = (ea == 5'h00) ? 6'd1 : {1'b0, ea};
                        eb_adj = (eb == 5'h00) ? 6'd1 : {1'b0, eb};

                        ma = { (ea != 5'h00), fa };
                        mb = { (eb != 5'h00), fb };

                        if (a_nan || b_nan) begin
                            out   <= 16'h7E00;
                            state <= S_DONE;
                        end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                            out   <= 16'h7E00;
                            state <= S_DONE;
                        end else if (a_inf || b_inf) begin
                            out   <= { (sa ^ sb), 5'h1F, 10'h000 };
                            state <= S_DONE;
                        end else if (a_zero || b_zero) begin
                            out   <= { (sa ^ sb), 5'h00, 10'h000 };
                            state <= S_DONE;
                        end else begin
                            reg_a    <= {11'd0, ma};
                            reg_b    <= mb;
                            reg_prod <= 22'd0;

                            iter_left <= 4'd11;

                            exp_acc  <= $signed({1'b0, ea_adj}) + $signed({1'b0, eb_adj}) - 7'sd15;

                            state <= S_CALC;
                        end
                    end
                end

                S_CALC: begin
                    if (iter_left == 4'd0) begin
                        state <= S_NORM;
                    end else begin
                        if (reg_b[0]) begin
                            reg_prod <= reg_prod + reg_a;
                        end

                        reg_a <= reg_a << 1;
                        reg_b <= reg_b >> 1;

                        iter_left <= iter_left - 4'd1;
                        state <= S_CALC;
                    end
                end

                S_NORM: begin
                    if (reg_prod == 22'd0) begin
                        out   <= 16'h0000;
                        state <= S_DONE;
                    end else begin
                        if (reg_prod[21]) begin
                            man_norm11 <= reg_prod[21:11];
                            exp_final  <= exp_acc + 7'sd1;
                        end else begin
                            man_norm11 <= reg_prod[20:10];
                            exp_final  <= exp_acc;
                        end
                        state <= S_PACK;
                    end
                end

                S_PACK: begin
                    if (exp_final >= 7'sd31) begin
                        out   <= {sign_res, 5'h1F, 10'h000};
                        state <= S_DONE;
                    end else if (exp_final <= 7'sd0) begin
                        state <= S_SUBN;
                    end else begin
                        out   <= {sign_res, exp_final[4:0], man_norm11[9:0]};
                        state <= S_DONE;
                    end
                end

                S_SUBN: begin
                    if (man_norm11 == 11'd0) begin
                        out   <= 16'h0000;
                        state <= S_DONE;
                    end else if (exp_final < 7'sd1) begin
                        man_norm11 <= {1'b0, man_norm11[10:1]};
                        exp_final  <= exp_final + 7'sd1;
                        state <= S_SUBN;
                    end else begin
                        out   <= {sign_res, 5'h00, man_norm11[9:0]};
                        state <= S_DONE;
                    end
                end

                S_DONE: begin
                    done  <= 1'b1;
                    state <= S_IDLE;
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule

`default_nettype wire
