`timescale 1ns/1ps
module map_rom_tb;
    reg [5:0] note_idx;
    wire [8:0] left_char;
    wire [8:0] right_char;

    map_rom dut (.note_idx(note_idx), .left_char(left_char), .right_char(right_char));
    
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            note_idx = i;
            #10; 
            $display("Note Index: %0d | Left Char: %h | Right Char: %h", note_idx, left_char, right_char);
        end
    end

endmodule
