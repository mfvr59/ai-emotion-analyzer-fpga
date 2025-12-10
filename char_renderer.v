module char_renderer (
    input wire clk,
    input wire rst,
    input wire enable,

    input wire [8:0] char_addr_offset, 

    input wire [10:0] vga_x,
    input wire [9:0] vga_y,
    input wire vga_valid,

    input wire [10:0] top_left_x,
    input wire [9:0] top_left_y,

    input wire [3:0] scale_x,  // horizontal scale factor
    input wire [3:0] scale_y,  // vertical scale factor

    // output rgb
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);

    // Scaled dimensions
    wire [9:0] scaled_w = 8 * scale_x;  // e.g. 8*4 = 32
    wire [9:0] scaled_h = 8 * scale_y;

    // Check if current vga coordinates are within bounds
    wire in_x = (vga_x >= top_left_x) && (vga_x < top_left_x + scaled_w);
    wire in_y = (vga_y >= top_left_y) && (vga_y < top_left_y + scaled_h);
    wire in_bounds = in_x && in_y && enable && vga_valid; 

    // Scaled x and y coordinates
    wire [9:0] local_x = in_x ? (vga_x - top_left_x) : 10'd0;
    wire [9:0] local_y = in_y ? (vga_y - top_left_y) : 10'd0;

    // Original ascii bitmap coordinates
    wire [8:0] ascii_x = local_x / scale_x; // 0..7
    wire [8:0] ascii_y = local_y / scale_y; // 0..7

    wire [7:0] char_row_d;
    wire [7:0] char_row_data;

    tcgrom char_rom_0 (.addr(char_addr_offset + ascii_y), .data(char_row_d));
    dffr #(.WIDTH(8)) ff_char_row (.clk(clk), .r(rst), .d(char_row_d), .q(char_row_data));

    // Determine if the pixel should be on or off
    wire color_pixel = char_row_data[7 - ascii_x] && in_bounds;

    assign {r, g, b} = color_pixel ? 24'hFFFFFF : {3{8'b0}};

endmodule