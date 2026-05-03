`timescale 1ns / 10ps

module coefficient_loader (input clk, n_rst,
                           input logic new_coefficient_set,
                           input logic modwait,
                           output logic load_coeff,
                           output logic [1:0] coefficient_num,
                           output logic clear_coeff);

    typedef enum bit [3:0] {
        IDLE, LOAD_F0, WAIT_F1, LOAD_F1, WAIT_F2, LOAD_F2, WAIT_F3, LOAD_F3, WAIT_LAST, CLEAR 
    } fsm_state;

    fsm_state current_state, next_state;
    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    always_comb begin : NEXT_STATE
        next_state = current_state;

        case (current_state)
            IDLE: if(new_coefficient_set && (~modwait))  next_state = LOAD_F0;
            LOAD_F0: next_state = WAIT_F1;
            WAIT_F1: if(~modwait) next_state = LOAD_F1;
            LOAD_F1: next_state = WAIT_F2;
            WAIT_F2: if(~modwait) next_state = LOAD_F2;
            LOAD_F2: next_state = WAIT_F3;
            WAIT_F3: if(~modwait) next_state = LOAD_F3;
            LOAD_F3: next_state = WAIT_LAST;
            WAIT_LAST: if(~modwait) next_state = CLEAR;
            CLEAR: next_state = IDLE;

        endcase
    end

    always_comb begin : OUTPUT
    load_coeff = 1'b0;
    coefficient_num = 2'd0;
    clear_coeff = 1'b0;

    case (current_state)
        IDLE: begin
            load_coeff = 1'b0;
            coefficient_num = 2'd0;
            clear_coeff = 1'b0;
        end

        LOAD_F0: begin
            load_coeff = 1'b1;
            coefficient_num = 2'd0;
            clear_coeff = 1'b0;
        end
        WAIT_F1: begin
            load_coeff = 1'b0;
            coefficient_num = 2'd0;
            clear_coeff = 1'b0;
        end
        LOAD_F1: begin
            load_coeff = 1'b1;
            coefficient_num = 2'd1;
            clear_coeff = 1'b0;
        end
        WAIT_F2: begin
            load_coeff = 1'b0;
            coefficient_num = 2'd1;
            clear_coeff = 1'b0;
        end
        LOAD_F2: begin
            load_coeff = 1'b1;
            coefficient_num = 2'd2;
            clear_coeff = 1'b0;
        end
        WAIT_F3: begin
            load_coeff = 1'b0;
            coefficient_num = 2'd2;
            clear_coeff = 1'b0;
        end
        LOAD_F3: begin
            load_coeff = 1'b1;
            coefficient_num = 2'd3;
            clear_coeff = 1'b0;
        end
        WAIT_LAST: begin
            load_coeff = 1'b0;
            coefficient_num = 2'd3;
            clear_coeff = 1'b0;
        end
        CLEAR: begin
            load_coeff = 1'b0;
            coefficient_num = 2'd0;
            clear_coeff = 1'b1;
        end
    endcase
end

endmodule

