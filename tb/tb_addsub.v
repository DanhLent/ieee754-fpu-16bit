/*
 * testbench for FP16 add/sub
 * Vector format: <A_hex> <B_hex> <op_dec> <expected_hex>
 */ 

`define TB_PROGRESS
`timescale 1ns/1ps

module tb_addsub;

    localparam integer CLK_PERIOD      = 10;
    localparam integer DATA_WIDTH      = 16;
    localparam integer TIMEOUT_CYCLES  = 200;
    localparam         FILE_NAME       = "test_vectors.txt";

    reg                   clk;
    reg                   rst_n;
    reg  [DATA_WIDTH-1:0] in_a;
    reg  [DATA_WIDTH-1:0] in_b;
    reg                   opcode;
    reg                   start;

    wire [DATA_WIDTH-1:0] out;
    wire                  done;

    integer               file_handle;
    integer               scan_status;
    reg [DATA_WIDTH-1:0]  file_a, file_b, file_exp;
    integer               file_op;

    integer               total_tests;
    integer               pass_count;
    integer               fail_count;
    
    reg                   is_match;

`ifdef TB_PROGRESS
    localparam integer PROGRESS_EVERY = 1000;
`endif

    addsub uut (
        .clk    (clk),
        .rst_n  (rst_n),
        .in_a   (in_a),
        .in_b   (in_b),
        .opcode (opcode),
        .start  (start),
        .out    (out),
        .done   (done)
    );

    initial clk = 1'b0;
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin
        rst_n       = 1'b0;
        start       = 1'b0;
        in_a        = {DATA_WIDTH{1'b0}};
        in_b        = {DATA_WIDTH{1'b0}};
        opcode      = 1'b0;
        total_tests = 0;
        pass_count  = 0;
        fail_count  = 0;

        file_handle = $fopen(FILE_NAME, "r");
        if (file_handle == 0) begin
            $display("FATAL ERROR: Cannot open '%s'", FILE_NAME);
            $finish;
        end

        repeat(3) @(posedge clk);
        rst_n = 1'b1;
        repeat(2) @(posedge clk);

        while (!$feof(file_handle)) begin
            scan_status = $fscanf(file_handle, "%h %h %d %h\n", file_a, file_b, file_op, file_exp);
            
            if (scan_status == 4) begin
                total_tests = total_tests + 1;

                drive_stimulus(file_a, file_b, file_op[0]);
                wait_for_done_with_timeout();
                check_result(file_a, file_b, file_op[0], file_exp, out, is_match);
                
                if (is_match)
                    pass_count = pass_count + 1;
                else
                    fail_count = fail_count + 1;

`ifdef TB_PROGRESS
                if ((total_tests % PROGRESS_EVERY) == 0) begin
                    $display("[INFO] Processed %0d tests...", total_tests);
                end
`endif
            end
        end

        $fclose(file_handle);

        $display("SUMMARY: Total=%0d | Pass=%0d | Fail=%0d", total_tests, pass_count, fail_count);
        
        if (fail_count == 0 && total_tests > 0) 
            $display("RESULT: SUCCESS");
        else 
            $display("RESULT: FAILED");

        $finish;
    end

    task drive_stimulus;
        input [DATA_WIDTH-1:0] a;
        input [DATA_WIDTH-1:0] b;
        input op;
        begin
            @(posedge clk);
            in_a   <= a;
            in_b   <= b;
            opcode <= op;
            start  <= 1'b1;
            @(posedge clk);
            start  <= 1'b0;
        end
    endtask

    task wait_for_done_with_timeout;
        integer loop_cnt;
        begin
            loop_cnt = 0;
            while (done == 0 && loop_cnt < TIMEOUT_CYCLES) begin
                @(posedge clk);
                loop_cnt = loop_cnt + 1;
            end

            if (done == 0) begin
                $display("[TIMEOUT] Test #%0d: 'done' signal never asserted!", total_tests);
                $finish;
            end
            
            @(posedge clk);
        end
    endtask

    task check_result;
        input [15:0] a;
        input [15:0] b;
        input        op;
        input [15:0] expected;
        input [15:0] actual;
        output       matched;
        
        reg exp_nan;
        reg act_nan;
        reg [15:0] diff;
        begin
            exp_nan = (expected[14:10] == 5'h1F) && (expected[9:0] != 0);
            act_nan = (actual[14:10]   == 5'h1F) && (actual[9:0]   != 0);

            if (exp_nan) begin
                if (act_nan) begin
                    matched = 1'b1;
                end else begin
                    $display("[FAIL-NaN] #%0d Op=%0d A=%h B=%h | Exp=NaN | Got=%h", total_tests, op, a, b, actual);
                    matched = 1'b0;
                end
            end 
            else begin
                if (expected >= actual)
                    diff = expected - actual;
                else
                    diff = actual - expected;

                if (diff <= 1) begin
                    matched = 1'b1;
                end else begin
                    $display("[FAIL] #%0d Op=%0d A=%h B=%h | Exp=%h | Got=%h | Diff=%0d", total_tests, op, a, b, expected, actual, diff);
                    matched = 1'b0;
                end
            end
        end
    endtask

endmodule