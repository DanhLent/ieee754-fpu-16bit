// IEEE 754 Half-Precision (16-bit) Floating Point Adder/Subtractor. 
// Copyright (c) 2026 Le Nguyen Thanh Danh 
// 2026-01-03

`default_nettype none
module addsub (
  input  wire        clk,
  input  wire        rst_n,
  input  wire        start,
  input  wire        opcode,   // 0:add, 1:sub (A + (-B))
  input  wire [15:0] in_a,
  input  wire [15:0] in_b,
  output reg  [15:0] out,
  output reg         done
);

  // FSM
  localparam [3:0] S_IDLE  = 4'd0;
  localparam [3:0] S_DEC   = 4'd1;
  localparam [3:0] S_ALIGN = 4'd2;
  localparam [3:0] S_ADD   = 4'd3;
  localparam [3:0] S_NORM  = 4'd4;
  localparam [3:0] S_PACK  = 4'd5;
  localparam [3:0] S_DONE  = 4'd6;

  reg [3:0]  state;
  reg        opcode_r;
  reg [15:0] a_r, b_r;

  // Field extraction
  wire        sign_a_w = a_r[15];
  wire [4:0]  exp_a_w  = a_r[14:10];
  wire [9:0]  frac_a_w = a_r[9:0];
  wire        sign_b_w = b_r[15];
  wire [4:0]  exp_b_w  = b_r[14:10];
  wire [9:0]  frac_b_w = b_r[9:0];

  wire        sign_b_eff_w = sign_b_w ^ opcode_r;         // effective sign of B
  wire        a_zero_w     = (a_r[14:0] == 15'h0000);
  wire        b_zero_w     = (b_r[14:0] == 15'h0000);
  wire        a_inf_w      = (exp_a_w == 5'h1F) && (frac_a_w == 10'h000);
  wire        b_inf_w      = (exp_b_w == 5'h1F) && (frac_b_w == 10'h000);
  wire        a_nan_w      = (exp_a_w == 5'h1F) && (frac_a_w != 10'h000);
  wire        b_nan_w      = (exp_b_w == 5'h1F) && (frac_b_w != 10'h000);

  // exp_adj = max(1, E) (6-bit headroom)
  wire [5:0] exp_a_adj_w = (exp_a_w == 5'h00) ? 6'd1 : {1'b0, exp_a_w};
  wire [5:0] exp_b_adj_w = (exp_b_w == 5'h00) ? 6'd1 : {1'b0, exp_b_w};

  // mantissa(11) with implicit 1 for normals
  wire [10:0] man_a_11_w = {(exp_a_w != 5'h00), frac_a_w};
  wire [10:0] man_b_11_w = {(exp_b_w != 5'h00), frac_b_w};

  wire        same_sign_w = (sign_a_w == sign_b_eff_w);

  // compare |A| vs |B| on (exp_adj, mant)
  wire        a_ge_b_mag_w =
    (exp_a_adj_w > exp_b_adj_w) ? 1'b1 :
    (exp_a_adj_w < exp_b_adj_w) ? 1'b0 :
    (man_a_11_w >= man_b_11_w);

  // Working regs
  reg        same_sign;
  reg        sign_large, sign_small;
  reg [5:0]  exp_large, exp_small;
  reg [13:0] man_large, man_small;
  reg        sign_res;
  reg [5:0]  exp_work;
  reg [14:0] man_work;

  // FSM
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state      <= S_IDLE;
      opcode_r   <= 1'b0;
      a_r        <= 16'h0000;
      b_r        <= 16'h0000;
      out        <= 16'h0000;
      done       <= 1'b0;
      same_sign  <= 1'b0;
      sign_large <= 1'b0;
      sign_small <= 1'b0;
      exp_large  <= 6'd1;
      exp_small  <= 6'd1;
      man_large  <= 14'd0;
      man_small  <= 14'd0;
      sign_res   <= 1'b0;
      exp_work   <= 6'd1;
      man_work   <= 15'd0;
    end else begin
      done <= 1'b0;
      case (state)
        S_IDLE: begin
          if (start) begin
            opcode_r <= opcode;
            a_r      <= in_a;
            b_r      <= in_b;
            state    <= S_DEC;
          end
        end

        // specials (NaN/Inf/Zero); else classify large/small
        S_DEC: begin
          if (a_nan_w) begin
            out   <= {1'b0, 5'h1F, (frac_a_w | 10'h200)}; // qNaN
            state <= S_DONE;
          end else if (b_nan_w) begin
            out   <= {1'b0, 5'h1F, (frac_b_w | 10'h200)}; // qNaN
            state <= S_DONE;
          end else if (a_inf_w && b_inf_w) begin
            if (sign_a_w == sign_b_eff_w) out <= {sign_a_w, 5'h1F, 10'h000};
            else                           out <= 16'h7E00;                  // qNaN
            state <= S_DONE;
          end else if (a_inf_w) begin
            out   <= {sign_a_w, 5'h1F, 10'h000};
            state <= S_DONE;
          end else if (b_inf_w) begin
            out   <= {sign_b_eff_w, 5'h1F, 10'h000};
            state <= S_DONE;
          end else if (a_zero_w && b_zero_w) begin
            out   <= (sign_a_w == sign_b_eff_w) ? {sign_a_w, 5'h00, 10'h000} : 16'h0000;
            state <= S_DONE;
          end else if (a_zero_w) begin
            out   <= {sign_b_eff_w, exp_b_w, frac_b_w};
            state <= S_DONE;
          end else if (b_zero_w) begin
            out   <= {sign_a_w, exp_a_w, frac_a_w};
            state <= S_DONE;
          end else begin
            same_sign <= same_sign_w;
            if (a_ge_b_mag_w) begin
              sign_large <= sign_a_w;      sign_small <= sign_b_eff_w;
              exp_large  <= exp_a_adj_w;   exp_small  <= exp_b_adj_w;
              man_large  <= {man_a_11_w, 3'b000};
              man_small  <= {man_b_11_w, 3'b000};
            end else begin
              sign_large <= sign_b_eff_w;  sign_small <= sign_a_w;
              exp_large  <= exp_b_adj_w;   exp_small  <= exp_a_adj_w;
              man_large  <= {man_b_11_w, 3'b000};
              man_small  <= {man_a_11_w, 3'b000};
            end
            state <= S_ALIGN;
          end
        end

        // align exponents; when equal -> S_ADD
        S_ALIGN: begin
          if (exp_small < exp_large) begin
            man_small <= {1'b0, man_small[13:1]};
            exp_small <= exp_small + 6'd1;
          end else begin
            exp_work <= exp_large;
            sign_res <= sign_large;
            state    <= S_ADD;
          end
        end

        // mantissa add/sub
        S_ADD: begin
          if (same_sign) man_work <= {1'b0, man_large} + {1'b0, man_small};
          else           man_work <= {1'b0, man_large} - {1'b0, man_small};
          state <= S_NORM;
        end

        // normalize (carry/leading-1)
        S_NORM: begin
          if (man_work == 15'd0) begin
            out   <= 16'h0000;
            state <= S_DONE;
          end else if (man_work[14]) begin
            man_work <= {1'b0, man_work[14:1]};
            exp_work <= exp_work + 6'd1;
          end else if (!man_work[13] && (exp_work > 6'd1)) begin
            man_work <= {man_work[13:0], 1'b0};
            exp_work <= exp_work - 6'd1;
          end else begin
            state <= S_PACK;
          end
        end

        // pack (truncate [12:3])
        S_PACK: begin
          if (exp_work >= 6'd31) begin
            out   <= {sign_res, 5'h1F, 10'h000}; // overflow -> Inf
            state <= S_DONE;
          end else if (man_work[13:0] == 14'd0) begin
            out   <= 16'h0000;
            state <= S_DONE;
          end else begin
            if ((exp_work == 6'd1) && (man_work[13] == 1'b0))
              out <= {sign_res, 5'h00, man_work[12:3]};         // subnormal
            else
              out <= {sign_res, exp_work[4:0], man_work[12:3]}; // normal
            state <= S_DONE;
          end
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

