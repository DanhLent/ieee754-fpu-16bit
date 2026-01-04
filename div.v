// IEEE 754 Half-Precision (16-bit) Floating Point Divider.
// Copyright (c) 2026 Le Nguyen Thanh Danh
// 2026-01-04

`default_nettype none

module div (
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
    localparam [2:0] S_DONE = 3'd5;

    reg [2:0]  state;

    reg [15:0] a_r, b_r;

    reg        sign_res;
    reg signed [6:0] exp_work;

    reg [11:0] reg_div;
    reg [21:0] reg_quo;
    reg [11:0] reg_rem;

    reg [4:0]  iter_cnt;

    reg [11:0] rem_shift;
    reg [21:0] quo_shift;
    reg [11:0] rem_next;
    reg [21:0] quo_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S_IDLE;
            out      <= 16'h0000;
            done     <= 1'b0;

            a_r      <= 16'h0000;
            b_r      <= 16'h0000;

            sign_res <= 1'b0;
            exp_work <= 7'sd0;

            reg_div  <= 12'd0;
            reg_quo  <= 22'd0;
            reg_rem  <= 12'd0;

            iter_cnt <= 5'd0;

            rem_shift <= 12'd0;
            quo_shift <= 22'd0;
            rem_next  <= 12'd0;
            quo_next  <= 22'd0;
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
                        reg [10:0] man_a, man_b;

                        sa = a_r[15];
                        sb = b_r[15];
                        ea = a_r[14:10];
                        eb = b_r[14:10];
                        fa = a_r[9:0];
                        fb = b_r[9:0];

                        a_zero = (ea == 5'h00) && (fa == 10'h000);
                        b_zero = (eb == 5'h00) && (fb == 10'h000);

                        a_inf  = (ea == 5'h1F) && (fa == 10'h000);
                        b_inf  = (eb == 5'h1F) && (fb == 10'h000);

                        a_nan  = (ea == 5'h1F) && (fa != 10'h000);
                        b_nan  = (eb == 5'h1F) && (fb != 10'h000);

                        sign_res <= sa ^ sb;

                        if (a_nan || b_nan) begin
                            out   <= 16'h7E00;
                            state <= S_DONE;
                        end else if ((a_zero && b_zero) || (a_inf && b_inf)) begin
                            out   <= 16'h7E00;
                            state <= S_DONE;
                        end else if (b_zero) begin
                            out   <= {(sa ^ sb), 5'h1F, 10'h000};
                            state <= S_DONE;
                        end else if (a_zero) begin
                            out   <= {(sa ^ sb), 5'h00, 10'h000};
                            state <= S_DONE;
                        end else if (a_inf) begin
                            out   <= {(sa ^ sb), 5'h1F, 10'h000};
                            state <= S_DONE;
                        end else if (b_inf) begin
                            out   <= {(sa ^ sb), 5'h00, 10'h000};
                            state <= S_DONE;
                        end else begin
                            ea_adj = (ea == 5'h00) ? 6'd1 : {1'b0, ea};
                            eb_adj = (eb == 5'h00) ? 6'd1 : {1'b0, eb};

                            man_a  = {(ea != 5'h00), fa};
                            man_b  = {(eb != 5'h00), fb};

                            reg_div <= {1'b0, man_b};
                            reg_rem <= 12'd0;
                            reg_quo <= {man_a, 11'd0};

                            exp_work <= $signed({1'b0, ea_adj}) - $signed({1'b0, eb_adj}) + 7'sd15;

                            iter_cnt <= 5'd14;
                            state <= S_CALC;
                        end
                    end
                end

                S_CALC: begin
                    if (iter_cnt == 5'd0) begin
                        state <= S_NORM;
                    end else begin
                        rem_shift = {reg_rem[10:0], reg_quo[21]};
                        quo_shift = {reg_quo[20:0], 1'b0};

                        if (rem_shift >= reg_div) begin
                            rem_next = rem_shift - reg_div;
                            quo_next = {quo_shift[21:1], 1'b1};
                        end else begin
                            rem_next = rem_shift;
                            quo_next = quo_shift;
                        end

                        reg_rem  <= rem_next;
                        reg_quo  <= quo_next;
                        iter_cnt <= iter_cnt - 5'd1;
                        state    <= S_CALC;
                    end
                end

                S_NORM: begin
                    if (reg_quo[14]) begin
                        reg_quo  <= reg_quo >> 1;
                        exp_work <= exp_work + 7'sd1;
                    end else if (!reg_quo[13]) begin
                        reg_quo  <= reg_quo << 1;
                        exp_work <= exp_work - 7'sd1;
                    end
                    state <= S_PACK;
                end

                S_PACK: begin
                    if (exp_work >= 7'sd31) begin
                        out <= {sign_res, 5'h1F, 10'h000};
                    end else if (exp_work <= 7'sd0) begin
                        out <= {sign_res, 5'h00, 10'h000};
                    end else begin
                        out <= {sign_res, exp_work[4:0], reg_quo[12:3]};
                    end
                    state <= S_DONE;
                end

                S_DONE: begin
                    done  <= 1'b1;
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule

`default_nettype wire
