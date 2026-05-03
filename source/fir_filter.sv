`timescale 1ns / 10ps

module fir_filter (input clk, n_rst,
                   input [15:0] sample_data, fir_coefficient,
                   input load_coeff, data_ready,
                   output one_k_samples, modwait,
                   output [15:0] fir_out,
                   output err);

    logic cnt_up_m, clear_m;
    logic [2:0] op_m;
    logic [3:0] src1_m, src2_m, dest_m;
    logic overflow_m;
    logic [16:0] outreg_data_m;

    // sync_high dr_sync(.clk(clk), .n_rst(n_rst), .async_in(data_ready),
    //                     .sync_out(dr_m));
    // sync_high lc_sync(.clk(clk), .n_rst(n_rst), .async_in(load_coeff),
    //                     .sync_out(lc_m));

    controller cu (.clk(clk), .n_rst(n_rst), .dr(data_ready), .lc(load_coeff),
                   .modwait(modwait), .err(err), .cnt_up(cnt_up_m), .clear(clear_m),
                   .op(op_m), .src1(src1_m), .src2(src2_m), .dest(dest_m), .overflow(overflow_m));

    counter cnt (.clk(clk), .n_rst(n_rst), .cnt_up(cnt_up_m), .clear(clear_m), .one_k_samples(one_k_samples));

    datapath dp (.clk(clk), .n_reset(n_rst), .op(op_m), .src1(src1_m), .src2(src2_m),
                 .dest(dest_m), .ext_data1(sample_data), .ext_data2(fir_coefficient),
                 .outreg_data(outreg_data_m), .overflow(overflow_m));
    
    magnitude mg(.in(outreg_data_m), .out(fir_out));

endmodule

