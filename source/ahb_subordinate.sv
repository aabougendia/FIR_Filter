`timescale 1ns / 10ps

module ahb_subordinate (input clk, n_rst,
                        input logic clear_coeff,
                        input logic [1:0] coefficient_num,
                        input logic modwait,
                        input logic [15:0] fir_out,
                        input logic err,
                        input logic hsel,
                        input logic [3:0] haddr,
                        input logic hsize,
                        input logic [1:0] htrans,
                        input logic hwrite, 
                        input logic [15:0] hwdata,
                        output logic [15:0] sample_data,
                        output logic data_ready,
                        output logic new_coefficient_set,
                        output logic [15:0] fir_coefficient,
                        output logic [15:0] hrdata,
                        output logic hresp);


    logic hsel_reg;
    logic [3:0] haddr_reg;
    logic [1:0] htrans_reg;
    logic hsize_reg;
    logic hwrite_reg;

    logic [15:0] status_next, status_reg;
    logic [15:0] result_reg;
    logic [15:0] new_sample_next, new_sample_reg;
    logic [15:0] F0_next, F0_reg;
    logic [15:0] F1_next, F1_reg;
    logic [15:0] F2_next, F2_reg;
    logic [15:0] F3_next, F3_reg;
    logic [7:0] new_coeff_next, new_coeff_reg;

    logic data_ready_triggered;

    always_ff @(posedge clk, negedge n_rst) begin : REGISTERING_WRITE_LOGIC
        if(!n_rst) begin
            ///////////////// double check reset value
            hsel_reg <= '0;
            haddr_reg <= '0;
            htrans_reg <= '0;
            hsize_reg <= '0;
            hwrite_reg <= '0;
        end
        else begin
            hsel_reg <= hsel;
            haddr_reg <= haddr;
            htrans_reg <= htrans;
            hsize_reg <= hsize;
            hwrite_reg <= hwrite;
        end
    end

    always_ff @(posedge clk, negedge n_rst) begin : REGISTER_BANK
        if(!n_rst) begin
            ///////////////// double check reset value
            status_reg <= '0; //////////// check if they need to be registered
            result_reg <= '0; ///////////////
            new_sample_reg <= '0;
            F0_reg <= '0;
            F1_reg <= '0;
            F2_reg <= '0;
            F3_reg <= '0;
            new_coeff_reg <= '0;
        end
        else begin
            status_reg <= status_next; //////////// check if they need to be registered
            result_reg <= fir_out; ///////////////
            new_sample_reg <= new_sample_next;
            F0_reg <= F0_next;
            F1_reg <= F1_next;
            F2_reg <= F2_next;
            F3_reg <= F3_next;
            new_coeff_reg <= new_coeff_next;
        end
    end

    always_comb begin : ERROR_LOGIC
        hresp = 0;
        if (hsel) begin
            if (!hwrite) begin
                case (haddr)
                    4'hF: hresp = 1;
                endcase
            end
            else begin
                case (haddr)
                    4'h0, 4'h1, 4'h2, 4'h3, 4'hF: hresp = 1;
                endcase
            end
        end
    end

    always_comb begin : STATUS_LOGIC
        status_next = 16'd0;
        case ({err, modwait | new_coefficient_set})
            2'b00: status_next = 16'd0;
            2'b01: status_next = 16'd1;
            2'b10: status_next = 16'd256;
        endcase
    end

    always_comb begin : WRITE_LOGIC
        new_sample_next = new_sample_reg;
        F0_next = F0_reg;
        F1_next = F1_reg;
        F2_next = F2_reg;
        F3_next = F3_reg;
        new_coeff_next = new_coeff_reg;
        data_ready_triggered = 0;

        if (clear_coeff)
            new_coeff_next = 8'h00; ///////////////////////

        if (hsel_reg) begin
            if (htrans_reg == 2'b10) begin
                if (hwrite_reg) begin
                    if(!hsize_reg) begin
                        case (haddr_reg)
                            4'h4: begin 
                                new_sample_next[7:0] = hwdata[7:0];
                                data_ready_triggered = 1;
                            end
                            4'h5: begin
                                new_sample_next[15:8] = hwdata[15:8];
                                data_ready_triggered = 1;
                            end

                            4'h6: F0_next[7:0] = hwdata[7:0];
                            4'h7: F0_next[15:8] = hwdata[15:8];

                            4'h8: F1_next[7:0] = hwdata[7:0];
                            4'h9: F1_next[15:8] = hwdata[15:8];

                            4'hA: F2_next[7:0] = hwdata[7:0];
                            4'hB: F2_next[15:8] = hwdata[15:8];

                            4'hC: F3_next[7:0] = hwdata[7:0];
                            4'hD: F3_next[15:8] = hwdata[15:8]; 

                            4'hE: begin
                                if (!clear_coeff) ////////////////////////////////
                                    new_coeff_next = hwdata[7:0];
                            end

                        endcase
                    end
                    else begin
                        case (haddr_reg)
                            4'h4: begin 
                                new_sample_next = hwdata;
                                data_ready_triggered = 1;
                            end
                            4'h6: F0_next = hwdata;
                            4'h8: F1_next = hwdata;
                            4'hA: F2_next = hwdata;
                            4'hC: F3_next = hwdata;
                            4'hE: begin
                                if (!clear_coeff) ////////////////////////////////
                                    new_coeff_next = hwdata[7:0];
                            end
                        endcase
                    end
                end
            end
        end
    end

    ///////////////////////////////////////////////////////////
    logic dr_triggered1, dr_triggered2;


    always_ff @(posedge clk, negedge n_rst) begin : DATA_READY
        if(!n_rst) begin
            dr_triggered1 <= 0;
            dr_triggered2 <= 0;
        end
        else begin
            dr_triggered1 <= data_ready_triggered;
            dr_triggered2 <= dr_triggered1;
        end
    end


    // data_ready logic
    assign data_ready = dr_triggered1 | dr_triggered2;


    logic is_raw;
    logic [15:0] hrdata_next;

    always_ff @(posedge clk, negedge n_rst) begin : HRDATA_REGISTERING
        if(!n_rst) begin
            hrdata <= '0;
        end
        else begin
            hrdata <= hrdata_next;
        end
    end

    always_comb begin : READ_LOGIC
        sample_data = new_sample_reg;
        new_coefficient_set = new_coeff_reg;
        is_raw = (hwrite_reg) && (~hwrite) && ((hsize && ((haddr == haddr_reg) || (haddr + 1 == haddr_reg ))) || (~hsize && (haddr == haddr_reg)));
        hrdata_next = 16'h0000; /////////////////////////////

        if (hsel) begin
            if (htrans == 2'b10) begin
                if (!hwrite) begin
                    if (!hsize) begin
                        case (haddr)
                            4'h0: hrdata_next[7:0] = status_reg[7:0];
                            4'h1: hrdata_next[15:8] = result_reg[15:8];

                            4'h2: hrdata_next[7:0] = status_reg[7:0];
                            4'h3: hrdata_next[15:8] = result_reg[15:8];

                            4'h4: hrdata_next[7:0] = is_raw ? new_sample_next[7:0] : new_sample_reg[7:0];
                            4'h5: hrdata_next[15:8] = is_raw ? new_sample_next[15:8] : new_sample_reg[15:8];

                            4'h6: hrdata_next[7:0] = is_raw ? F0_next[7:0] : F0_reg[7:0];
                            4'h7: hrdata_next[15:8] = is_raw ? F0_next[15:8] : F0_reg[15:8];

                            4'h8: hrdata_next[7:0] = is_raw ? F1_next[7:0] : F1_reg[7:0];
                            4'h9: hrdata_next[15:8] = is_raw ? F1_next[15:8] : F1_reg[15:8];

                            4'hA: hrdata_next[7:0] = is_raw ? F2_next[7:0] : F2_reg[7:0];
                            4'hB: hrdata_next[15:8] = is_raw ? F2_next[15:8] : F2_reg[15:8];

                            4'hC: hrdata_next[7:0] = is_raw ? F3_next[7:0] : F3_reg[7:0];
                            4'hD: hrdata_next[15:8] = is_raw ? F3_next[15:8] : F3_reg[15:8];

                            4'hE: hrdata_next[7:0] = is_raw ? new_coeff_next[7:0] : new_coeff_reg[7:0];
                        endcase
                    end
                    else begin
                        case (haddr)
                            4'h0: hrdata_next = status_reg;
                            4'h2: hrdata_next = result_reg;
                            4'h4: hrdata_next = is_raw ? new_sample_next : new_sample_reg;
                            4'h6: hrdata_next = is_raw ? F0_next : F0_reg;
                            4'h8: hrdata_next = is_raw ? F1_next : F1_reg;
                            4'hA: hrdata_next = is_raw ? F2_next : F2_reg;
                            4'hC: hrdata_next = is_raw ? F3_next : F3_reg;
                            4'hE: hrdata_next = is_raw ? new_coeff_next : new_coeff_reg;
                        endcase
                    end
                end
            end
        end
    end

    always_comb begin : FIR_COEFFICIENT_LOGIC
        case (coefficient_num) ////////////////////////////////////////
            2'b00: fir_coefficient = F0_reg;
            2'b01: fir_coefficient = F1_reg;
            2'b10: fir_coefficient = F2_reg;
            2'b11: fir_coefficient = F3_reg;
        endcase
    end

endmodule

