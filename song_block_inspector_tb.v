`timescale 1ns/1ps
module song_block_inspector_tb;

    reg clk;
    reg [8:0] block_idx_in;

    wire [15:0] f_out0;
    wire [15:0] f_out1;
    wire [15:0] f_out2;
    wire [15:0] f_out3;

    wire [2:0] block_size;
    wire [2:0] prev_block_size;


    song_block_inspector dut (
        .clk(clk),
        .block_idx_in(block_idx_in),

        .f_out0(f_out0),
        .f_out1(f_out1),
        .f_out2(f_out2),
        .f_out3(f_out3),

        .block_size(block_size),
        .prev_block_size(prev_block_size)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // print inspector state
    task print_block;
        integer i;
        reg [8:0] start;
        
        begin
            #10;
            
            $display("\n--- TEST BLOCK %0d ---", block_idx_in);

            $display("  block_idx       = %0d", block_idx_in);
            $display("  curr_block_size = %0d", block_size);
            $display("  prev_block_size = %0d", prev_block_size);

            start = dut.start_addr;
            $display("  start_addr(note)= %0d", start);
            $display("  Inspector window f_out = [%h %h %h %h]", f_out0, f_out1, f_out2, f_out3);
        end
    endtask

    initial begin
        
        block_idx_in = 0;   
        print_block();
        
        block_idx_in = 4;  
        print_block();
        
        block_idx_in = 8;  
        print_block();
        
        block_idx_in = 12; 
        print_block();
        
        block_idx_in = 16; 
        print_block();
        
        block_idx_in = 20; 
        print_block();
        
        block_idx_in = 24;  
        print_block();
        
        block_idx_in = 28; 
        print_block();

        $display("\n=== TEST COMPLETE ===");
        $finish;
    end

endmodule
