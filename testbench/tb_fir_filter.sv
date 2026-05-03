`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_fir_filter ();

    localparam CLK_PERIOD = 10ns;
    string status;
    integer i;

    logic clk, n_rst;
    logic [15:0] sample_data, fir_coefficient;
    logic load_coeff, data_ready;
    logic one_k_samples, modwait;
    logic [15:0] fir_out;
    logic err;

    fir_filter DUT(.clk(clk), .n_rst(n_rst), .sample_data(sample_data), .fir_coefficient(fir_coefficient),
                   .load_coeff(load_coeff), .data_ready(data_ready), .one_k_samples(one_k_samples), .modwait(modwait),
                   .fir_out(fir_out), .err(err));
    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task setup;
        status = "setup";
        @(negedge clk);

        n_rst = 0;
        sample_data = 16'd0;
        fir_coefficient = 16'd0;
        load_coeff = 0;
        data_ready = 0;
        #(CLK_PERIOD);


        n_rst = 1;
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        #(CLK_PERIOD);


    endtask

    task take_coeff;
        
        logic [15:0] coeff0, coeff1, coeff2, coeff3;

        coeff0 = 16'h8000;  // 1.0
        coeff1 = 16'h8000; // 0.25
        coeff2 = 16'h8000; // 1.5
        coeff3 = 16'h8000; // 0.125

        load_coeff = 1;
        fir_coefficient = coeff0;
        status = "coeff_0";
        #(CLK_PERIOD);
        load_coeff = 0;
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        #(CLK_PERIOD);

        load_coeff = 1;
        status = "coeff_1";
        fir_coefficient = coeff1;
        #(CLK_PERIOD);
        load_coeff = 0;
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        #(CLK_PERIOD);

        load_coeff = 1;
        status = "coeff_2";
        fir_coefficient = coeff2;
        #(CLK_PERIOD);
        load_coeff = 0;
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        #(CLK_PERIOD);

        load_coeff = 1;
        status = "coeff_3";
        fir_coefficient = coeff3;
        #(CLK_PERIOD);
        load_coeff = 0;
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        #(CLK_PERIOD);


    endtask

    task take_sample;
        input [16:0] data;
        input is_dr_err;

        data_ready = 1;
        sample_data = data;
        #(CLK_PERIOD);

        if(is_dr_err) begin
            data_ready = 0;
        end

        #(CLK_PERIOD);
        data_ready = 0;
        // for(i = 0; i < 13; i++)
        #(15 * CLK_PERIOD);

    endtask;

    initial begin
        
        setup;
        take_coeff;

        status = "sample 1";
        take_sample(16'h0001, 0);
        status = "sample 2";
        take_sample(16'h0005, 0);
        status = "sample 3";
        take_sample(16'h0007, 0);
        status = "sample 4";
        take_sample(16'h000F, 0);
        status = "error sample";
        take_sample(16'h0003, 1);
        status = "sample 5";
        take_sample(16'h0001, 0);


        

        $finish;
    end
endmodule

/* verilator coverage_on */

