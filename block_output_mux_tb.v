`timescale 1ns/1ps 
module block_output_mux_tb;
    
    reg [2:0] block_size;
    reg [15:0] f_out0, f_out1, f_out2, f_out3;

    wire [15:0] note0, note1, note2, note3;

    block_output_mux dut (
        .block_size(block_size),
        .f_out0(f_out0), .f_out1(f_out1), .f_out2(f_out2), .f_out3(f_out3),
        .note0(note0), .note1(note1), .note2(note2), .note3(note3)
    );

    // clock 
    reg clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task show_notes;
        begin
            #10; 
            $display("Notes to display: %0d\n", block_size);
            $display("time=%0t | block_size=%0d | notes=%h %h %h %h\n", $time, block_size, note0, note1, note2, note3);
        end
    endtask

    initial begin
        $display("\n=== block_output_mux TEST START ===");

        // fake ROM values
        f_out0 = 16'h1111;
        f_out1 = 16'h2222;
        f_out2 = 16'h3333;
        f_out3 = 16'h4444;        

        #10;

        $display("\n--- TESTING DIFFERENT BLOCK SIZES; ALL OTHER NOTES 0000 ---\n");

        $display("--- BLOCK SIZE 3 ---\n");
        block_size = 3;
        show_notes();

        $display("--- BLOCK SIZE 1 ---\n");
        block_size = 1;
        show_notes();

        $display("--- BLOCK SIZE 4 ---\n");
        block_size = 4;
        show_notes();

        // NO PULSE (hold previous values)
        $display("\n--- HOLD (No change in block size) ---\n");
        block_size = 4;         
        show_notes();

        $display("--- BLOCK_SIZE 0 ---\n");
        block_size = 0;     
        show_notes();  // should return blanks

        $display("\n=== TEST COMPLETE ===");
        $finish;
    end

endmodule
