`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_controller ();

    string state;

    localparam CLK_PERIOD = 10ns;

    logic clk, n_rst, dr, lc, overflow, cnt_up, clear, modwait, err;
    logic [2:0] op;
    logic [3:0] src1, src2, dest;

    controller DUT(.clk(clk), .n_rst(n_rst), .dr(dr), .lc(lc), .overflow(overflow), .cnt_up(cnt_up),
                    .clear(clear), .modwait(modwait), .op(op), .src1(src1), .src2(src2), .dest(dest), .err(err));

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    initial begin
        n_rst = 0;
        @(negedge clk);
        @(negedge clk);


        state = "IDLE";
        n_rst = 1;
        dr = 0;
        lc = 0;
        overflow = 0;
        @(negedge clk);
        @(negedge clk);

        state = "LOAD_F0";
        lc = 1;
        @(negedge clk);

        state = "WAIT_F1";
        lc = 0;

        @(negedge clk);
        @(negedge clk);

        state = "LOAD_F1";
        lc = 1;
        @(negedge clk);

        state = "WAIT_F2";
        lc = 0;

        @(negedge clk);
        @(negedge clk);

        state = "LOAD_F2";
        lc = 1;
        @(negedge clk);

        state = "WAIT_F3";
        lc = 0;

        @(negedge clk);
        @(negedge clk);

        state = "LOAD_F3";
        lc = 1;
        @(negedge clk);

        state = "IDLE";
        lc = 0;

        @(negedge clk);
        @(negedge clk);

        state = "IDLE";
        dr = 1;
        @(negedge clk);

        state = "LOAD_SAMPLE";
        @(negedge clk);

        state = "SHIFT_D2";
        @(negedge clk);
        
        state = "SHIFT_D1";
        dr = 0;
        @(negedge clk);

        state = "SHIFT_D0";
        @(negedge clk);

        
        state = "COPY_SAMPLE";
        @(negedge clk);
        
        state = "MUL0";
        @(negedge clk);

        state = "ADD0";
        @(negedge clk);

        state = "MUL1";
        @(negedge clk);

        state = "ADD1";
        @(negedge clk);

        state = "MUL2";
        @(negedge clk);

        state = "ADD2";
        @(negedge clk);

        state = "MUL3";
        @(negedge clk);

        state = "ADD3";
        @(negedge clk);

        state = "IDLE";
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);


        state = "IDLE";
        dr = 1;
        @(negedge clk);
        
        state = "LOAD_SAMPLE";
        @(negedge clk);

        state = "SHIFT_D2";
        dr = 0;
        @(negedge clk);

        state = "SHIFT_D1";
        @(negedge clk);

        state = "SHIFT_D0";
        @(negedge clk);

        
        state = "COPY_SAMPLE";
        @(negedge clk);
        
        state = "MUL0";
        @(negedge clk);

        state = "ADD0";
        overflow = 1;
        @(negedge clk);

        state = "ERROR";
        @(negedge clk);
        @(negedge clk);
        
        dr = 1;
        overflow = 0;
        state = "SHIFT_D2";
        @(negedge clk);
        state = "SHIFT_D1";
        dr = 0;
        @(negedge clk);

        n_rst = 0;
        state = "IDLE";
        @(negedge clk);
        @(negedge clk);

        dr = 1;
        n_rst = 1;
        state = "LOAD_SAMPLE";
        @(negedge clk);

        dr = 0;
        state = "ERROR";
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        
        lc = 1;
        state = "LOAD_F0";
        @(negedge clk);

        n_rst = 1;
        state = "IDLE";
        @(negedge clk);







        






        $finish;
    end
endmodule

/* verilator coverage_on */

