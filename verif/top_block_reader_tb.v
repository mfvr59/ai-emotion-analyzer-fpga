`timescale 1ns/1ps
module top_block_reader_tb;
    
    reg clk;
    reg [8:0] block_idx_in; // block index 

    wire [15:0] note0, note1, note2, note3;
    wire [2:0]  block_size;
    wire [2:0]  prev_block_size;

    top_block_reader dut (
        .clk(clk),
        .block_idx_in(block_idx_in),

        .note0(note0),
        .note1(note1),
        .note2(note2),
        .note3(note3),

        .block_size(block_size),
        .prev_block_size(prev_block_size)
    );

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task print_block;
        begin
            #10;
            $display("block_size=%0d  prev_block_size=%0d", block_size, prev_block_size);
            $display("notes: %h  %h  %h  %h", note0, note1, note2, note3);
        end
    endtask


    initial begin
        $display("=== TESTING top_block_reader ===");
        
        $display("\nTesting Song 0"); // testing song 0
        
        // test block 1 (song 0)
        block_idx_in = 9'd0;
        $display("\nBLOCK 0");
        print_block();

        // test block 1 (song 0)
        block_idx_in = 9'd1;
        $display("\nBLOCK 1");
        print_block();

        // test block 5 (song 0)
        block_idx_in = 9'd5;
        $display("\nBLOCK 5");
        print_block();
        
        $display("\n\nTesting Song 1"); // testing song 1
        
        // test first block of song 1
        block_idx_in = 9'd16;
        $display("\nBLOCK 16 (Start of Song 1)");
        print_block();
        
        // test block 20 (song 1)
        block_idx_in = 9'd20;
        $display("\nBLOCK 20");
        print_block();
        
        // test block 24
        block_idx_in = 9'd24;
        $display("\nBLOCK 24");
        print_block();

        $display("\nDONE.");
        $finish;
    end

endmodule
