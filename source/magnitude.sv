`timescale 1ns / 10ps

module magnitude (input logic signed [16:0] in, output logic [15:0] out);

    always_comb begin 
        if (in < 0)
            out = -in;
        else 
            out = in;
    end

endmodule

