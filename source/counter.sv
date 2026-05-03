`timescale 1ns / 10ps

module counter (input clk, n_rst, cnt_up, clear,
                output one_k_samples);

    localparam NUM_OF_SAMPLES = 10'd1000;

    flex_counter #(.SIZE(10)) cnt (.clk(clk), .n_rst(n_rst), .clear(clear),
                                   .count_enable(cnt_up), .rollover_val(NUM_OF_SAMPLES),
                                   .rollover_flag(one_k_samples));


endmodule

