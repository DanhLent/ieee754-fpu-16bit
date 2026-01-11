// IEEE 754 Half-Precision (16-bit) Floating Point Multiplier. 
// Copyright (c) 2026 Le Nguyen Thanh Danh 
// 2026-01-11

`default_nettype none
// mul_core: sequential shift-and-add core
module mul_core (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [10:0] man_a,
    input  wire [10:0] man_b,
    output reg  [21:0] product,
    output reg         done
);
    // FSM
    reg [1:0] state, next_state;
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    // Shift-and-add registers
    reg [21:0] reg_prod;  // accumulator
    reg [21:0] reg_a;     // multiplicand
    reg [10:0] reg_b;     // multiplier

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start) next_state = CALC;
            end
            CALC: begin
                // zero detect
                if (reg_b == 11'd0) next_state = DONE;
                else                next_state = CALC;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            done     <= 1'b0;
            product  <= 22'd0;
            reg_prod <= 22'd0;
            reg_a    <= 22'd0;
            reg_b    <= 11'd0;
        end else begin
            state <= next_state;
            done  <= 1'b0;

            case (state)
                IDLE: begin
                    if (start) begin
                        reg_prod <= 22'd0;
                        reg_a    <= {11'd0, man_a};
                        reg_b    <= man_b;
                    end
                end

                CALC: begin
                    if (reg_b != 11'd0) begin
                        if (reg_b[0]) reg_prod <= reg_prod + reg_a;
                        reg_a <= reg_a << 1;
                        reg_b <= reg_b >> 1;
                    end
                end

                DONE: begin
                    product <= reg_prod;
                    done    <= 1'b1;
                end

                default: ;
            endcase
        end
    end
endmodule

// mul: Multiplier top module
module mul (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] in_a,
    input  wire [15:0] in_b,
    output wire [15:0] out,
    output wire        done
);
    // Field extraction
    wire [15:0] a_r       = in_a;
    wire [15:0] b_r       = in_b;

    wire        sign_a_w  = a_r[15];
    wire [4:0]  exp_a_w   = a_r[14:10];
    wire [9:0]  frac_a_w  = a_r[9:0];

    wire        sign_b_w  = b_r[15];
    wire [4:0]  exp_b_w   = b_r[14:10];
    wire [9:0]  frac_b_w  = b_r[9:0];

    // specials: zero
    wire a_is_zero = (exp_a_w == 5'd0) && (frac_a_w == 10'd0);
    wire b_is_zero = (exp_b_w == 5'd0) && (frac_b_w == 10'd0);
    wire any_zero  = a_is_zero | b_is_zero;

    // sign & exponent
    wire        sign_final_w = sign_a_w ^ sign_b_w;
    wire [6:0]  exp_temp     = {2'b00, exp_a_w} + {2'b00, exp_b_w} - 7'd15;

    // mantissa inputs (hidden 1)
    wire [10:0] man_a_w = {1'b1, frac_a_w};
    wire [10:0] man_b_w = {1'b1, frac_b_w};

    // core instantiation
    wire [21:0] prod_w;
    wire        done_core_w;
    wire        start_core_w = start & ~any_zero;

    mul_core u_core (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (start_core_w),
        .man_a   (man_a_w),
        .man_b   (man_b_w),
        .product (prod_w),
        .done    (done_core_w)
    );

    // normalize
    wire        msb_overflow_w = prod_w[21];
    wire [9:0]  frac_hi_w      = prod_w[20:11];
    wire [9:0]  frac_lo_w      = prod_w[19:10];
    wire [9:0]  frac_norm_w    = msb_overflow_w ? frac_hi_w : frac_lo_w;

    wire [6:0]  exp_norm_wide  = msb_overflow_w ? (exp_temp + 7'd1) : exp_temp;
    wire [4:0]  exp_norm_w     = exp_norm_wide[4:0];

    // pack
    wire [15:0] out_nonzero_w  = {sign_final_w, exp_norm_w, frac_norm_w};
    wire [15:0] out_zero_w     = 16'h0000;

    assign done = any_zero ? 1'b1 : done_core_w;
    assign out  = any_zero ? out_zero_w : out_nonzero_w;
endmodule

`default_nettype wire
