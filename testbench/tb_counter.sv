`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_counter ();

    localparam CLK_PERIOD = 10ns;

    logic clk, n_rst;
    logic cnt_up, clear, one_k_samples;

    counter DUT(.clk(clk), .n_rst(n_rst), .cnt_up(cnt_up), .clear(clear), .one_k_samples(one_k_samples));
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

    string count;
    integer i;

    initial begin
        n_rst = 0;
        @(negedge clk);

        n_rst = 1;
        clear = 0;
        cnt_up = 0;
        @(negedge clk);
        @(negedge clk);

        for(i = 0; i <= 1100; i++) begin
            cnt_up = 1;
            @(negedge clk);
            cnt_up = 0;
            @(negedge clk);

        end
        for(i = 0; i <= 100; i++) begin
            cnt_up = 1;
            @(negedge clk);
            cnt_up = 0;
            @(negedge clk);

            if(i == 40) begin
                clear = 1;
                @(negedge clk);
                clear = 0;
            end

        end




        $finish;
    end
endmodule

/* verilator coverage_on */

