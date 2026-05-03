`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_magnitude ();
    logic signed [16:0] in;
    logic [15:0] out;
    magnitude DUT(.in(in), .out(out));

    initial begin
        in = 17'sd546;
        #10;
        $display("in = %d, out = %d", in, out);
        in = -17'sd47;
        #10;
        $display("in = %d, out = %d", in, out);
        in = -17'sd1000;
        #10;
        $display("in = %d, out = %d", in, out);

        $finish;
    end
endmodule

/* verilator coverage_on */

