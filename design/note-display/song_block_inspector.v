module song_block_inspector (
    input  wire clk,
    input  wire rst,

    input  wire [8:0] block_idx_in,
    input  wire [1:0] song_sel,

    output wire [15:0] f_out0,
    output wire [15:0] f_out1,
    output wire [15:0] f_out2,
    output wire [15:0] f_out3,

    output wire [2:0] block_size,
    output wire [2:0] prev_block_size
);

    localparam [8:0] MAX_SONG_NOTE_ADDR = 9'd447;

    // ----- song metadata -----
    wire [14:0] meta_out;   // {start_addr[14:6], prev_size[5:3], curr_size[2:0]}
    block_rom meta (
        .clk(clk),
        .addr(block_idx_in),
        .dout(meta_out)
    );

    wire [8:0] start_addr = meta_out[14:6];
    assign prev_block_size = meta_out[5:3];
    assign block_size      = meta_out[2:0];

    // ----- addresses inside song_rom -----
    wire [8:0] a0 = start_addr;
    wire [8:0] a1 = start_addr + 9'd1;
    wire [8:0] a2 = start_addr + 9'd2;
    wire [8:0] a3 = start_addr + 9'd3;

    wire [8:0] f_addr0 = a0;
    wire [8:0] f_addr1 = (a1 <= MAX_SONG_NOTE_ADDR) ? a1 : MAX_SONG_NOTE_ADDR;
    wire [8:0] f_addr2 = (a2 <= MAX_SONG_NOTE_ADDR) ? a2 : MAX_SONG_NOTE_ADDR;
    wire [8:0] f_addr3 = (a3 <= MAX_SONG_NOTE_ADDR) ? a3 : MAX_SONG_NOTE_ADDR;

    // ----- actual song ROM lookups -----
    song_rom rom0 (.clk(clk), .addr(f_addr0), .dout(f_out0));
    song_rom rom1 (.clk(clk), .addr(f_addr1), .dout(f_out1));
    song_rom rom2 (.clk(clk), .addr(f_addr2), .dout(f_out2));
    song_rom rom3 (.clk(clk), .addr(f_addr3), .dout(f_out3));

endmodule
