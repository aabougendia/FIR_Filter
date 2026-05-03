`timescale 1ns / 10ps

module ahb_fir_filter (input clk, n_rst,
                       input logic hsel,
                       input logic [3:0] haddr,
                       input logic hsize,
                       input logic [1:0] htrans,
                       input logic hwrite,
                       input logic [15:0] hwdata,
                       output logic [15:0] hrdata,
                       output logic hresp);

    logic [15:0] fir_out_m;
    logic err_m;
    logic data_ready_m;
    logic [15:0] sample_data_m;
    logic modwait_m;
    logic new_coefficient_set_m;
    logic clear_coeff_m;
    logic load_coeff_m;
    logic [1:0] coefficient_num_m;
    logic [15:0] fir_coefficient_m;

    fir_filter fir (.clk(clk), .n_rst(n_rst), .sample_data(sample_data_m),
                    .fir_coefficient(fir_coefficient_m), .load_coeff(load_coeff_m), .data_ready(data_ready_m),
                    .modwait(modwait_m), .fir_out(fir_out_m), .err(err_m));

    ahb_subordinate sub (.clk(clk), .n_rst(n_rst), .clear_coeff(clear_coeff_m),
                         .coefficient_num(coefficient_num_m), .modwait(modwait_m), .fir_out(fir_out_m),
                         .err(err_m), .hsel(hsel), .haddr(haddr), .hsize(hsize), .htrans(htrans), .hwrite(hwrite), .hwdata(hwdata),
                         .sample_data(sample_data_m), .data_ready(data_ready_m), .new_coefficient_set(new_coefficient_set_m), .fir_coefficient(fir_coefficient_m), .hrdata(hrdata),
                         .hresp(hresp));

    coefficient_loader ldr (.clk(clk), .n_rst(n_rst), .new_coefficient_set(new_coefficient_set_m),
                            .modwait(modwait_m), .load_coeff(load_coeff_m), .coefficient_num(coefficient_num_m), .clear_coeff(clear_coeff_m));

endmodule

