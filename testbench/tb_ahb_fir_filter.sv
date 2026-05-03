`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_ahb_fir_filter ();

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


    string status;
    ahb_fir_filter DUT (.clk(clk), .n_rst(n_rst),
                    .hsel(hsel), .haddr(haddr),
                    .hsize(hsize[0]), .htrans(htrans),
                    .hwrite(hwrite), .hwdata(hwdata),
                    .hrdata(hrdata), .hresp(hresp));

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

    task store_coeffs;
        input logic [15:0] F0;
        input logic [15:0] F1;
        input logic [15:0] F2;
        input logic [15:0] F3;
        begin
            status = "coeffs";
            enqueue_transaction(1, 1, 4'h6, F0, 0, 1);
            enqueue_transaction(1, 1, 4'h8, F1, 0, 1);
            enqueue_transaction(1, 1, 4'hA, F2, 0, 1);
            enqueue_transaction(1, 1, 4'hC, F3, 0, 1);

            enqueue_transaction(1, 1, 4'hE, 8'h1, 0, 0);
            
            execute_transactions(5);

        end
    endtask

    task take_sample;
        input logic [15:0] data;
        begin
            enqueue_transaction(1, 1, 4'h4, data, 0, 1);
            execute_transactions(1);
            #(15 * CLK_PERIOD);

            enqueue_transaction(1, 0, 4'h2, data, 0, 1);
            execute_transactions(1);

        end
    endtask
    
    integer i;
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

        reset_model();
        reset_dut();

        store_coeffs(16'h8000, 16'h8000, 16'h8000, 16'h8000);
        
        // wait for status reg to be 0
        for(i = 0; i < 9; i++) begin
            enqueue_transaction(1, 0, 4'h0, 16'h0001, 0, 1);
        end
        execute_transactions(10);

        enqueue_transaction(1, 0, 4'h0, 16'h0000, 0, 1);
        execute_transactions(1);

        // sample 1
        status = "sample 1";
        take_sample(16'h0002);
        status = "sample 2";
        take_sample(16'h0006);
        status = "sample 3";
        take_sample(16'h000E);
        status = "sample 4";
        take_sample(16'h0008);
        // status = "sample 5";
        // take_sample(16'h0002);
        // status = "overflow";
        // take_sample(16'hFFFF);
        // status = "sample 6";
        // take_sample(16'hFFFF);

        store_coeffs(16'h8000, 16'h4000, 16'h8000, 16'h4000);
        
        // wait for status reg to be 0
        for(i = 0; i < 9; i++) begin
            enqueue_transaction(1, 0, 4'h0, 16'h0001, 0, 1);
        end
        execute_transactions(10);

        enqueue_transaction(1, 0, 4'h0, 16'h0000, 0, 1);
        execute_transactions(1);

        status = "sample new coeff";
        take_sample(16'h0004);
        $finish;
    end
endmodule

/* verilator coverage_on */

