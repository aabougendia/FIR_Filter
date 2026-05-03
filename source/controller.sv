`timescale 1ns / 10ps

module controller (input clk, n_rst,
                   input dr, lc, overflow,
                   output logic cnt_up, clear, modwait,
                   output logic [2:0] op,
                   output logic [3:0] src1, src2, dest,
                   output logic err);

    typedef enum bit [4:0] {
        IDLE, LOAD_F0, WAIT_F1, LOAD_F1, WAIT_F2, LOAD_F2, WAIT_F3,
        LOAD_F3, LOAD_SAMPLE, SHIFT_D2, SHIFT_D1, SHIFT_D0, COPY_SAMPLE,
        MUL0, MUL1, ADD1, MUL2, ADD2, MUL3, ADD3, ERROR
    } fsm_state_t;


    localparam NOP = 3'b000;
    localparam COPY = 3'b001;
    localparam LOAD1 = 3'b010;
    localparam LOAD2 = 3'b011;
    localparam ADD = 3'b100;
    localparam SUB = 3'b101;
    localparam MUL = 3'b110;

    localparam R0 = 4'd0;
    localparam R1 = 4'd1;
    localparam R2 = 4'd2;
    localparam R3 = 4'd3;
    localparam R4 = 4'd4;
    localparam R5 = 4'd5;
    localparam R6 = 4'd6;
    localparam R7 = 4'd7;
    localparam R8 = 4'd8;
    localparam R9 = 4'd9;
    localparam R10 = 4'd10;
    localparam R11 = 4'd11;
    localparam R12 = 4'd12;
    localparam R13 = 4'd13;
    localparam R14 = 4'd14;
    localparam R15 = 4'd15;

    fsm_state_t current_state, next_state;
    logic modwait_next;

    always_ff @(posedge clk, negedge n_rst) begin
        if(~n_rst) begin
            current_state <= IDLE;
            modwait <= 1'b0;
        end
        else begin
            current_state <= next_state;
            modwait <= modwait_next;
        end
    end

    always_comb begin : NEXT_STATE
        next_state = current_state;

        case (current_state)

        IDLE:   if(lc && !dr)          next_state = LOAD_F0;
                else if (!lc && dr)    next_state = LOAD_SAMPLE;

        LOAD_F0:    next_state = WAIT_F1;

        WAIT_F1:    if(lc)  next_state = LOAD_F1;

        LOAD_F1:    next_state = WAIT_F2;

        WAIT_F2:    if(lc)  next_state = LOAD_F2;

        LOAD_F2:    next_state = WAIT_F3;

        WAIT_F3:    if(lc)  next_state = LOAD_F3;

        LOAD_F3:    next_state = IDLE;

        LOAD_SAMPLE:    if(dr)  next_state = SHIFT_D2;
                        else    next_state = ERROR;

        SHIFT_D2:   next_state = SHIFT_D1;

        SHIFT_D1:   next_state = SHIFT_D0;

        SHIFT_D0:   next_state = COPY_SAMPLE;

        COPY_SAMPLE: next_state = MUL0;

        MUL0:   if(!overflow)   next_state = MUL1;
                else            next_state = ERROR; 

        
        MUL1:   if(!overflow)   next_state = ADD1;
                else            next_state = ERROR;

        ADD1:   if(!overflow)   next_state = MUL2;
                else            next_state = ERROR;
        
        MUL2:   if(!overflow)   next_state = ADD2;
                else            next_state = ERROR;
        
        ADD2:   if(!overflow)   next_state = MUL3;
                else            next_state = ERROR;
        
        MUL3:   if(!overflow)   next_state = ADD3;
                else            next_state = ERROR;
        
        ADD3:   if(!overflow)   next_state = IDLE;
                else            next_state = ERROR;

        ERROR:  if(lc)          next_state = LOAD_F0;
                else if(dr)     next_state = LOAD_SAMPLE;

        endcase
    end

    always_comb begin : OUTPUT
        cnt_up = 1'b0;
        clear = 1'b0;
        op = 3'b000;
        src1 = 4'd0;
        src2 = 4'd0;
        dest = 4'd0;
        err = 1'b0;

        case (current_state)

        IDLE: begin
        end      
                
        LOAD_F0: begin  
                        op = LOAD2;
                        dest = R5;
                        clear = 1;
        end

        WAIT_F1: begin
        end   

        LOAD_F1: begin  
                        op = LOAD2;
                        dest = R6;
        end

        WAIT_F2: begin
        end    

        LOAD_F2: begin       
                        op = LOAD2;
                        dest = R7;
        end

        WAIT_F3: begin
        end 

        LOAD_F3: begin  
                        op = LOAD2;
                        dest = R8;
        end

        LOAD_SAMPLE: begin     
                                op = LOAD1;
                                dest = R10;   
        end

        SHIFT_D2: begin        
                                op = COPY;
                                src1 = R3;
                                dest = R4;
        end

        SHIFT_D1: begin         
                                op = COPY;
                                src1 = R2;
                                dest = R3;
        end

        SHIFT_D0: begin        
                                op = COPY;
                                src1 = R1;
                                dest = R2;
        end

        COPY_SAMPLE: begin      
                                op = COPY;
                                src1 = R10;
                                dest = R1;
                                cnt_up = 1;
        end

        MUL0: begin             
                                op = MUL;
                                src1 = R5;
                                src2 = R1;
                                dest = R0;
        end

        MUL1: begin          
                                op = MUL;
                                src1 = R6;
                                src2 = R2;
                                dest = R10;
        end

        ADD1: begin           
                                op = SUB;
                                src1 = R0;
                                src2 = R10;
                                dest = R0;
        end
        
        MUL2: begin            
                                op = MUL;
                                src1 = R7;
                                src2 = R3;
                                dest = R10;
        end
        
        ADD2: begin            
                                op = ADD;
                                src1 = R0;
                                src2 = R10;
                                dest = R0;
        end
        
        MUL3: begin         
                                op = MUL;
                                src1 = R8;
                                src2 = R4;
                                dest = R10;
        end
        
        ADD3: begin           
                                op = SUB;
                                src1 = R0;
                                src2 = R10;
                                dest = R0;
        end

        ERROR: begin            err = 1;
        end
        endcase
    end

    always_comb begin : MODWAIT_LOGIC
        case (next_state)
                IDLE, WAIT_F1, WAIT_F2, WAIT_F3, ERROR: modwait_next = 0;
                default: modwait_next = 1;
        endcase
    end

endmodule

