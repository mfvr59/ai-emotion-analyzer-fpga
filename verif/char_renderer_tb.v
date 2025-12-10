`timescale 1ns/1ps
module char_renderer_tb;

    // Inputs
    reg clk, reset;
    reg enable;
    reg [8:0] char_addr_offset;
    reg [10:0] vga_x;
    reg [9:0] vga_y;
    reg vga_valid;
    reg [10:0] top_left_x;
    reg [9:0] top_left_y;
    reg [3:0] scale_x;
    reg [3:0] scale_y;

    // Outputs
    wire [7:0] r, g, b;

    char_renderer dut (
        .clk(clk),
        .rst(reset),
        .enable(enable),
        .char_addr_offset(char_addr_offset),
        .vga_x(vga_x),
        .vga_y(vga_y),
        .vga_valid(vga_valid),
        .top_left_x(top_left_x),
        .top_left_y(top_left_y),
        .scale_x(scale_x),
        .scale_y(scale_y),
        .r(r), .g(g), .b(b)
    );
    
    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    wire [7:0] char_row_data = dut.char_row_data;
    wire [3:0] ascii_y = dut.ascii_y;
    wire [3:0] ascii_x = dut.ascii_x;
    wire in_bounds = dut.in_bounds;

    // Memories to store results
    reg [7:0] saved_rows [0:7];
    reg [7:0] saved_pixels [0:7];

    integer i, j;

    // Sweep an 8×8 bitmap, save all rows + pixels, then print results
    task test_character;
        input [8:0] offset;
        integer x, y;
        integer scaled_w, scaled_h;
        integer ascii_row, ascii_col;

        begin
            $display("\n=== Testing ASCII char at offset %0d ===\n", offset);

            char_addr_offset = offset;

            scaled_w = 8 * scale_x;
            scaled_h = 8 * scale_y;

            // Clear memories
            for (y = 0; y < 8; y = y + 1) begin
                saved_rows[y] = 8'b0;
                saved_pixels[y] = 8'b0;
            end

            // Sweep entire scaled block
            for (y = 0; y < scaled_h; y = y + 1) begin
                for (x = 0; x < scaled_w; x = x + 1) begin

                    vga_x = top_left_x + x;
                    vga_y = top_left_y + y;

                    #10;

                    if (in_bounds) begin
                        ascii_row = ascii_y; 
                        ascii_col = ascii_x;  

                        saved_rows[ascii_row] = char_row_data; // Save row from tcgrom

                        // 1 for pixels that are colored; 0 otherwise
                        saved_pixels[ascii_row][7 - ascii_col] = (r == 8'hFF);
                    end
                end
            end

            // ---- Print tcgrom rows ----
            $display("Bitmap rows from tcgrom:");
            for (y = 0; y < 8; y = y + 1)
                $display("Row %0d: %08b", y, saved_rows[y]);

            // ---- Print rendered output ----
            $display("\nRendered pixels:");
            for (y = 0; y < 8; y = y + 1)
                $display("%08b", saved_pixels[y]);

        end
    endtask
    

    initial begin

        reset = 1;
        #20;
        reset = 0;
    
        $display("\n=== CHAR_RENDERER MULTI-CHAR TEST ===\n");

        // Regular image
        enable = 1;
        vga_valid = 1;
        scale_x = 1;
        scale_y = 1;

        top_left_x = 40;
        top_left_y = 20;

        test_character(9'h008);   // A
        test_character(9'h010);   // B
        test_character(9'h018);   // C
        test_character(9'h020);   // D
        test_character(9'h0c0);   // X
        
        test_character(9'h188);   // 1
        test_character(9'h198);   // 3
        test_character(9'h1b0);   // 6
        test_character(9'h1c8);   // 9
                
        // Image with scaling
        enable = 1;
        vga_valid = 1;
        scale_x = 2;
        scale_y = 2;

        top_left_x = 90;
        top_left_y = 20;

        test_character(9'h028);   // E
        test_character(9'h030);   // F
        test_character(9'h038);   // G
        test_character(9'h020);   // D
        test_character(9'h0c0);   // X
        
        test_character(9'h190);   // 2
        test_character(9'h1a0);   // 4
        test_character(9'h1a8);   // 5
        test_character(9'h1b8);   // 7

        $display("\n=== END OF TEST ===\n");
        $stop;
    end

endmodule
