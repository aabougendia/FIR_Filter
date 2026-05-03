`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ahb_subordinate ();

    localparam CLK_PERIOD = 20ns;

    logic clk, n_rst;

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

    

    // bus model signals
    logic enqueue_transaction_en;
    logic transaction_write;
    logic transaction_fake;
    logic [3:0] transaction_addr;
    logic [15:0] transaction_data;
    logic transaction_error;
    logic [2:0] transaction_size;

    logic model_reset;
    logic enable_transactions;
    integer current_transaction_num;
    logic current_transaction_error;

    logic hsel;
    logic [1:0] htrans;
    logic [3:0] haddr;
    logic [2:0] hsize;
    logic hwrite;
    logic [15:0] hwdata;
    logic [15:0] hrdata;
    logic hresp;

    logic [15:0] fir_out;
    logic err;
    logic data_ready;
    logic [15:0] sample_data;
    logic modwait;
    logic new_coefficient_set;
    logic clear_coeff;
    logic load_coeff;
    logic [1:0] coefficient_num;
    logic [15:0] fir_coefficient;

    ahb_subordinate DUT(.clk(clk), .n_rst(n_rst), .clear_coeff(clear_coeff), .coefficient_num(coefficient_num),
                        .modwait(modwait), .fir_out(fir_out), .err(err), .hsel(hsel), .haddr(haddr), .hsize(hsize), .htrans(htrans),
                        .hwrite(hwrite), .hwdata(hwdata), .sample_data(sample_data), .data_ready(data_ready), .new_coefficient_set(new_coefficient_set),
                        .fir_coefficient(fir_coefficient), .hrdata(hrdata), .hresp(hresp));

    ahb_model BFM (.clk(clk),
        // Testing setup signals
        .enqueue_transaction(enqueue_transaction_en),
        .transaction_write(transaction_write),
        .transaction_fake(transaction_fake),
        .transaction_addr(transaction_addr),
        .transaction_data(transaction_data),
        .transaction_error(transaction_error),
        .transaction_size(transaction_size),
        // Testing controls
        .model_reset(model_reset),
        .enable_transactions(enable_transactions),
        .current_transaction_num(current_transaction_num),
        .current_transaction_error(current_transaction_error),
        // AHB-Subordinate Side
        .hsel(hsel),
        .htrans(htrans),
        .haddr(haddr),
        .hsize(hsize),
        .hwrite(hwrite),
        .hwdata(hwdata),
        .hrdata(hrdata),
        .hresp(hresp)
    );

    // bus model tasks
    task reset_model;
    begin
        model_reset = 1'b1;
        #(0.1);
        model_reset = 1'b0;
    end
    endtask
    
    task enqueue_transaction;
        input logic for_dut;
        input logic write_mode;
        input logic [3:0] address;
        input logic [15:0] data;
        input logic expected_error;
        input logic size;
    begin
        // Make sure enqueue flag is low (will need a 0->1 pulse later)
        enqueue_transaction_en = 1'b0;
        #(0.1ns);
    
        // Setup info about transaction
        transaction_fake  = ~for_dut;
        transaction_write = write_mode;
        transaction_addr  = address;
        transaction_data  = data;
        transaction_error = expected_error;
        transaction_size  = {2'b00,size};
    
        // Pulse the enqueue flag
        enqueue_transaction_en = 1'b1;
        #(0.1ns);
        enqueue_transaction_en = 1'b0;
    end
    endtask
    
    task execute_transactions;
        input integer num_transactions;
        integer wait_var;
    begin
        // Activate the bus model
        enable_transactions = 1'b1;
        @(posedge clk);
    
        // Process the transactions (all but last one overlap 1 out of 2 cycles
        for(wait_var = 0; wait_var < num_transactions; wait_var++) begin
            @(posedge clk);
        end
    
        // Run out the last one (currently in data phase)
        @(posedge clk);
    
        // Turn off the bus model
        @(negedge clk);
        enable_transactions = 1'b0;
    end
    endtask

// Correct operation during Manager reads of the AHB-Subordinate Interface's result register
// Correct operation during Manager reads of the AHB-Subordinate Interface's new sample register
// Correct operation during Manager reads of the AHB-Subordinate Interface's status register
// Correct operation during Manager reads of the AHB-Subordinate Interface's coefficient-related registers
// Correct operation during Manager writes to the AHB-Subordinate Interface's result register
// Correct operation during Manager writes to the AHB-Subordinate Interface's new sample register
// Correct operation during Manager writes to the AHB-Subordinate Interface's status register
// Correct operation during Manager writes to the AHB-Subordinate Interface's coefficient-related registers
    string status;
    initial begin
        n_rst = 1;
        status = "setup";

        model_reset = 1'b0;
        enable_transactions = 1'b0;
        enqueue_transaction_en = 1'b0;
        transaction_write = 1'b0;
        transaction_fake = 1'b0;
        transaction_addr = '0;
        transaction_data = '0;
        transaction_error = 1'b0;
        transaction_size = 3'd0;   


        clear_coeff = 0;
        coefficient_num = 0;
        modwait = 0;
        fir_out = 0;
        err = 0;     
        status = "setup";


        reset_model();
        reset_dut();

        @(negedge clk);
        n_rst = 1;
        @(negedge clk);

        status = "transactions";
        fir_out = 16'hAAAA;

        // read from result reg
        enqueue_transaction(1'b1, 1'b0, 4'h2, 16'hAAAA, 1'b0, 1'b1);

        modwait = 1;
        // read from status reg
        enqueue_transaction(1'b1, 1'b0, 4'h0, 16'h0001, 1'b0, 1'b1);

        // write to new sample reg
        enqueue_transaction(1'b1, 1'b1, 4'h4, 16'hABCD, 1'b0, 1'b1);

        // write to F0 reg (lower)
        enqueue_transaction(1'b1, 1'b1, 4'h6, 16'hCCCC, 1'b0, 1'b0);
        // write to F0 reg (upper)
        enqueue_transaction(1'b1, 1'b1, 4'h7, 16'hBBBB, 1'b0, 1'b0);

        // read from F0 reg (raw hazard)
        enqueue_transaction(1'b1, 1'b0, 4'h6, 16'hBBCC, 1'b0, 1'b1);

        // read from new sample reg
        enqueue_transaction(1'b1, 1'b0, 4'h4, 16'hABCD, 1'b0, 1'b1);

        // read form F0 reg (lower)
        enqueue_transaction(1'b1, 1'b0, 4'h6, 16'h00CC, 1'b0, 1'b0);
        
        // write to result reg (hresp)
        enqueue_transaction(1'b1, 1'b1, 4'h2, 16'hEEEE, 1'b1, 1'b1);

        execute_transactions(9);

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        $finish;
    end
endmodule

/* verilator coverage_on */

